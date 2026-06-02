# Quickstart: README Visual Check

This guide shows how to run the automated README validation script.

## 1. Running the Verification Script
Run the validation script directly using Python:

```bash
python3 .specify/scripts/python/check-readme-visuals.py
```

It checks:
- The existence of all local image assets referenced in the README.
- Heading validation (ensuring a single H1 header).

## 2. Running via Spec Kit Command
Once registered in `.specify/extensions.yml`, you can execute the command via:

```bash
/speckit-visuals
```
