# Data Model: Labyrinth Lab Engine

## 1. Lab Definition Schema (`lab.yaml`)

Each lab is declared in a `lab.yaml` file located in its corresponding folder. The CLI parses this file to configure the container and check results.

```yaml
id: "01-systemd"
title: "Systemd Service Mastery"
difficulty: "Medium"
estimated_time: "20m"
description: "Diagnose a crashed service, configure custom user permissions, and setup systemd auto-restart rules."
container:
  image: "u-lab-base:latest"
  hostname: "ubuntu-server"
  privileged: true
  ports:
    - "8080:80"
  volumes:
    - "/sys/fs/cgroup:/sys/fs/cgroup:ro"
  cap_add:
    - "SYS_ADMIN"
```

### Schema Properties:
- `id` (string, required): Unique identifier (e.g. `01-systemd`).
- `title` (string, required): Display title for the lab.
- `difficulty` (string, required): Difficulty level (Easy, Medium, Hard).
- `estimated_time` (string, required): Estimated duration (e.g. `15m`).
- `description` (string, required): Summary of the learning objective.
- `container` (object, required): Docker container instantiation details.
  - `image` (string, required): Container base image.
  - `hostname` (string): Hostname inside container.
  - `privileged` (boolean): Whether container requires privileged access (required for systemd services inside Docker).
  - `ports` (list of strings): Host:container port mappings (e.g. `8080:80`).
  - `volumes` (list of strings): Bind mounts (e.g. `/sys/fs/cgroup`).
  - `cap_add` (list of strings): Added Linux capabilities.

---

## 2. User Progress Schema (`progress.json`)

User progress is persisted in the user's home directory at `~/.config/u-lab/progress.json`.

```json
{
  "labs": {
    "01-systemd": {
      "status": "Completed",
      "started_at": "2026-06-02T15:30:00Z",
      "completed_at": "2026-06-02T15:48:12Z",
      "attempts": 2
    },
    "02-network": {
      "status": "In Progress",
      "started_at": "2026-06-02T15:55:00Z",
      "completed_at": null,
      "attempts": 1
    }
  }
}
```

### Fields:
- `labs` (object): Map of lab ID to progress records.
  - `status` (string): Current state: `Not Started`, `In Progress`, or `Completed`.
  - `started_at` (string, ISO-8601): Timestamp of initial run of `u-lab start`.
  - `completed_at` (string, ISO-8601 or null): Timestamp when all verification assertions passed.
  - `attempts` (integer): Number of times the verification check was triggered.
