# Research: README Enhancement & Visual Toolkit

## Decision 1: OS-Specific Installation Commands
* **Decision**: Detail installation instructions using the most standard native package managers.
  * **Ubuntu**: Use `apt` to install Python 3 and Docker Engine. Include post-installation commands for group management.
  * **macOS**: Use Homebrew (`brew`) for both Python and Docker Desktop.
  * **Windows**: Use Windows Package Manager (`winget`) or Docker Desktop direct installer.
* **Rationale**: Providing clear package manager commands minimizes human setup errors and gets the user up and running in under 5 minutes.
* **Alternatives Considered**: Direct source compilation (rejected as too complex for users) and downloading precompiled binaries manually (rejected as error-prone).

## Decision 2: Automated Verification Strategy
* **Decision**: Implement a lightweight Python script (`check-readme-visuals.py`) to parse `README.md` and check:
  1. Markdown links: Ensure local image assets in `assets/` exist on disk.
  2. Formatting: Verify that the document starts with `#` title heading.
* **Rationale**: Python is already a prerequisite for Labyrinth, ensuring the check runs out-of-the-box.
* **Alternatives Considered**: Shell scripts with grep (rejected as fragile) and node/npm-based markdown linter (rejected to avoid introducing Node.js dependency).

## Decision 3: Spec Kit Command & Skill Definition
* **Decision**: Register the new skill `speckit-visuals` in `.specify/extensions.yml` and author `.agent/skills/speckit-visuals/SKILL.md` to document its usage.
* **Rationale**: Aligns with the Spec Kit framework standard, allowing agents or users to run `/speckit-visuals` to check documentation assets.
