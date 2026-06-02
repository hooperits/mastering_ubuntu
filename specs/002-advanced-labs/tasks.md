# Tasks: Labyrinth Advanced Lab Expansion (Labs 07-12)

**Input**: Design documents from `/specs/002-advanced-labs/`
**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Organization**: Tasks are grouped by lab scenario to enable independent implementation and testing of each lab.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story/lab this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup & Foundational (Prerequisites)

- [ ] T001 Verify catalog loader scans and reads new directories under `u_lab/labs/`

---

## Phase 2: User Story 1 - Lab 07 (System Automation & Timers)

**Goal**: Implement the schedule backup script and Systemd timer validation.

- [ ] T002 [US1] Create Lab 07 configuration metadata at `u_lab/labs/07-timers/lab.yaml`
- [ ] T003 [US1] Write setup script setting target log states at `u_lab/labs/07-timers/setup.sh`
- [ ] T004 [US1] Write systemd timer check verifications at `u_lab/labs/07-timers/verify.sh`
- [ ] T005 [P] [US1] Write progressive hints files at `u_lab/labs/07-timers/hints.yaml`
- [ ] T006 [US1] Write systemd timers markdown guides at `u_lab/labs/07-timers/guide.md`

---

## Phase 3: User Story 2 - Lab 08 (System Diagnostics & Performance)

**Goal**: Implement simulated process memory leaks and disk inode exhaustion exercises.

- [ ] T007 [US2] Create Lab 08 configuration metadata at `u_lab/labs/08-diagnostics/lab.yaml`
- [ ] T008 [US2] Write setups creating CPU/Memory hogging dummy scripts at `u_lab/labs/08-diagnostics/setup.sh`
- [ ] T009 [US2] Write verification audits confirming processes termination at `u_lab/labs/08-diagnostics/verify.sh`
- [ ] T010 [P] [US2] Write progressive hints files at `u_lab/labs/08-diagnostics/hints.yaml`
- [ ] T011 [US2] Write performance debugging guides at `u_lab/labs/08-diagnostics/guide.md`

---

## Phase 4: User Story 3 - Lab 09 (PAM Security & User Hardening)

**Goal**: Implement custom PAM login rules audits.

- [ ] T012 [US3] Create Lab 09 configuration metadata at `u_lab/labs/09-pam/lab.yaml`
- [ ] T013 [US3] Write setups creating accounts at `u_lab/labs/09-pam/setup.sh`
- [ ] T014 [US3] Write verifier checking PAM lock rules at `u_lab/labs/09-pam/verify.sh`
- [ ] T015 [P] [US3] Write progressive hints files at `u_lab/labs/09-pam/hints.yaml`
- [ ] T016 [US3] Write PAM configuration guides at `u_lab/labs/09-pam/guide.md`

---

## Phase 5: User Story 4 - Lab 10 (AppArmor Security Profiles)

**Goal**: Implement AppArmor Nginx profile locking exercises.

- [ ] T017 [US4] Create Lab 10 configuration metadata at `u_lab/labs/10-apparmor/lab.yaml`
- [ ] T018 [US4] Write setups enabling AppArmor tools at `u_lab/labs/10-apparmor/setup.sh`
- [ ] T019 [US4] Write verifier asserting AppArmor loading states at `u_lab/labs/10-apparmor/verify.sh`
- [ ] T020 [P] [US4] Write progressive hints files at `u_lab/labs/10-apparmor/hints.yaml`
- [ ] T021 [US4] Write AppArmor profile creation guides at `u_lab/labs/10-apparmor/guide.md`

---

## Phase 6: User Story 5 - Lab 11 (Log Auditing & Threat Analysis Scripting)

**Goal**: Implement awk/grep log threat parsing exercises.

- [ ] T022 [US5] Create Lab 11 configuration metadata at `u_lab/labs/11-logaudit/lab.yaml`
- [ ] T023 [US5] Write setups creating brute force logs at `u_lab/labs/11-logaudit/setup.sh`
- [ ] T024 [US5] Write verifier checking block scripts outputs at `u_lab/labs/11-logaudit/verify.sh`
- [ ] T025 [P] [US5] Write progressive hints files at `u_lab/labs/11-logaudit/hints.yaml`
- [ ] T026 [US5] Write awk/log threat analysis guides at `u_lab/labs/11-logaudit/guide.md`

---

## Phase 7: User Story 6 - Lab 12 (Container Engine Deployments)

**Goal**: Implement nested Docker bridge configurations exercises.

- [ ] T027 [US6] Create Lab 12 configuration metadata at `u_lab/labs/12-containers/lab.yaml`
- [ ] T028 [US6] Write setups initializing nested Docker engines at `u_lab/labs/12-containers/setup.sh`
- [ ] T029 [US6] Write verifier checking nested docker bridge routes at `u_lab/labs/12-containers/verify.sh`
- [ ] T030 [P] [US6] Write progressive hints files at `u_lab/labs/12-containers/hints.yaml`
- [ ] T031 [US6] Write nested container guides at `u_lab/labs/12-containers/guide.md`

---

## Phase 8: Final Validation & Polish

- [ ] T032 Verify all 12 labs are listed in the u-lab catalog table
- [ ] T033 Check in final branch and run full pytest suites
