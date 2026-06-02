# Feature Specification: Labyrinth Advanced Lab Expansion (Labs 07-12)

**Feature Branch**: `002-advanced-labs`  
**Created**: 2026-06-02  
**Status**: Draft  
**Input**: Implement Labyrinth Advanced Labs 07 to 12

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - System Automation & Timers (Lab 07)
As an advanced student, I want a lab that teaches me how to write shell backups and run them on a recurring schedule using Systemd Timers instead of Cron.

**Why this priority**: Systemd Timers are the modern standard for Linux scheduling, offering better logging and service dependencies.

**Acceptance Scenarios**:
1. **Given** a container initialized for Lab 07, **When** I write the backup script at `/usr/local/bin/backup-logs.sh` and set up the corresponding systemd `.service` and `.timer` units to execute daily, **Then** the verifier script checks that the timer is active and executes successfully.

---

### User Story 2 - Performance Diagnostics & Memory Management (Lab 08)
As an administrator, I want a scenario where a process is misbehaving (memory leak & high disk inode usage) so that I can practice active system diagnostics and memory troubleshooting.

**Why this priority**: Crucial real-world troubleshooting skills. Junior sysadmins often panic when a server runs out of memory or inodes.

**Acceptance Scenarios**:
1. **Given** a container running a simulated leaking app, **When** I identify the memory-hogging process, terminate it, find the directory consuming all file system inodes, and clean it up, **Then** the verifier checks that memory consumption has dropped and available inodes have returned to safe levels.

---

### User Story 3 - PAM Security Rules & User Hardening (Lab 09)
As a security compliance officer, I want a lab to configure user restrictions, password security complexity, and lockout limits using PAM (Pluggable Authentication Modules) so I can secure user logins.

**Why this priority**: Compliance standard. Enforcing strong password rules is a requirement for enterprise server hardening.

**Acceptance Scenarios**:
1. **Given** a server in Lab 09, **When** I edit PAM configurations to lock user accounts after 3 failed login attempts and require passwords to be at least 12 characters with digit constraints, **Then** the verifier validates the active PAM configuration files.

---

### User Story 4 - AppArmor Sandboxing & Access Controls (Lab 10)
As a systems security engineer, I want a lab that forces me to write custom AppArmor profiles to confine an active daemon (like Nginx) and block it from accessing system files.

**Why this priority**: Mandatory for defense-in-depth configurations on public-facing internet servers.

**Acceptance Scenarios**:
1. **Given** an Nginx server, **When** I create and enforce an AppArmor profile restricting Nginx strictly to `/var/www/` and blocking read access to `/etc/` or binary execution, **Then** the verifier checks that AppArmor is in enforce mode and successfully blocks unauthorized file access.

---

### User Story 5 - Log Auditing & Threat Analysis Scripting (Lab 11)
As a security analyst, I want to write a log parser script to audit system security logs, identify malicious IPs, and block them dynamically.

**Why this priority**: Crucial automation skill. Combines bash scripting (awk/grep) with firewall operations.

**Acceptance Scenarios**:
1. **Given** a simulated brute-force log at `/var/log/auth_brute.log`, **When** I write a script at `/root/block-attackers.sh` that parses the file, extracts IPs with more than 5 failed logins, and dynamically appends IPTables drop rules, **Then** the verifier checks the script output and rules list.

---

### User Story 6 - Nested Container Engines (Lab 12)
As a DevOps engineer, I want to configure a container engine inside the staging server (Docker-in-Docker) to run secondary workloads and manage custom bridge networks.

**Why this priority**: Containers are the modern deployment unit. Understanding Docker network bridges and container lifecycles is mandatory.

**Acceptance Scenarios**:
1. **Given** Lab 12 setup, **When** I install a nested Docker container engine, configure a custom network bridge `mastery-net`, and run an app container attached to it, **Then** the verifier queries the nested Docker daemon to confirm the network and container are active.

---

## Requirements *(mandatory)*

### Functional Requirements
- **FR-001**: The system MUST define and register six advanced labs in the Labyrinth catalog folder:
  - `07-timers`
  - `08-diagnostics`
  - `09-pam`
  - `10-apparmor`
  - `11-logaudit`
  - `12-containers`
- **FR-002**: Lab 07 MUST verify systemd timer active state, file persistence, and target script executions.
- **FR-003**: Lab 08 MUST run simulated leakage binaries in the container setup and verify processes termination.
- **FR-004**: Lab 09 MUST verify PAM configuration rules for password quality and lockouts.
- **FR-010**: Lab 10 MUST verify AppArmor profiles loading in enforce state for Nginx.
- **FR-011**: Lab 11 MUST verify script output matching brute force IP extraction lists.
- **FR-012**: Lab 12 MUST verify nested Docker container networking states.

---

## Success Criteria *(mandatory)*
- **SC-001**: Users can load, start, check, and clean all 6 advanced labs using the `u-lab` CLI.
- **SC-002**: Automated check verifications complete in under 3 seconds.
