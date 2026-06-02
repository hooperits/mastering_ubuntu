# Feature Specification: Labyrinth Lab Engine

**Feature Branch**: `001-labyrinth-engine`  
**Created**: 2026-06-02  
**Status**: Ready for Review  
**Input**: Create the Labyrinth Interactive Lab Engine for Ubuntu Server Mastery

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Lab Lifecycle & Connection (Priority: P1)
As an aspiring systems administrator, I want to start a specific lab session and attach directly to its shell interface so that I can interactively configure the Ubuntu server container.

**Why this priority**: Without starting and connecting to the server sandbox, no hands-on configuration or active learning is possible. This is the core MVP loop.

**Independent Test**: Spin up a dummy lab container (e.g. `lab-test`), confirm it is running, attach to its bash prompt, run `uname -a` (should show Linux container info), and exit without leaving dangling containers.

**Acceptance Scenarios**:
1. **Given** that Docker is running and the Labyrinth catalog has a lab with ID `01-systemd`, **When** I run `u-lab start 01-systemd`, **Then** the system builds/starts the container and outputs a markdown guide with objectives and instructions.
2. **Given** that the container `u-lab-01-systemd` is running, **When** I run `u-lab attach 01-systemd`, **Then** I am dropped directly into the container's interactive `/bin/bash` terminal as the standard user (or root as configured).

---

### User Story 2 - Automated Verification (Priority: P1)
As a learner, I want to execute a check against my configurations inside the container and get immediate, itemized feedback so that I know exactly which requirements I got right or wrong.

**Why this priority**: Crucial for the "proving proficiency" objective. Without automated feedback, learners cannot be sure they configured systems correctly (e.g., verifying if a network Netplan config is functional, or if a firewall rule will persist across reboots).

**Independent Test**: Run a check on a clean, unmodified container (tests should fail), then modify the container state to satisfy the lab (e.g. create a file with permissions 600), run the check again, and verify the test passes.

**Acceptance Scenarios**:
1. **Given** that I have completed configurations in `u-lab-01-systemd`, **When** I run `u-lab check 01-systemd`, **Then** the CLI runs the lab's verification scripts and displays a pass/fail report for each specific requirement.
2. **Given** that all verification tests pass, **When** the check completes, **Then** the system marks the lab status as "Completed" in my progress file and displays a congratulations message.

---

### User Story 3 - Progress Tracking & Catalog Listing (Priority: P2)
As a student, I want to view a catalog of all available labs and my completion status so that I can decide which topic to study next.

**Why this priority**: Important for structured progression and gamification. Helps track zero-to-hero momentum.

**Independent Test**: Run the list command and verify that a table displays all labs, difficulties, and status, and updating status changes this display.

**Acceptance Scenarios**:
1. **Given** the system has 6 defined labs, **When** I run `u-lab list`, **Then** it prints a formatted ASCII terminal table displaying the Lab ID, Name, Difficulty (Easy/Medium/Hard), Focus Area, and Status (Not Started, In Progress, Completed).

---

### User Story 4 - Lab Reset & Cleanup (Priority: P2)
As a student, I want to destroy a lab container or reset it back to its starting state if I make a critical mistake (e.g., locking myself out, deleting network configurations).

**Why this priority**: Standard safety net for learning. Allows unlimited retries without lingering files or Docker configurations polluting the system.

**Independent Test**: Start a container, run command `u-lab destroy <lab-id>`, and check `docker ps -a` to verify the container is completely deleted.

**Acceptance Scenarios**:
1. **Given** a running lab container, **When** I run `u-lab destroy 01-systemd`, **Then** the container is stopped and removed, and any temporary networks are cleaned up.
2. **Given** a modified lab container, **When** I run `u-lab start 01-systemd` again, **Then** the system automatically destroys the old container and spins up a brand new, clean container from the starting state.

---

### Edge Cases

- **Docker Daemon Offline**: If Docker is not running on the host system, the CLI must exit gracefully with status code 1 and print a user-friendly instruction to start the Docker service.
- **Verification Script Crash/Timeout**: If a verification script hangs or crashes (e.g. checking a network interface that doesn't respond), the engine must enforce a 10-second timeout, stop the script, and report a verification failure.
- **Port Collisions**: If a lab container needs to bind to a host port (e.g., Nginx on port 80 or 8080) that is already in use by the host system, the CLI must identify this and advise the user to free the port or automatically map to an ephemeral port.
- **Unexpected Deletion**: If the user manually removes the container using standard `docker rm`, Labyrinth must handle this state gracefully (mark as Not Started/Broken) instead of crashing.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST implement a CLI command `u-lab` written in Python.
- **FR-002**: The system MUST use Docker to manage lab environments, pulling or building minimal Ubuntu LTS images (e.g. `ubuntu:24.04` or `ubuntu:22.04`).
- **FR-003**: Each lab MUST be declared via a `lab.yaml` file specifying:
  - Metadata (ID, title, description, difficulty, estimated_time)
  - Docker config (base image, environment variables, mapped volumes, ports)
  - Setup instructions (command line operations executed inside container at initialization)
  - Verification assertions (a path to a verification script to execute)
- **FR-004**: The system MUST check for the presence of the Docker daemon before executing any container-related command.
- **FR-005**: The `u-lab list` command MUST read the catalog and output a clean ASCII table.
- **FR-006**: The `u-lab start <lab_id>` command MUST launch the container, run the initial setup, and render the markdown instructions using terminal markdown styling or a neat text printer.
- **FR-007**: The `u-lab attach <lab_id>` command MUST execute an interactive bash shell in the target container.
- **FR-008**: The `u-lab check <lab_id>` command MUST run verification scripts inside the container and parse assertions.
- **FR-009**: The system MUST persist user progress (completed labs, start times, completion times) in a local JSON state file at `~/.config/u-lab/progress.json`.
- **FR-010**: The system MUST support `u-lab destroy <lab_id>` to fully clean up Docker containers and temporary files.

### Key Entities

- **Lab**: A module containing configuration (`lab.yaml`), setup scripts (`setup.sh`), a markdown guide (`guide.md`), and validation tests (`verify.sh`).
- **UserProgress**: Persistent state capturing which labs are completed, timestamps, and active lab tracking.
- **LabContainer**: The underlying Docker container instance managed by Docker SDK.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can run `u-lab start <lab-id>`, which builds/spins up the container and runs initialization scripts in under 4 seconds.
- **SC-002**: The `u-lab check` command completes execution and prints an assertion report in under 2 seconds.
- **SC-003**: The CLI returns standard bash exit codes (0 for success, non-zero for failures) across all operations.
- **SC-004**: Stopping or destroying a lab leaves zero orphan containers or networks on the host machine.

---

## Assumptions

- **Host OS**: The user's host machine is Linux and has Docker installed and running with permissions to run Docker commands without `sudo` (e.g. user is in the `docker` group).
- **Python Runtime**: Python 3.10+ is installed on the host system.
- **Base Images**: Internet connectivity is available to download base Ubuntu Docker images on initial start.
- **Data Persistence**: The local progress file `~/.config/u-lab/progress.json` is sufficient for storage. No external database or network sync is required.
