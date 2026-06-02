#!/bin/bash
set -e

# 1. Disable and remove pre-existing systemd units
systemctl disable backup.timer &>/dev/null || true
rm -f /etc/systemd/system/backup.service
rm -f /etc/systemd/system/backup.timer

# 2. Remove script file
rm -f /usr/local/bin/backup-logs.sh

# 3. Clean target backup directory
mkdir -p /var/backups
rm -f /var/backups/log-backup-*.tar.gz

# 4. Reload daemon state
systemctl daemon-reload
