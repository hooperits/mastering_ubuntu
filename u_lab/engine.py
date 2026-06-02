import base64
import os
import subprocess
import time
from typing import Dict, Any, Optional, Tuple
import docker
from rich.console import Console
from rich.panel import Panel
from rich.table import Table

console = Console()

class EngineManager:
    def __init__(self):
        self.client = self._get_client()

    def _get_client(self) -> docker.DockerClient:
        """Returns Docker Client or raises error if daemon is offline."""
        try:
            client = docker.from_env()
            client.ping()
            return client
        except Exception as e:
            raise RuntimeError(
                "Docker daemon is not running or accessible. "
                "Please start Docker and ensure permissions are configured correctly."
            ) from e

    def is_docker_active(self) -> bool:
        """Returns True if Docker daemon is online, False otherwise."""
        try:
            self.client.ping()
            return True
        except Exception:
            return False

    def container_exists(self, container_name: str) -> bool:
        """Checks if a container exists."""
        try:
            self.client.containers.get(container_name)
            return True
        except docker.errors.NotFound:
            return False

    def get_container(self, container_name: str) -> Optional[docker.models.containers.Container]:
        """Gets active container object if it exists."""
        try:
            return self.client.containers.get(container_name)
        except docker.errors.NotFound:
            return None

    def start_container(self, lab_id: str, lab_data: Dict[str, Any]) -> docker.models.containers.Container:
        """Stops/prunes existing lab container, and launches a fresh one."""
        container_name = f"u-lab-{lab_id}"
        
        # Stop and remove existing container if present
        self.destroy_container(lab_id)

        metadata = lab_data["metadata"]
        container_config = metadata.get("container", {})

        image_name = container_config.get("image", "u-lab-base:latest")
        hostname = container_config.get("hostname", "ubuntu-server")
        privileged = container_config.get("privileged", False)
        
        # Parse port configurations
        ports = container_config.get("ports", [])
        port_bindings = {}
        for p in ports:
            parts = p.split(":")
            if len(parts) == 2:
                port_bindings[parts[1]] = parts[0]

        # Parse volumes configurations
        volumes = container_config.get("volumes", [])
        volume_bindings = {}
        for v in volumes:
            parts = v.split(":")
            if len(parts) >= 2:
                host_path = os.path.expanduser(parts[0])
                bind_path = parts[1]
                mode = parts[2] if len(parts) > 2 else "rw"
                if bind_path == "/sys/fs/cgroup":
                    mode = "rw"
                volume_bindings[host_path] = {"bind": bind_path, "mode": mode}

        cap_add = container_config.get("cap_add", [])

        # Build custom image if base is requested but missing
        if image_name == "u-lab-base:latest":
            self._ensure_base_image()

        # In Docker, running systemd requires /sbin/init or /lib/systemd/systemd
        command = "/sbin/init" if privileged else "sleep infinity"

        # Start container
        container = self.client.containers.run(
            image=image_name,
            name=container_name,
            hostname=hostname,
            ports=port_bindings,
            volumes=volume_bindings,
            privileged=privileged,
            cap_add=cap_add,
            cgroupns="host",
            detach=True,
            stdin_open=True,
            tty=True,
            command=command
        )

        # Give systemd a moment to boot
        if privileged:
            time.sleep(1.5)

        # Run setup script if defined
        setup_path = lab_data.get("setup_path")
        if setup_path and os.path.exists(setup_path):
            self.run_script_in_container(container, setup_path, "setup.sh")

        return container

    def _ensure_base_image(self) -> None:
        """Builds u-lab-base:latest image locally if it does not exist."""
        try:
            self.client.images.get("u-lab-base:latest")
        except docker.errors.ImageNotFound:
            console.print("[yellow]u-lab-base:latest not found. Building base image...[/yellow]")
            # Resolve Dockerfile.base relative to repo root
            repo_root = os.path.dirname(os.path.dirname(__file__))
            dockerfile_path = os.path.join(repo_root, "Dockerfile.base")
            if not os.path.exists(dockerfile_path):
                # Fallback: create default minimal base dockerfile contents dynamically
                self._write_default_dockerfile_base(dockerfile_path)
            
            log_generator = self.client.api.build(
                path=repo_root,
                dockerfile="Dockerfile.base",
                tag="u-lab-base:latest",
                rm=True,
                decode=True
            )
            for chunk in log_generator:
                if 'stream' in chunk:
                    text = chunk['stream'].strip()
                    if text:
                        console.print(f"[dim]{text}[/dim]")
                elif 'errorDetail' in chunk:
                    raise RuntimeError(f"Docker build failed: {chunk['errorDetail']['message']}")
            console.print("[green]Base image u-lab-base:latest built successfully![/green]")

    def _write_default_dockerfile_base(self, path: str) -> None:
        content = """FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \\
    systemd \\
    systemd-sysv \\
    sudo \\
    nginx \\
    net-tools \\
    iproute2 \\
    curl \\
    ufw \\
    iptables \\
    openssh-client \\
    openssh-server \\
    && apt-get clean \\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Configure systemd inside container
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/sbin/init"]
"""
        with open(path, "w") as f:
            f.write(content)

    def run_script_in_container(self, container: docker.models.containers.Container, script_path: str, dest_name: str) -> Tuple[int, str]:
        """Copies and runs a script inside container using base64 encoding to prevent shell escapes."""
        with open(script_path, "r") as f:
            content = f.read()

        b64_content = base64.b64encode(content.encode("utf-8")).decode("utf-8")
        tmp_dir = "/tmp/u-lab"
        dest_path = f"{tmp_dir}/{dest_name}"

        # Setup temp script folder
        container.exec_run(f"mkdir -p {tmp_dir}")
        # Pipe base64 content
        container.exec_run(["/bin/bash", "-c", f"echo {b64_content} | base64 -d > {dest_path}"])
        container.exec_run(f"chmod +x {dest_path}")

        # Execute
        result = container.exec_run(["/bin/bash", dest_path])
        return result.exit_code, result.output.decode("utf-8")

    def attach_container(self, lab_id: str) -> None:
        """Attaches interactive host terminal shell inside container."""
        container_name = f"u-lab-{lab_id}"
        if not self.container_exists(container_name):
            console.print(f"[red]Container {container_name} is not running. Start it first using 'u-lab start {lab_id}'[/red]")
            return

        console.print(f"[bold green]Attaching shell to {container_name}... Type 'exit' to detach.[/bold green]")
        subprocess.call(["docker", "exec", "-it", container_name, "/bin/bash"])

    def verify_lab(self, lab_id: str, lab_data: Dict[str, Any]) -> Tuple[bool, str]:
        """Runs the verification script and parses output to confirm completion."""
        container_name = f"u-lab-{lab_id}"
        container = self.get_container(container_name)
        if not container:
            return False, "Container is not running. Please start it using 'u-lab start'."

        verify_path = lab_data.get("verify_path")
        if not verify_path or not os.path.exists(verify_path):
            return False, "Verification script verify.sh is missing for this lab."

        exit_code, output = self.run_script_in_container(container, verify_path, "verify.sh")
        passed = (exit_code == 0)
        return passed, output

    def destroy_container(self, lab_id: str) -> bool:
        """Stops and removes the lab container if active."""
        container_name = f"u-lab-{lab_id}"
        container = self.get_container(container_name)
        if container:
            try:
                container.stop(timeout=2)
                container.remove()
                return True
            except Exception:
                pass
        return False
