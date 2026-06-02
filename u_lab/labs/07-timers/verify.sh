#!/bin/bash

# Verification script for Lab 07: System Automation & Timers
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 07 (System Automation & Timers) state..."
echo ""

# Assertion 1: Verify backup script exists and is executable
SCRIPT="/usr/local/bin/backup-logs.sh"
if [ -x "$SCRIPT" ]; then
    echo "✅ [PASS] Script: /usr/local/bin/backup-logs.sh exists and is executable"
    
    # Run the script to check if it runs successfully and generates the archive
    rm -f /var/backups/log-backup-*.tar.gz
    if "$SCRIPT" &>/dev/null; then
        # Check if the backup tarball was created
        if ls /var/backups/log-backup-*.tar.gz &>/dev/null; then
            echo "✅ [PASS] Script: Execution successfully created a compressed backup archive under /var/backups/"
        else
            echo "❌ [FAIL] Script: Executed successfully but no tarball was generated at /var/backups/log-backup-*.tar.gz"
            FAILED=1
        fi
    else
        echo "❌ [FAIL] Script: Execution returned a non-zero exit code"
        FAILED=1
    fi
else
    echo "❌ [FAIL] Script: File /usr/local/bin/backup-logs.sh is missing or not executable"
    FAILED=1
fi

# Assertion 2: Verify systemd service file exists and points to ExecStart
SERVICE_FILE="/etc/systemd/system/backup.service"
if [ -f "$SERVICE_FILE" ]; then
    if grep -q "ExecStart=/usr/local/bin/backup-logs.sh" "$SERVICE_FILE"; then
        echo "✅ [PASS] Service: backup.service points ExecStart to the correct script path"
    else
        echo "❌ [FAIL] Service: ExecStart in backup.service is incorrect or missing"
        FAILED=1
    fi
else
    echo "❌ [FAIL] Service: Systemd service file /etc/systemd/system/backup.service does not exist"
    FAILED=1
fi

# Assertion 3: Verify systemd timer configuration
TIMER_FILE="/etc/systemd/system/backup.timer"
if [ -f "$TIMER_FILE" ]; then
    # Check for OnCalendar trigger
    if grep -qi "OnCalendar=" "$TIMER_FILE"; then
         echo "✅ [PASS] Timer: backup.timer defines a trigger schedule (OnCalendar)"
    else
         echo "❌ [FAIL] Timer: backup.timer is missing OnCalendar directive"
         FAILED=1
    fi
else
    echo "❌ [FAIL] Timer: Systemd timer file /etc/systemd/system/backup.timer does not exist"
    FAILED=1
fi

# Assertion 4: Verify systemd timer active and enabled status
if systemctl is-active --quiet backup.timer; then
    echo "✅ [PASS] Daemon: backup.timer is currently active/running"
else
    echo "❌ [FAIL] Daemon: backup.timer is not active (run 'systemctl start backup.timer')"
    FAILED=1
fi

if systemctl is-enabled --quiet backup.timer 2>/dev/null; then
    echo "✅ [PASS] Daemon: backup.timer is enabled to start on system boot"
else
    echo "❌ [FAIL] Daemon: backup.timer is not enabled (run 'systemctl enable backup.timer')"
    FAILED=1
fi

echo ""
if [ $FAILED -eq 0 ]; then
    echo "🏆 All audits passed successfully!"
    exit 0
else
    echo "⚠️ Some checks failed. Please review your configurations."
    exit 1
fi
