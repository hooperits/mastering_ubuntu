#!/bin/bash

# Verification script for Lab 01: Systemd Service Mastery
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 01 (Systemd Mastery) state..."
echo ""

# Assertion 1: Check if the unit file has the correct path /usr/local/bin/web-app.sh
if grep -q "ExecStart=/usr/local/bin/web-app.sh" /etc/systemd/system/web-app.service; then
    echo "✅ [PASS] ExecStart path is correctly set to /usr/local/bin/web-app.sh"
else
    echo "❌ [FAIL] ExecStart path is still incorrect (should point to /usr/local/bin/web-app.sh)"
    FAILED=1
fi

# Assertion 2: Check if User=sysadm is specified in the service file
if grep -qi "^User=sysadm" /etc/systemd/system/web-app.service; then
    echo "✅ [PASS] User is configured to run as 'sysadm'"
else
    echo "❌ [FAIL] Service is not configured to run as 'sysadm' user"
    FAILED=1
fi

# Assertion 3: Check if Auto-restart policy is set (Restart=on-failure or Restart=always)
if grep -qi "^Restart=" /etc/systemd/system/web-app.service; then
    echo "✅ [PASS] Restart policy is defined"
else
    echo "❌ [FAIL] Restart policy is not defined in the systemd service file"
    FAILED=1
fi

# Assertion 4: Check if systemd service is active and running
if systemctl is-active --quiet web-app; then
    echo "✅ [PASS] web-app systemd service is currently running"
else
    echo "❌ [FAIL] web-app service is not active (status is '$(systemctl is-active web-app)')"
    FAILED=1
fi

# Assertion 5: Check if the service is listening on port 80
if ss -lntp | grep -q ":80 "; then
    echo "✅ [PASS] Service is successfully listening on port 80"
else
    echo "❌ [FAIL] Port 80 is not active or listening"
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
