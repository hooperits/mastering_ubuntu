# 🚀 Lab 07: System Automation & Timers

## Scenario Context
Modern Ubuntu systems are transitioning cron jobs to **Systemd Timers**. Timers offer native integration with Systemd, detailed status logs via `journalctl`, and sophisticated dependency trees.

Your task is to write a system backup script, create a systemd service unit to trigger it, and schedule it using a systemd timer.

---

## 🎯 Lab Objectives

### 1. Write the Backup Script
Create a shell script at `/usr/local/bin/backup-logs.sh`:
- It must create a compressed tarball (`.tar.gz`) archiving all logs in `/var/log/`.
- Save the archive inside `/var/backups/`.
- Output file format: `/var/backups/log-backup-<TIMESTAMP>.tar.gz` (where `<TIMESTAMP>` is the current date/time, e.g. `$(date +%Y%m%d-%H%M%S)`).
- Ensure the script is executable (`chmod +x`).

### 2. Create the Systemd Service Unit
Create `/etc/systemd/system/backup.service`:
- The service should be a `oneshot` type.
- It must point to `/usr/local/bin/backup-logs.sh` as the `ExecStart` command.

### 3. Create and Schedule the Timer
Create `/etc/systemd/system/backup.timer`:
- Trigger the service daily. Use the `OnCalendar` directive.
- Enable persistence: Set `Persistent=true` inside the `[Timer]` block so that if the server is offline during the trigger time, it executes immediately on boot.
- Configure it to start on boot: Add `WantedBy=timers.target` inside the `[Install]` block.
- Enable and start the timer service.

---

## 🔍 Systemd Timer Configuration Reference

### Script Template Example (`/usr/local/bin/backup-logs.sh`):
```bash
#!/bin/bash
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
tar -czf /var/backups/log-backup-$TIMESTAMP.tar.gz -C / var/log
```

### Service Configuration Block (`/etc/systemd/system/backup.service`):
```text
[Unit]
Description=Log Backup Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup-logs.sh
```

### Timer Configuration Block (`/etc/systemd/system/backup.timer`):
```text
[Unit]
Description=Run Log Backup Daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

### Enabling and Starting Timers:
* **Reload configuration changes**:
  ```bash
  systemctl daemon-reload
  ```
* **Enable and start timer**:
  ```bash
  systemctl enable backup.timer
  systemctl start backup.timer
  ```
* **List active system timers**:
  ```bash
  systemctl list-timers
  ```

---

## 💡 How to Complete
1. Use `u-lab attach 07-timers` to enter the container.
2. Create the backup script at `/usr/local/bin/backup-logs.sh` and make it executable.
3. Write the `/etc/systemd/system/backup.service` and `/etc/systemd/system/backup.timer` configurations.
4. Run `systemctl daemon-reload`, enable and start `backup.timer`.
5. Exit the container and run `u-lab check 07-timers` to verify.
