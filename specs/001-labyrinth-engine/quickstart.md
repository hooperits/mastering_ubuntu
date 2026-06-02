# Quickstart & Test Scenarios: Labyrinth Lab Engine

## Local Development Setup

To initialize Labyrinth on your host machine for development:

1. Clone the repository and navigate to the directory:
   ```bash
   cd /home/juanca/proys/mastering_ubuntu
   ```
2. Build the Labyrinth base image:
   ```bash
   docker build -t u-lab-base:latest -f Dockerfile.base .
   ```
3. Install Labyrinth in editable development mode:
   ```bash
   pip install -e .
   ```

---

## Command Usage Examples

Once installed, use the CLI commands as follows:

### 1. View Lab Progress
```bash
u-lab list
```
*Expected output*: A clean grid/table listing IDs, Names, Difficulty, and Status.

### 2. Launch a Lab
```bash
u-lab start 01-systemd
```
*Expected output*: Spins up container `u-lab-01-systemd`, configures systemd, sets up the starting state, and renders the lab instructions guide.

### 3. Attach to a Lab
```bash
u-lab attach 01-systemd
```
*Expected output*: Standard terminal prompt inside the target container. Try changing config files here.

### 4. Check Work
```bash
u-lab check 01-systemd
```
*Expected output*: Runs verifications. Prints diagnostic reports detailing failures or a success badge.

### 5. Cleanup
```bash
u-lab destroy 01-systemd
```
*Expected output*: Shuts down and removes container `u-lab-01-systemd`.

---

## Automated Test Execution

Run the Python unit and integration test suites:

```bash
pytest tests/
```
*Tests verify*:
- Docker service availability detection.
- Configuration loader parses YAML and markdown guides.
- YAML definitions map correctly to Docker run commands.
- State file successfully records progress updates.
