# Implementation Plan: README Enhancement & Visual Toolkit

**Branch**: `003-enhance-readme` | **Date**: 2026-06-02 | **Spec**: [spec.md](file:///home/juanca/proys/mastering_ubuntu/specs/003-enhance-readme/spec.md)
**Input**: Feature specification from `specs/003-enhance-readme/spec.md`

## Summary

This feature improves the repository entry point by visually enhancing `README.md` with high-impact tech assets (glowing banner, logo, GitHub badges, and stylized CLI tables) and providing clear installation instructions for Labyrinth's prerequisites (Python 3.10+ and Docker Engine/Desktop) across Ubuntu, macOS, and Windows. We also implement a custom Spec Kit skill (`speckit-visuals`) and a Python validation script (`check-readme-visuals.py`) to automatically verify README formatting and local image path validity.

## Technical Context

- **Language/Version**: Python 3.10+, Bash shell, Markdown
- **Primary Dependencies**: Docker (setup instructions), `click` (CLI integration), standard library `urllib` (link auditing)
- **Storage**: N/A (static assets and configurations)
- **Testing**: pytest (integrates check script validation)
- **Target Platform**: Linux, macOS, Windows
- **Project Type**: Documentation and Spec Kit tooling extension

---

## Constitution Check

| Principle / Constraint | Alignment Check | Status |
| :--- | :--- | :--- |
| **I. Interactive Lab-Based Learning** | Facilitated by documenting dependency installation clearly so users can start sandbox labs instantly. | ✅ Passed |
| **II. Automated Verification** | Enforced by the new `check-readme-visuals.py` script checking README file integrity. | ✅ Passed |
| **III. Container Sandbox Isolation** | Docker-related post-installation post-steps are detailed to ensure sandbox accessibility. | ✅ Passed |
| **IV. Standard CLI UX** | The new Spec Kit check output complies with stdout/stderr standards. | ✅ Passed |
| **V. Solution Walkthroughs** | Detailed instructions and assets verify the Labyrinth curriculum. | ✅ Passed |

---

## Project Structure

We will create/update the following files:

```text
.agent/skills/
└── speckit-visuals/
    └── SKILL.md                 # [NEW] Spec Kit visual check skill definition

.specify/
├── feature.json                 # [MODIFY] Points to specs/003-enhance-readme
├── extensions.yml               # [MODIFY] Adds speckit-visuals command registration
└── scripts/
    └── python/
        └── check-readme-visuals.py # [NEW] Python validation script for README assets

assets/
├── labyrinth_banner.png          # [NEW] Generated visual banner for Labyrinth
└── labyrinth_logo.png            # [NEW] Generated project logo

README.md                         # [MODIFY] High-impact visual formatting + setup guide

specs/003-enhance-readme/
├── spec.md                       # Feature specification
├── plan.md                       # This plan
├── research.md                   # [NEW] Decision record for setup guides and skill design
├── data-model.md                 # [NEW] Structural layout design mapping
└── quickstart.md                 # [NEW] CLI command reference for visuals check
```

**Structure Decision**: Standard single project with added `.agent/skills` and `.specify/scripts/` hooks following existing conventions.
