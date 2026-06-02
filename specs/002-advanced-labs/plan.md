# Implementation Plan: Labyrinth Advanced Lab Expansion (Labs 07-12)

**Branch**: `002-advanced-labs` | **Date**: 2026-06-02 | **Spec**: [spec.md](file:///home/juanca/proys/mastering_ubuntu/specs/002-advanced-labs/spec.md)
**Input**: Feature specification from `specs/002-advanced-labs/spec.md`

## Summary
Implement Phase 2 of the mastery curriculum by authoring the configurations, setup routines, markdown guides, and verification scripts for Labs 07 through 12. These labs introduce kernel security modules (AppArmor), advanced logging, scheduler mechanisms (Systemd Timers), security auth interfaces (PAM), systems troubleshooting diagnostics, and container engine configurations.

## Technical Context

**Language/Version**: Bash Shell, Python 3.10+  
**Primary Dependencies**: Docker (nested execution), AppArmor kernel modules, PAM files (`pam_tally2` or `pam_faillock` and `pam_pwquality`), `systemd-timers`  
**Storage**: N/A (runs inside isolated transient containers)  
**Testing**: Check commands verified inside Labyrinth verify tests  
**Target Platform**: Linux (Ubuntu 24.04 containers)  
**Project Type**: Course Lab Scenarios Content  
**Constraints**: Labs 10 (AppArmor) and 12 (Containers) require advanced host kernel flags and privileged namespaces permissions.

---

## Constitution Check

| Principle / Constraint | Alignment Check | Status |
| :--- | :--- | :--- |
| **I. Interactive Lab-Based Learning** | Labs are fully interactive and configured directly inside the server terminal. | ✅ Passed |
| **II. Automated Verification** | Verifiers inspect system files, running processes, log parse tables, and active sockets. | ✅ Passed |
| **III. Container Sandbox Isolation** | Containers isolate LVM/Docker/AppArmor modifications to prevent host crashes. | ✅ Passed |
| **IV. Standard CLI UX** | CLI outputs hint guides and results using established formats. | ✅ Passed |
| **V. Solution Walkthroughs** | Detailed 3-tiered hints are compiled for all new labs. | ✅ Passed |

---

## Project Structure

We will create the following lab folders under `u_lab/labs/`:

```text
u_lab/labs/
├── 07-timers/
│   ├── lab.yaml        # Timers metadata (Privileged=true)
│   ├── setup.sh        # Prepares script templates
│   ├── verify.sh       # Audits systemd timers status
│   ├── hints.yaml      # Progressive hints
│   └── guide.md        # Walkthrough instructions
├── 08-diagnostics/
│   ├── lab.yaml        # Diagnostics metadata
│   ├── setup.sh        # Runs simulated CPU/Memory hog processes
│   ├── verify.sh       # Audits terminated process IDs & filesystems
│   ├── hints.yaml      # Progressive hints
│   └── guide.md        # Walkthrough instructions
├── 09-pam/
│   ├── lab.yaml        # PAM metadata
│   ├── setup.sh        # Creates accounts and enables standard PAM
│   ├── verify.sh       # Audits pam rule file structures
│   ├── hints.yaml      # Progressive hints
│   └── guide.md        # Walkthrough instructions
├── 10-apparmor/
│   ├── lab.yaml        # AppArmor metadata
│   ├── setup.sh        # Loads default web layouts and enables apparmor utilities
│   ├── verify.sh       # Audits Nginx AppArmor profile status
│   ├── hints.yaml      # Progressive hints
│   └── guide.md        # Walkthrough instructions
├── 11-logaudit/
│   ├── lab.yaml        # Logaudit metadata
│   ├── setup.sh        # Generates brute force auth logs in /var/log
│   ├── verify.sh       # Audits block script output list and iptables drops
│   ├── hints.yaml      # Progressive hints
│   └── guide.md        # Walkthrough instructions
└── 12-containers/
│   ├── lab.yaml        # Containers metadata (Nested Docker privilege capabilities)
│   ├── setup.sh        # Installs and launches nested Docker daemon
│   ├── verify.sh       # Audits nested networks and containers configurations
│   ├── hints.yaml      # Progressive hints
│   └── guide.md        # Walkthrough instructions
```

## Lab Design Details & Verification Logic

### LAB-07: System Automation & Timers
- **Objective**: Create `/usr/local/bin/backup-logs.sh`, setup `/etc/systemd/system/backup.service` and `/etc/systemd/system/backup.timer` scheduled to trigger daily.
- **Verification**: Checks if `systemctl is-active backup.timer` returns active, checks `/etc/systemd/system/backup.timer` configuration parameters, and verifies backup execution results.

### LAB-08: System Diagnostics & Performance
- **Objective**: Identify a running binary `leaker` that consumes excessive memory, kill it, search `/var/log/app` for dynamic files consuming inodes, and clear them out.
- **Verification**: Checks that process name `leaker` is inactive and available disk inodes are >90%.

### LAB-09: PAM Security & User Hardening
- **Objective**: Harden PAM auth settings in `/etc/pam.d/common-auth` and `/etc/pam.d/common-password` to enforce password lengths and failed lockout rules.
- **Verification**: Asserts presence of `pam_faillock.so` (or `pam_tally2.so`) with `deny=3` and `pam_pwquality.so` with `minlen=12`.

### LAB-10: AppArmor Security Profiles
- **Objective**: Enforce an AppArmor profile restricting Nginx daemon directory lookups.
- **Verification**: Runs `aa-status --enabled` and verifies `/usr/sbin/nginx` is listed under profiles in `enforce` mode.

### LAB-11: System Log Auditing & Threat Analysis
- **Objective**: Parse a simulated auth log, output list of attacking IPs to `/tmp/block_ips.txt`, and append block rules.
- **Verification**: Asserts `/tmp/block_ips.txt` matches target attackers, and iptables blocks traffic from those sources.

### LAB-12: Container Engine Deployments
- **Objective**: Launch nested Docker, create bridge network `mastery-net`, and start container `web-nested`.
- **Verification**: Evaluates docker engine state inside container to confirm network name and running nested workloads.
