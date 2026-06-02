<!--
Sync Impact Report:
- Version change: [TEMPLATE] -> v1.0.0 (Initial Adoption)
- List of modified principles:
  - [PRINCIPLE_1] -> I. Interactive Lab-Based Learning
  - [PRINCIPLE_2] -> II. Automated Verification
  - [PRINCIPLE_3] -> III. Container Sandbox Isolation
  - [PRINCIPLE_4] -> IV. Standard CLI UX
  - [PRINCIPLE_5] -> V. Solution Walkthroughs
- Added sections:
  - Lab Design Constraints
  - Grading & Verification Protocol
- Removed sections: None
- Templates requiring updates:
  - .specify/templates/plan-template.md (✅ updated alignment)
  - .specify/templates/spec-template.md (✅ updated alignment)
  - .specify/templates/tasks-template.md (✅ updated alignment)
- Follow-up TODOs: None
-->

# Ubuntu Server Mastery Constitution

## Core Principles

### I. Interactive Lab-Based Learning
Ubuntu server proficiency must be acquired by practical application in a live terminal. No course materials, documents, or multiple-choice questions can substitute for configuring systems directly. Every concept introduced must map to a practical lab exercise.

### II. Automated Verification
Every lab must be accompanied by an automated, programmatic testing script. A lab is only considered complete and master level when all verification tests successfully pass. The tests must run independently and inspect the system state to prove the configurations are correct.

### III. Container Sandbox Isolation
To prevent corrupting the host machine and ensure clean restarts, all learning environments must run in isolated Ubuntu LTS Docker containers. The lab manager CLI must manage the lifecycle of these containers seamlessly.

### IV. Standard CLI User Experience
The lab manager CLI tool (`u-lab`) must provide a clean and intuitive user interface with standard exit codes, progress indicators, clear output streams (errors to stderr, normal output to stdout), and support for clean tabulations.

### V. Solution Walkthroughs
Each lab must have an associated markdown solution guide. This guide must provide the command-line commands and explain the underlying systems concept (e.g., how the systemd unit parser handles permissions, or why netplan overrides resolved config).

## Lab Design Constraints
1. **Base OS**: All labs must use a standard Ubuntu LTS base image (e.g., `ubuntu:24.04`).
2. **Resource Constraints**: Lab containers must not consume excessive CPU/RAM and should clean up their temporary docker networks.
3. **Reproducibility**: Starting a lab must configure the container to its initial broken/unconfigured state in under 5 seconds.

## Grading & Verification Protocol
1. **State Audits over History Audits**: Verification scripts must audit the active state of the server (e.g., checking `/etc/ssh/sshd_config`, checking running processes, scanning listening sockets) instead of auditing the user's shell history (`.bash_history`).
2. **Explanatory Error Outputs**: When an assertion fails, the verifier must return a clear explanation of *why* it failed and hints on how to resolve it.

## Governance
1. Any changes or expansions to the curriculum must update this constitution with a minor version bump.
2. Compliance with this constitution will be audited using the `/speckit.analyze` command during development.

**Version**: 1.0.0 | **Ratified**: 2026-06-02 | **Last Amended**: 2026-06-02
