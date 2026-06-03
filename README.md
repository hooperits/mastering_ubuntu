<p align="center">
  <img src="assets/labyrinth_logo.png" alt="Labyrinth Logo" width="120" height="120">
</p>

# 🚀 Labyrinth: Interactive Ubuntu Server Mastery Sandbox

<p align="center">
  <img src="assets/labyrinth_banner.png" alt="Labyrinth Banner" width="100%">
</p>

<p align="center">
  <a href="https://python.org"><img src="https://img.shields.io/badge/Python-3.10%2B-blue?style=for-the-badge&logo=python&logoColor=white" alt="Python 3.10+"></a>
  <a href="https://docker.com"><img src="https://img.shields.io/badge/Docker-Supported-blue?style=for-the-badge&logo=docker&logoColor=white" alt="Docker"></a>
  <a href="https://ubuntu.com"><img src="https://img.shields.io/badge/Ubuntu-24.04%20LTS-orange?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu 24.04 LTS"></a>
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License MIT">
</p>

Labyrinth is an automated, hands-on learning CLI that spins up isolated Ubuntu Server containers locally, presents configuration scenarios, and runs real-time verifiers to check your work.


## 🛠️ Prerequisites & Installation

Labyrinth requires **Python 3.10+** and **Docker** to build and run the sandboxed server environments. Follow the steps below for your operating system.

### 🐍 1. Install Python 3.10+

Ensure you have Python 3.10 or higher installed:

*   **Ubuntu / Debian**:
    ```bash
    sudo apt update
    sudo apt install python3 python3-venv python3-pip -y
    ```
*   **macOS** (via Homebrew):
    ```bash
    brew install python
    ```
*   **Windows** (via winget):
    ```powershell
    winget install Python.Python.3.12
    ```

---

### 🐳 2. Install Docker

Docker must be installed, running, and configured for non-root execution:

*   **Ubuntu / Debian (Docker Engine)**:
    ```bash
    # Install Docker Engine
    sudo apt update && sudo apt install docker.io -y

    # Configure Non-Root Group Permissions (CRITICAL)
    sudo usermod -aG docker $USER

    # Apply group changes immediately
    newgrp docker
    ```
*   **macOS & Windows (Docker Desktop)**:
    1. Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/).
    2. Start the Docker Desktop application and ensure the engine is fully active.

---

### 🔍 3. Verify Prerequisites

Confirm both dependencies are correctly installed and configured:

```bash
# Verify Python version (should be 3.10+)
python3 --version

# Verify Docker runs without sudo (must return active container list or header)
docker ps
```

---

## ⚡ Quick Start

1. Create a Python Virtual Environment:
   ```bash
   python3 -m venv .venv
   ```
2. Activate and install dependencies:
   ```bash
   .venv/bin/pip install -r requirements.txt
   .venv/bin/pip install -e .
   ```
3. Run the CLI tool:
   ```bash
   .venv/bin/u-lab --help
   ```

---

## 🕹️ CLI Command Reference

Below is a reference guide for managing Labyrinth lab environments:

| Command | Action | Description |
|:---|:---|:---|
| `.venv/bin/u-lab list` | **List Labs** | Display the current labs catalog and completion progress. |
| `.venv/bin/u-lab start <lab-id>` | **Start Lab** | Build the base Docker image (if missing), spin up the container, and initialize the lab. |
| `.venv/bin/u-lab attach <lab-id>` | **Enter Shell** | Attach terminal interactively inside the Ubuntu container to start configuring. |
| `.venv/bin/u-lab check <lab-id>` | **Verify Lab** | Run the verification test suite inside the active container. If tests pass, lab is marked complete. |
| `.venv/bin/u-lab destroy <lab-id>` | **Clean Up** | Stop and delete the active lab container instance. |

---

## 📚 Curriculum Plan

| Lab | Title | Focus Area / Key Concepts | Status | Documentation / Learn More |
|:---:|:---|:---|:---:|:---|
| [**01**](#lab-01) | **Systemd Service Mastery** | Fix crashing services, least-privilege users, auto-restart policies | Ready! 🚀 | [Ubuntu Server Docs](https://ubuntu.com/server/docs) • [Red Hat: systemd Auto-recovery](https://www.redhat.com/en/blog/systemd-automate-recovery) |
| [**02**](#lab-02) | **Network & Firewall Engineering** | Netplan static IPs, UFW rule verification, routing | Ready! 🚀 | [Network](https://ubuntu.com/server/docs/network-configuration) • [UFW](https://ubuntu.com/server/docs/security-firewall) |
| [**03**](#lab-03) | **Permissions & Security Hardening** | ACLs, sudoers limit, sshd passwordless auth config | Ready! 🚀 | [SSH](https://ubuntu.com/server/docs/openssh-server) • [Users](https://ubuntu.com/server/docs/user-management) |
| [**04**](#lab-04) | **Storage & LVM Partitioning** | Partitions, logical volumes, fstab persistence | Ready! 🚀 | [LVM Storage](https://ubuntu.com/server/docs/how-to/storage/manage-logical-volumes/) |
| [**05**](#lab-05) | **Package Management & Compilation** | Apt sources, PPAs, library compilation | Ready! 🚀 | [Apt Packages](https://ubuntu.com/server/docs/package-management) |
| [**06**](#lab-06) | **Web Server & Reverse Proxy Design** | Nginx setup, self-signed SSL, log rotation | Ready! 🚀 | [Nginx Web Server](https://ubuntu.com/server/docs/how-to/web-services/install-nginx/) |
| [**07**](#lab-07) | **System Automation & Timers** | Backup scripts, systemd services, daily timers | Ready! 🚀 | [Shell Backups](https://ubuntu.com/server/docs/backups-shell-scripts) |
| [**08**](#lab-08) | **System Diagnostics & Performance** | Diagnose memory leaks, kill runaway processes, inode limits | Ready! 🚀 | [Ubuntu Server Docs](https://ubuntu.com/server/docs) |
| [**09**](#lab-09) | **PAM Security & User Hardening** | PAM login restrictions, password complexity, lockouts | Ready! 🚀 | [User Management](https://ubuntu.com/server/docs/user-management) |
| [**10**](#lab-10) | **AppArmor Security Profiles** | AppArmor profiles, restrict system daemon directory access | Ready! 🚀 | [AppArmor MAC](https://ubuntu.com/server/docs/security-apparmor) |
| [**11**](#lab-11) | **System Log Auditing & Monitoring** | Parse auth logs, extract malicious IPs, firewall drop rules | Ready! 🚀 | [Security](https://ubuntu.com/server/docs/security) • [UFW](https://ubuntu.com/server/docs/security-firewall) |
| [**12**](#lab-12) | **Container Engine Deployments** | Nested container engines, Docker-in-Docker, bridge networks | Ready! 🚀 | [Docker Guide](https://ubuntu.com/server/docs/docker-for-system-admins) |

## 📖 Detailed Lab Scenarios & Objectives

Expand any lab below to view its full Scenario Context and Lab Objectives.

<a id="lab-01"></a>
<details>
  <summary><b>Lab 01: Systemd Service Mastery</b></summary>

  ### 📝 Scenario Context
An administrator created a custom web application script at `/usr/local/bin/web-app.sh` and set up a systemd service unit at `/etc/systemd/system/web-app.service` to manage it. Unfortunately, the app is failing to start, and running it as `root` violates security policies.

Your job is to diagnose the failure, secure the service by running it as a standard system user, and make it resilient by adding an auto-restart policy.

  ### 🎯 Lab Objectives
1. **Fix the Path**: Locate the executable script and correct the `ExecStart` path in `/etc/systemd/system/web-app.service`.
2. **Apply Principle of Least Privilege**: Configure the service to run as the standard `sysadm` user (already created for you) rather than `root`.
3. **Configure Auto-Restart**: Setup systemd to automatically restart the service if it encounters failures.
4. **Boot and Activate**: Reload the systemd daemon configuration, start the service, and verify it is running on port 80.

  *View full guide and resources: [01-systemd](u_lab/labs/01-systemd/)*
</details>

<a id="lab-02"></a>
<details>
  <summary><b>Lab 02: Network & Firewall Engineering</b></summary>

  ### 📝 Scenario Context
You have been tasked with securing and configuring the network parameters of a newly provisioned staging server. Currently, the firewall is completely open to all incoming connections, there are no local host mappings, and the network card profile relies on DHCP.

You need to harden the firewall policies, configure the Netplan static configuration file, and setup local domain name maps.

  ### 🎯 Lab Objectives
### 1. Configure Netplan Static IP Profile
Edit `/etc/netplan/50-cloud-init.yaml` to represent a static network configuration:
- IP Address: `192.168.1.100` (Subnet mask `/24`)
- Gateway (Routes via): `192.168.1.1`
- DNS Nameservers: `8.8.8.8` and `8.8.4.4`
- DHCP4: Disabled (`false` or `no`)
- *Note: Since Docker manages container interfaces, you do NOT need to run `netplan apply`. The verification script will parse and validate the YAML file itself.*

### 2. Hardening Ingress Rules with UFW
Harden the server firewall policies:
- Default Incoming: Set default incoming traffic policy to **DENY**.
- Default Outgoing: Set default outgoing traffic policy to **ALLOW**.
- SSH Access (Port 22): Allow SSH incoming connections **only** from the subnet `192.168.1.0/24`.
- HTTP Access (Port 80): Allow HTTP incoming traffic from **anywhere**.
- Database Port (Port 3306): Explicitly **deny** database connections from anywhere.
- Enable the firewall.

### 3. Setup Local Domain Maps
Configure local name resolution so services can communicate:
- Map local name `labyrinth-db.local` to resolve to `127.0.0.1` in `/etc/hosts`.
- Map local name `labyrinth-web.local` to resolve to `127.0.0.1` in `/etc/hosts`.

  *View full guide and resources: [02-network](u_lab/labs/02-network/)*
</details>

<a id="lab-03"></a>
<details>
  <summary><b>Lab 03: Permissions & Security Hardening</b></summary>

  ### 📝 Scenario Context
You have been hired as a security auditor for an Ubuntu server staging machine. The current directory configuration leaks administrative directories, standard users have unrestricted access, and the SSH daemon allows password login (subjecting it to brute-force attacks).

You need to lock down access privileges and harden the SSH server.

  ### 🎯 Lab Objectives
### 1. Configure ACLs on a Shared Directory
Configure access privileges for the directory `/var/shared/`:
- The directory is owned by `root:root` and has permission `700` (blocking standard groups/others).
- Grant the user `audit` read access (`r-x` or `r--`) to `/var/shared/` using Access Control Lists (ACLs).
- Ensure the user `audit` **cannot** write to the directory.

### 2. Restrict Sudo Executions
Allow the user `operator` to run administrative service controls, but limit them from executing arbitrary system commands:
- Create a sudoers rule file (e.g. `/etc/sudoers.d/operator`).
- Allow user `operator` to run `/usr/bin/systemctl` or `/usr/sbin/service` commands.
- Ensure the user `operator` is **blocked** from running broad commands (they must not have the unrestricted `(ALL) ALL` rule).

### 3. Harden SSH Daemon
Harden SSH ingress options:
- Disable password-based logins: Set `PasswordAuthentication no`.
- Enable key-based logins: Set `PubkeyAuthentication yes`.
- Ensure changes are loaded by restarting the SSH service.

  *View full guide and resources: [03-security](u_lab/labs/03-security/)*
</details>

<a id="lab-04"></a>
<details>
  <summary><b>Lab 04: Storage & LVM Partitioning</b></summary>

  ### 📝 Scenario Context
You are adding storage expansion to an active server. Because block device allocation inside Docker containers is kernel-locked for host OS safety, you will perform **simulative script validation** for the disk partitioning and Logical Volume setup, and **real configuration** for filesystem mounting (`/etc/fstab`) and swapfile expansion.

Your objectives will prepare you for partitioning, creating Logical Volumes, securing reboots on dynamic filesystems, and expanding system swap memory.

  ### 🎯 Lab Objectives
### 1. Write the LVM Setup Script
Write a bash script at `/root/lvm-setup.sh` that documents the correct step-by-step partition and volume creations for a new secondary disk `/dev/sdb`:
- **Physical Volume**: Create a physical volume on the disk `/dev/sdb`.
- **Volume Group**: Create a volume group named `vg_data` incorporating `/dev/sdb`.
- **Logical Volume**: Create a logical volume named `lv_storage` inside `vg_data`.
- **Format Filesystem**: Format the logical volume path `/dev/vg_data/lv_storage` as `ext4`.

### 2. Configure Persistent Mount in `/etc/fstab`
Configure `/etc/fstab` to persistently mount a mock secondary drive mapping UUID `fe382b90-1c39-4d82-89b2-38d73b22b100` to the directory `/mnt/data`:
- Filesystem: `ext4`
- Mount Options: Configure with `defaults` and the crucial `nofail` flag.
  *(The `nofail` flag is critical: it prevents the system from failing to boot or hanging if the mock block drive is absent during reboot)*

### 3. Configure Swap File Expansion
Create a swap file at the root `/swapfile`:
- Size: Exactly `256MB`. Use `dd` to copy bytes.
- Permissions: Lock down the file permissions to exactly `0600` (readable/writable only by root).
- Format: Format the file as swap space.
- Persistence: Add the correct swap mounting line to `/etc/fstab` to ensure it is configured automatically on boot.
  *(Do not run `swapon` inside the container, as it is blocked by Docker namespaces. The check will verify the file properties and the fstab configuration).*

  *View full guide and resources: [04-storage](u_lab/labs/04-storage/)*
</details>

<a id="lab-05"></a>
<details>
  <summary><b>Lab 05: Package Management & Compilation</b></summary>

  ### 📝 Scenario Context
In enterprise Ubuntu deployments, you will frequently need to compile custom software from source to optimize performance or meet custom business rules. Additionally, offline servers or staging environments require configuring local, file-based package repositories rather than fetching packages from public mirrors.

Your task is to compile a shared C library, register it in the system linker paths, build a custom application that dynamically links against it, and configure a local APT repository source.

  ### 🎯 Lab Objectives
### 1. Configure a Local APT Repository
Configure the APT package manager to recognize a local directory as a trusted software repository:
- Create `/etc/apt/sources.list.d/local.list`.
- Add the repository configuration line pointing to the directory `/var/local/repo` (pre-created for you).
- The repository must be configured as trusted (`[trusted=yes]`) to bypass GPG signing keys validations.
- Path format: `deb [trusted=yes] file:/var/local/repo ./`

### 2. Compile the Shared Library (`libmastery.so`)
Compile the library source files located in `/root/src/` to a shared object:
- Compile `/root/src/libmastery.c` using Position-Independent Code (`-fPIC`) and shared library outputs compiler flags.
- Name the output file `libmastery.so`.
- Place `libmastery.so` in `/usr/local/lib/`.

### 3. Register the Library Linker Path
Configure the dynamic loader mapping system so the OS can load the library at runtime:
- Create a configuration file at `/etc/ld.so.conf.d/mastery.conf`.
- Add the directory path `/usr/local/lib` inside this file.
- Run `ldconfig` to reload and update the system's dynamic linker cache.

### 4. Compile the Main Application (`my_app`)
Compile the main program `/root/src/main.c` and link it against the compiled shared library:
- Compile and output the binary `my_app`.
- Link against `libmastery` using `-lmastery` and define the library directory search path `-L/usr/local/lib`.
- Move the compiled executable `my_app` to `/usr/local/bin/`.

  *View full guide and resources: [05-compilation](u_lab/labs/05-compilation/)*
</details>

<a id="lab-06"></a>
<details>
  <summary><b>Lab 06: Web Server & Reverse Proxy Design</b></summary>

  ### 📝 Scenario Context
You are preparing the staging environment for public release. Currently, the server is running a backend Python application directly on port 8080. Exposing this port directly to the internet is slow and insecure.

You need to put Nginx in front of it as a secure reverse proxy, generate a self-signed SSL/TLS certificate to enable HTTPS (port 443), enforce automatic redirect from HTTP (port 80) to HTTPS (port 443), and set up log rotation for the application logs.

  ### 🎯 Lab Objectives
### 1. Generate SSL Certificates
Generate a self-signed SSL certificate and private key using OpenSSL:
- Key Path: `/etc/ssl/private/labyrinth.key`
- Certificate Path: `/etc/ssl/certs/labyrinth.crt`
- Validity: 365 days, RSA 2048-bit key.

### 2. Configure HTTPS Reverse Proxy Block in Nginx
Configure a server block at `/etc/nginx/sites-available/reverse-proxy.conf` and link it to `/etc/nginx/sites-enabled/` to activate it:
- The server block must listen on port `443 ssl`.
- Reference the certificate paths generated in Objective 1.
- Reverse-proxy incoming connections to the upstream backend server running locally at `http://127.0.0.1:8080`.

### 3. Enforce HTTP to HTTPS Redirect
Configure Nginx to listen on port `80`.
- All requests on port 80 must return a permanent HTTP redirect (301 or 302) to `https://$host$request_uri`.

### 4. Configure Log Rotation
Create a custom logrotate configuration block at `/etc/logrotate.d/web-app` for the log files located in `/var/log/web-app/`:
- Rotate interval: **daily**
- Rotation count: Keep **7** rotations (`rotate 7`)
- Operations: `compress`, `delaycompress`, `missingok`, `notifempty`
- Creation directive: `create 0660 www-data www-data`

  *View full guide and resources: [06-webserver](u_lab/labs/06-webserver/)*
</details>

<a id="lab-07"></a>
<details>
  <summary><b>Lab 07: System Automation & Timers</b></summary>

  ### 📝 Scenario Context
Modern Ubuntu systems are transitioning cron jobs to **Systemd Timers**. Timers offer native integration with Systemd, detailed status logs via `journalctl`, and sophisticated dependency trees.

Your task is to write a system backup script, create a systemd service unit to trigger it, and schedule it using a systemd timer.

  ### 🎯 Lab Objectives
### 1. Write the Backup Script
Create a shell script at `/usr/local/bin/backup-logs.sh`:
- It must create a compressed tarball (`.tar.gz`) archiving all logs in `/var/log/`.
- Save the archive inside `/var/backups/`.
- Output file format: `/var/backups/log-backup-<TIMESTAMP>.tar.gz` (where `<TIMESTAMP>` is the current date/time, e.g. `$(date +%Y%m%d-%H%M%S)`).
- Ensure the script is executable (`chmod +x`).

### 2. Create the Systemd Service Unit
Create `/etc/systemd/system/backup.service`:
- The service should be a `oneshot` type.
- It must point to `/usr/local/bin/backup-logs.sh` as the `ExecStart` command.

### 3. Create and Schedule the Timer
Create `/etc/systemd/system/backup.timer`:
- Trigger the service daily. Use the `OnCalendar` directive.
- Enable persistence: Set `Persistent=true` inside the `[Timer]` block so that if the server is offline during the trigger time, it executes immediately on boot.
- Configure it to start on boot: Add `WantedBy=timers.target` inside the `[Install]` block.
- Enable and start the timer service.

  *View full guide and resources: [07-timers](u_lab/labs/07-timers/)*
</details>

<a id="lab-08"></a>
<details>
  <summary><b>Lab 08: System Diagnostics & Performance</b></summary>

  ### 📝 Scenario Context
Your server is experiencing slow response times. System monitoring indicates a process is consuming server memory, and logs report filesystem errors due to "No space left on device" (which often indicates available disk space is fine, but **filesystem inodes** are completely exhausted by millions of small files).

Your task is to identify and terminate the leaking process, locate the directory clogging the inodes, and delete it.

  ### 🎯 Lab Objectives
### 1. Terminate Resource Leaks
Analyze running processes using tools like `ps`, `top`, or `pgrep`:
- Identify the process named `leaker` that is running in the background.
- Kill the process cleanly or force terminate it.

### 2. Resolve Inode Exhaustion
Locate files accumulating on the drive:
- Identify the directory under `/var/log/app/` that contains a massive accumulation of small log files.
- Delete the files or the folder itself to reclaim available filesystem inodes.

  *View full guide and resources: [08-diagnostics](u_lab/labs/08-diagnostics/)*
</details>

<a id="lab-09"></a>
<details>
  <summary><b>Lab 09: PAM Security & User Hardening</b></summary>

  ### 📝 Scenario Context
Ubuntu Server uses the **Pluggable Authentication Modules (PAM)** architecture to handle authentication, authorization, sessions, and password management. Security compliance standards (like PCI-DSS) mandate that servers lock out users after multiple failed logins and enforce password complexity.

Your task is to configure PAM to enforce brute-force lockouts and require complex passwords.

  ### 🎯 Lab Objectives
### 1. Enforce Bruteforce Login Lockouts
Configure the system to lock out accounts after **3 failed login attempts**:
- Edit `/etc/pam.d/common-auth`. Add the `pam_faillock.so` module constraints:
  - Add `auth required pam_faillock.so preauth silent deny=3 unlock_time=600` before `pam_unix.so`.
  - Add `auth [default=die] pam_faillock.so authfail deny=3 unlock_time=600` after `pam_unix.so`.
- Edit `/etc/pam.d/common-account` to clear lockouts on successful login:
  - Add `account required pam_faillock.so`.

### 2. Configure Password Complexity Rules
Enforce password constraints:
- Edit `/etc/pam.d/common-password`. Add the `pam_pwquality.so` module rules:
  - Add `password required pam_pwquality.so retry=3 minlen=12 dcredit=-1 ucredit=-1` before `pam_unix.so`.
  - *(This specifies a minimum length of 12 characters, and requires at least 1 digit and 1 uppercase letter).*

  *View full guide and resources: [09-pam](u_lab/labs/09-pam/)*
</details>

<a id="lab-10"></a>
<details>
  <summary><b>Lab 10: AppArmor Security Profiles</b></summary>

  ### 📝 Scenario Context
Ubuntu Server uses **AppArmor (Application Armor)** as its default Mandatory Access Control (MAC) system. AppArmor allows administrators to define security profiles for specific binaries (like Nginx, BIND, or SSH), confining their file reads, writes, network bindings, and execution privileges to prevent vulnerabilities exploitation.

Your task is to write an AppArmor security profile to confine Nginx.

  ### 🎯 Lab Objectives
### 1. Create the AppArmor Profile File
Write a profile configuration file at `/etc/apparmor.d/usr.sbin.nginx`:
- The profile must target the Nginx absolute path `/usr/sbin/nginx`.
- Include the standard AppArmor base abstraction imports: `#include <abstractions/base>`.
- Allow read access (`r`) to the web layouts directory: `/var/www/html/` and all its children. (e.g. `/var/www/html/** r`).
- Allow read access (`r`) to Nginx configuration files: `/etc/nginx/** r`.
- Allow read/write access to logs and processes:
  - `/var/log/nginx/** w`
  - `/run/nginx.pid rw`
- Allow standard library links read permissions: `/usr/lib/** r` (or similar).

### 2. Verify Profile Syntax
Validate that the profile contains correct AppArmor parameters syntax:
- Run a parsing check using `apparmor_parser`:
  ```bash
  apparmor_parser -n /etc/apparmor.d/usr.sbin.nginx
  ```
  *(This compiles the policy and checks for syntax errors without loading it into the kernel, allowing verification to succeed even if your host environment doesn't support AppArmor).*

  *View full guide and resources: [10-apparmor](u_lab/labs/10-apparmor/)*
</details>

<a id="lab-11"></a>
<details>
  <summary><b>Lab 11: System Log Auditing & Monitoring</b></summary>

  ### 📝 Scenario Context
Your server is constantly targeted by ssh brute force attacks. Analyzing security authentication logs (`/var/log/auth.log` or equivalent) lets you detect failed login spikes. In enterprise setups, you write log-monitoring scripts to parse logs, extract attacking IPs, and block them dynamically in the firewall.

Your task is to write a script that does this automatically against a simulated log at `/var/log/auth_brute.log`.

  ### 🎯 Lab Objectives
### 1. Write the Log Parser Script
Create a bash script at `/root/block-attackers.sh`:
- It must parse `/var/log/auth_brute.log` to find lines containing `Failed password`.
- Count the number of failed attempts per IP address.
- Extract unique IP addresses that have **more than 5 failed attempts** (i.e. strictly greater than 5).
- Output the unique list of these IP addresses (one per line) to `/tmp/block_ips.txt`.

### 2. Append IPTables Drop Rules
Extend `/root/block-attackers.sh` to read the extracted list and dynamically block the IPs:
- For each IP address written to `/tmp/block_ips.txt`, append an IPTables rules drop statement in the `INPUT` chain.
- Command syntax: `iptables -A INPUT -s <IP> -j DROP`
- Ensure the script is executable (`chmod +x`).

  *View full guide and resources: [11-logaudit](u_lab/labs/11-logaudit/)*
</details>

<a id="lab-12"></a>
<details>
  <summary><b>Lab 12: Container Engine Deployments</b></summary>

  ### 📝 Scenario Context
Containers have revolutionized application hosting. Under the hood, container engines (like Docker or Podman) manage local bridge interfaces, volume mount abstractions, and lifecycle actions. Advanced systems engineers write automation scripts to launch containers and declare infrastructure state using orchestrators like **Docker Compose**.

Your task is to write a container runner shell script and define a standard multi-container compose file.

  ### 🎯 Lab Objectives
### 1. Write the Container Launch Script
Write a bash script at `/root/launch-container.sh` to launch a container programmatically:
- The script must create a custom Docker network bridge named `mastery-net` (using `docker network create`).
- Start an Nginx container named `web-nested` attached to the custom network `mastery-net`.
- Map host port `8080` to the container port `80` (so traffic requests route correctly).
- Use the image `nginx:alpine`.
- Run in detached background mode (`-d`).
- Ensure the script is executable (`chmod +x`).

### 2. Define the Docker Compose Infrastructure
Write a declarative YAML file at `/root/docker-compose.yml` to set up Nginx:
- Define a service (e.g. `web` or `app`).
- Set its container image to `nginx:alpine`.
- Configure the port mapping list to map host port `8080` to container port `80` (`8080:80`).
- Configure a volume mount linking the host folder `/var/www/html` to `/usr/share/nginx/html` in the container (`/var/www/html:/usr/share/nginx/html`).
- Ensure you define custom networks mapping or baseline compose parameters.

  *View full guide and resources: [12-containers](u_lab/labs/12-containers/)*
</details>

