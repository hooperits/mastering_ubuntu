#!/bin/bash

# Verification script for Lab 08: System Diagnostics & Performance
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 08 (System Diagnostics & Performance) state..."
echo ""

# Assertion 1: Verify the resource-hogging process 'leaker' has been terminated
if pgrep -f "/usr/local/bin/leaker" >/dev/null; then
    echo "❌ [FAIL] Process: The 'leaker' process is still running in the background"
    FAILED=1
else
    echo "✅ [PASS] Process: The 'leaker' process has been terminated"
fi

# Assertion 2: Verify the inode-clutter files under /var/log/app/inodes have been removed
if [ -d "/var/log/app/inodes" ]; then
    file_count=$(find /var/log/app/inodes -type f 2>/dev/null | wc -l)
    if [ "$file_count" -eq 0 ]; then
        echo "✅ [PASS] Filesystem: File inodes under /var/log/app/inodes have been cleared"
    else
        echo "❌ [FAIL] Filesystem: /var/log/app/inodes still contains $file_count files exhausting inodes"
        FAILED=1
    fi
else
    echo "✅ [PASS] Filesystem: Target directory /var/log/app/inodes has been deleted"
fi

echo ""
if [ $FAILED -eq 0 ]; then
    echo "🏆 All audits passed successfully!"
    exit 0
else
    echo "⚠️ Some checks failed. Please review your configurations."
    exit 1
fi
