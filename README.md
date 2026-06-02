# 🚀 Labyrinth: Interactive Ubuntu Server Mastery Sandbox

Labyrinth is an automated, hands-on learning CLI that spins up isolated Ubuntu Server containers locally, presents configuration scenarios, and runs real-time verifiers to check your work.

## 🛠️ Prerequisites
- **Docker**: Must be installed and running. Ensure you can run `docker ps` without sudo:
  ```bash
  sudo usermod -aG docker $USER
  ```
  *(Log out and back in to apply group changes)*
- **Python**: Python 3.10+ is required.

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

### List Available Labs
List the current labs catalog and your completion progress:
```bash
.venv/bin/u-lab list
```

### Start a Lab Session
This builds the base Docker image (if missing), spins up the container, injects configuration bugs, and displays the lab guide:
```bash
.venv/bin/u-lab start 01-systemd
```

### Enter the Lab Sandbox Shell
Attach your terminal interactively inside the Ubuntu container to start diagnosing and configuring:
```bash
.venv/bin/u-lab attach 01-systemd
```

### Audit Configuration and Verify Completion
Run the verification test suite inside the active container. If all tests pass, the lab is logged as completed:
```bash
.venv/bin/u-lab check 01-systemd
```

### Clean Up and Destroy Sandbox
Stop and delete the lab container instance:
```bash
.venv/bin/u-lab destroy 01-systemd
```

---

## 📚 Curriculum Plan

* **Lab 01: Systemd Service Mastery** - Fix crashing services, least-privilege users, auto-restart policies. *(Ready!)*
* **Lab 02: Network & Firewall Engineering** - Netplan static IPs, UFW rule verification, routing.
* **Lab 03: File Permissions & Security Hardening** - ACLs, sudoers limit, sshd passwordless auth config.
* **Lab 04: Storage & LVM Partitioning** - Partitions, logical volumes, persistence mounts via fstab.
* **Lab 05: Package Management & Compilation** - Apt sources, custom PPAs, compiling custom libraries.
* **Lab 06: Web Server & Reverse Proxy Design** - Nginx, self-signed SSL certificate installation, log rotating.
* **Lab 07: System Automation & Timers** - Create backup scripts, systemd service units, and recurring daily systemd timers.
* **Lab 08: System Diagnostics & Performance** - Diagnose memory leaks, kill runaway processes, and resolve file system inode exhaustion.
* **Lab 09: PAM Security & User Hardening** - Configure PAM login restrictions, password complexity, and lockout policies.
* **Lab 10: AppArmor Security Profiles** - Restrict system resource access for daemons by writing and enforcing AppArmor profiles.
* **Lab 11: System Log Auditing & Monitoring** - Build log parsing automation scripts to extract malicious IPs and enforce firewall block rules.
* **Lab 12: Container Engine Deployments** - Configure nested container engines, Docker-in-Docker sandboxes, and custom bridge networks.

