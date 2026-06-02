# Tasks: Labyrinth Lab Engine

**Input**: Design documents from `/specs/001-labyrinth-engine/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create project directories `u_lab/`, `u_lab/labs/`, and `tests/` at repository root
- [x] T002 Create `requirements.txt` with click, docker, pyyaml, and rich at repository root
- [x] T003 [P] Create `setup.py` for editable package installation at repository root

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core state persistence and loaders that blocking all user stories

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Create progress management module in `u_lab/state.py`
- [x] T005 [P] Setup basic logging config in `u_lab/__init__.py`
- [x] T006 Create yaml configurations loader in `u_lab/loader.py`
- [x] T007 [P] Implement Docker daemon detection in `u_lab/engine.py`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Lab Lifecycle & Connection (Priority: P1) 🎯 MVP

**Goal**: Start lab containers, initialize starting state, and attach interactive shell terminal.

**Independent Test**: Build and run a test container using `u-lab start`, verify it is active, and run `u-lab attach` to drop into the container terminal.

### Implementation for User Story 1

- [x] T008 [US1] Create the systemd-enabled base container specification in `Dockerfile.base`
- [x] T009 [US1] Implement Docker container launcher in `u_lab/engine.py` using Docker SDK
- [x] T010 [US1] Implement setup script copier & executor in `u_lab/engine.py`
- [x] T011 [US1] Implement host-to-container terminal exec attachment in `u_lab/engine.py`
- [x] T012 [US1] Define Click CLI commands for `start` and `attach` in `u_lab/cli.py`
- [x] T013 [US1] Create container execution unit tests in `tests/test_engine.py`

**Checkpoint**: At this point, User Story 1 is fully functional as a basic lab connector MVP.

---

## Phase 4: User Story 2 - Automated Verification (Priority: P1)

**Goal**: Execute verification assertions inside container and format results.

**Independent Test**: Running `u-lab check` executes assertion shell scripts, and prints itemized PASS/FAIL tests.

### Implementation for User Story 2

- [x] T014 [US2] Implement verification execution helper in `u_lab/engine.py`
- [x] T015 [US2] Create verification reporting format engine in `u_lab/engine.py` using `rich`
- [x] T016 [US2] Define Click CLI command `check` in `u_lab/cli.py`
- [x] T017 [US2] Create integration test suites for checking state in `tests/test_cli.py`

**Checkpoint**: User Stories 1 & 2 are complete. Labyrinth can start, connect, verify, and complete a lab session.

---

## Phase 5: User Story 3 - Progress Tracking & Catalog (Priority: P2)

**Goal**: Read catalog directory and display lab progression table.

**Independent Test**: Running `u-lab list` outputs a table showing lab difficulty and user completions.

### Implementation for User Story 3

- [x] T018 [US3] Implement catalog reading function in `u_lab/loader.py`
- [x] T019 [US3] Implement ASCII progress tables renderer in `u_lab/cli.py` using `rich.table`
- [x] T020 [US3] Define Click CLI command `list` in `u_lab/cli.py`

**Checkpoint**: User progress tracking and catalog lists are functional.

---

## Phase 6: User Story 4 - Lab Reset & Cleanup (Priority: P2)

**Goal**: Stop running lab containers and prune docker assets.

**Independent Test**: Running `u-lab destroy` removes container; running `start` restarts container cleanly.

### Implementation for User Story 4

- [x] T021 [US4] Implement container deletion and mount cleanup in `u_lab/engine.py`
- [x] T022 [US4] Define Click CLI command `destroy` in `u_lab/cli.py`

**Checkpoint**: Core lab CLI tool lifecycle functions (start, attach, check, list, destroy) are finished.

---

## Phase 7: Lab Scenarios Content Implementation (Priority: P2)

**Goal**: Define and bundle the six target learning labs.

**Independent Test**: Navigate through each lab catalog module and verify all verifiers pass on correct configuration.

- [x] T023 Implement Lab 01 (Systemd Mastery) in `u_lab/labs/01-systemd/`
- [x] T024 [P] Implement Lab 02 (Network Netplan/UFW) in `u_lab/labs/02-network/`
- [x] T025 [P] Implement Lab 03 (Permissions/SSH Hardening) in `u_lab/labs/03-security/`
- [ ] T026 [P] Implement Lab 04 (Storage LVM Partitioning) in `u_lab/labs/04-storage/`
- [ ] T027 [P] Implement Lab 05 (Apt/Source Compilation) in `u_lab/labs/05-compilation/`
- [ ] T028 [P] Implement Lab 06 (Nginx SSL Reverse Proxy) in `u_lab/labs/06-webserver/`

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Documentation updates, safety checks, and full verification

- [x] T029 Create user instruction manual in `README.md` at root
- [ ] T030 Add boundary conditions (e.g. docker engine offline check) to `u_lab/cli.py`
- [x] T031 Execute quickstart verification scripts to validate installation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: Blocks Phase 2.
- **Phase 2 (Foundational)**: Blocks all User Stories.
- **Phase 3 (User Story 1 - MVP)**: Blocks CLI integration testing in Phase 4.
- **Phase 4 to 6 (User Stories 2 to 4)**: Can be developed in parallel or sequential order.
- **Phase 7 (Lab Scenarios)**: Depends on core CLI functionality (Phase 3 & 4) to be testable.
- **Phase 8 (Polish)**: Final validation phase.

### Parallel Opportunities

- Phase 1 setup scripts (T002, T003)
- Phase 2 foundries (T005, T007)
- Phase 7 Lab Scenarios (T024 to T028) can be authored in parallel once the YAML specs are set.
