# Structural Model: README Visuals & Verification

This document specifies the required layout elements, asset parameters, and verification requirements.

## 1. README Layout Structure
The enhanced `README.md` must contain the following components in order:
1. **Visual Banner**: High-resolution branding image (`assets/labyrinth_banner.png`).
2. **Title & Badge Row**: Project name (`# 🚀 Labyrinth: Interactive Ubuntu Server Mastery Sandbox`) and shields.io status badges.
3. **Short Description**: Clean introduction and high-level architecture overview.
4. **Prerequisites & Installation Section**: Interactive tabs/menus for Ubuntu, macOS, and Windows installation commands.
5. **Quick Start**: Commands to start virtual env and run help.
6. **CLI Command Reference**: Styled table or lists detailing catalog, start, attach, check, and destroy commands.
7. **Curriculum Plan**: Styled lists showing Completed/Ready/Future status of Labs 01-12.

## 2. Visual Asset Specifications
* **labyrinth_banner.png**: Resolution 1200x400 (aspect ratio 3:1), high-tech neon style, compressed size <500KB.
* **labyrinth_logo.png**: Resolution 400x400 (aspect ratio 1:1), minimalist geometric vector style, compressed size <100KB.

## 3. Verification Rules
The `check-readme-visuals.py` script must validate:
* **Asset Existence**: Any markdown image link starting with `assets/` (e.g. `![logo](assets/labyrinth_logo.png)`) must have a corresponding file present under `assets/` directory.
* **Markdown Standard**: Heading structure must start with a single H1 (`#`) element.
