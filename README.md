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
| **01** | **Systemd Service Mastery** | Fix crashing services, least-privilege users, auto-restart policies | Ready! 🚀 | [Ubuntu Server Docs](https://ubuntu.com/server/docs) |
| **02** | **Network & Firewall Engineering** | Netplan static IPs, UFW rule verification, routing | Ready! 🚀 | [Network](https://ubuntu.com/server/docs/network-configuration) • [UFW](https://ubuntu.com/server/docs/security-firewall) |
| **03** | **Permissions & Security Hardening** | ACLs, sudoers limit, sshd passwordless auth config | Ready! 🚀 | [SSH](https://ubuntu.com/server/docs/openssh-server) • [Users](https://ubuntu.com/server/docs/user-management) |
| **04** | **Storage & LVM Partitioning** | Partitions, logical volumes, fstab persistence | Ready! 🚀 | [LVM Storage](https://ubuntu.com/server/docs/how-to/storage/manage-logical-volumes/) |
| **05** | **Package Management & Compilation** | Apt sources, PPAs, library compilation | Ready! 🚀 | [Apt Packages](https://ubuntu.com/server/docs/package-management) |
| **06** | **Web Server & Reverse Proxy Design** | Nginx setup, self-signed SSL, log rotation | Ready! 🚀 | [Nginx Web Server](https://ubuntu.com/server/docs/how-to/web-services/install-nginx/) |
| **07** | **System Automation & Timers** | Backup scripts, systemd services, daily timers | Ready! 🚀 | [Shell Backups](https://ubuntu.com/server/docs/backups-shell-scripts) |
| **08** | **System Diagnostics & Performance** | Diagnose memory leaks, kill runaway processes, inode limits | Ready! 🚀 | [Ubuntu Server Docs](https://ubuntu.com/server/docs) |
| **09** | **PAM Security & User Hardening** | PAM login restrictions, password complexity, lockouts | Ready! 🚀 | [User Management](https://ubuntu.com/server/docs/user-management) |
| **10** | **AppArmor Security Profiles** | AppArmor profiles, restrict system daemon directory access | Ready! 🚀 | [AppArmor MAC](https://ubuntu.com/server/docs/security-apparmor) |
| **11** | **System Log Auditing & Monitoring** | Parse auth logs, extract malicious IPs, firewall drop rules | Ready! 🚀 | [Security](https://ubuntu.com/server/docs/security) • [UFW](https://ubuntu.com/server/docs/security-firewall) |
| **12** | **Container Engine Deployments** | Nested container engines, Docker-in-Docker, bridge networks | Ready! 🚀 | [Docker Guide](https://ubuntu.com/server/docs/docker-for-system-admins) |


