# Research & Design Decisions: Labyrinth Lab Engine

## Decision 1: Interactive Shell Attachment

- **Problem**: How to drop the user into the container's interactive shell.
- **Option A**: Use Python Docker SDK socket streams to pipe host stdin/stdout directly to the container exec stream.
- **Option B**: Delegate to the system command `docker exec -it <container> /bin/bash`.
- **Selected**: **Option B**
- **Rationale**: Routing raw interactive terminals in Python (handling raw mode, resize signals, control characters like Ctrl+C) is notoriously complex and error-prone. Invoking the host's native `docker` command via Python's standard `subprocess` or `os.system` provides a bulletproof user experience that respects existing terminal configurations, cursor keys, and colors.
- **Implementation**: `os.system(f"docker exec -it {container_name} /bin/bash")`

---

## Decision 2: Verification Execution Framework

- **Problem**: How to check configurations programmatically and report results.
- **Option A**: Run python assertions from the host using Python Docker SDK APIs (e.g. reading files, ports).
- **Option B**: Run a bash/python test script *inside* the container and check its exit status and output.
- **Selected**: **Option B**
- **Rationale**: By running the verification script inside the target container, we can utilize native Linux utilities (`systemctl`, `netstat`, `ufw status`, standard command outputs) without translating everything to python-docker SDK calls. This keeps the lab validation logic simple, readable, and consistent with what an administrator would do.
- **Implementation**: The CLI will copy the lab's `verify.sh` to `/tmp/verify.sh` in the container, execute it using `container.exec_run("bash /tmp/verify.sh")`, capture stdout/stderr, and inspect the exit code (0 = Pass, other = Fail).

---

## Decision 3: Lab Base Image Build Strategy

- **Problem**: The official `ubuntu:24.04` docker image is extremely stripped down. It lacks `systemd`, `sudo`, `nginx`, `net-tools`, and network configuration helpers.
- **Option A**: Run `apt-get update && apt-get install -y ...` inside the container setup script every time a lab starts.
- **Option B**: Build a custom base Docker image `u-lab-base` containing all required utilities once, and use it as the base image for labs.
- **Selected**: **Option B**
- **Rationale**: Running apt-get install during every startup makes `u-lab start` very slow and dependent on network speed (violating SC-001). Building a custom local base image containing systemd and utilities ensures lab containers spin up in <2 seconds.
- **Implementation**: We will compile a simple `Dockerfile.base` inside `u_lab/` to generate `u-lab-base:latest`.
