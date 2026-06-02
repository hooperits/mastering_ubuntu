# Tasks: README Enhancement & Visual Toolkit

**Input**: Design documents from `/specs/003-enhance-readme/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create `assets/` directory at repository root

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core framework registration and hook configuration

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T002 Create blank visuals verification script at `.specify/scripts/python/check-readme-visuals.py`

---

## Phase 3: User Story 1 - Detailed Prerequisites & Setup Guide (Priority: P1) 🎯 MVP

**Goal**: Implement comprehensive dependencies installation guide (Python & Docker) in README.md.

**Independent Test**: Verify that a user can run instructions on Ubuntu, macOS, and Windows to install dependencies and execute Labyrinth start commands successfully.

### Implementation for User Story 1

- [ ] T003 [US1] Add copy-pasteable Python 3.10+ installation commands for Ubuntu, macOS, and Windows to `README.md`
- [ ] T004 [US1] Add Docker Engine and Desktop installation instructions for Ubuntu, macOS, and Windows to `README.md`
- [ ] T005 [US1] Add post-installation non-root group setup and docker verification instructions to `README.md`

**Checkpoint**: User Story 1 is complete. Users can successfully configure local prerequisites.

---

## Phase 4: User Story 2 - Visual Enhancements & Branding Assets (Priority: P2)

**Goal**: Add visual assets (banner, logo), shields, and layout styling to README.md.

**Independent Test**: Open README.md and confirm visual graphics, shields, and curricula tables render correctly and look professional.

### Implementation for User Story 2

- [ ] T006 [P] [US2] Generate project banner at `assets/labyrinth_banner.png` using `generate_image` tool
- [ ] T007 [P] [US2] Generate project logo at `assets/labyrinth_logo.png` using `generate_image` tool
- [ ] T008 [US2] Add shields.io badges (python version, docker support, license) to the top of `README.md`
- [ ] T009 [US2] Embed the generated `assets/labyrinth_banner.png` and `assets/labyrinth_logo.png` into `README.md`
- [ ] T010 [US2] Style and align the CLI command references and Curriculum Plan table/emojis in `README.md`

**Checkpoint**: User Story 2 is complete. Labyrinth repository landing page is visually engaging and premium.

---

## Phase 5: User Story 3 - Spec Kit Visual Asset Validator (Priority: P3)

**Goal**: Implement local asset path and markdown validation script with Spec Kit skill command.

**Independent Test**: Running `/speckit-visuals` or direct python script execution verifies README.md formatting and asset existence.

### Implementation for User Story 3

- [ ] T011 [US3] Implement image path existence and heading checks in `.specify/scripts/python/check-readme-visuals.py`
- [ ] T012 [P] [US3] Create Spec Kit skill documentation at `.agent/skills/speckit-visuals/SKILL.md`
- [ ] T013 [US3] Register `/speckit-visuals` command mapping to the python script in `.specify/extensions.yml`

**Checkpoint**: User Story 3 is complete. Documentation quality checks are automated.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verify the changes and commit the feature branch

- [ ] T014 Run visual validator script `python3 .specify/scripts/python/check-readme-visuals.py` and verify all checks pass
- [ ] T015 Run the full pytest suite to verify no regressions in the Labyrinth CLI
- [ ] T016 Commit and push changes to GitHub branch `003-enhance-readme`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup (Phase 1) - blocks all user stories.
- **User Stories (Phases 3-5)**: All depend on Foundational phase completion.
  - Phase 3 (US1) is the MVP and should be completed first.
  - Phase 4 (US2) and Phase 5 (US3) can proceed in parallel once Phase 2 is complete.
- **Polish (Phase 6)**: Depends on all user stories being complete.

### Parallel Opportunities

- T006 and T007 (Image asset generation) can run in parallel.
- T012 (Skill documentation) can run in parallel with script coding.
