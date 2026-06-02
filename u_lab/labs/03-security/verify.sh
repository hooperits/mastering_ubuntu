#!/bin/bash

# Verification script for Lab 03: Permissions & Security Hardening
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 03 (Permissions & Security Hardening) state..."
echo ""

# Assertion 1: Verify ACL read permissions on /var/shared for user 'audit'
if getfacl /var/shared 2>/dev/null | grep -q "user:audit:r"; then
    # Try reading the directory as 'audit' user
    if su - audit -c "ls /var/shared" &>/dev/null; then
        echo "✅ [PASS] ACL: User 'audit' has read access to /var/shared"
    else
        echo "❌ [FAIL] ACL: User 'audit' cannot list /var/shared despite ACL rules"
        FAILED=1
    fi
else
    echo "❌ [FAIL] ACL: Read permissions for user 'audit' are not configured on /var/shared"
    FAILED=1
fi

# Assertion 2: Verify user 'audit' does NOT have write permissions on /var/shared (read-only)
if su - audit -c "touch /var/shared/test_write" &>/dev/null; then
    echo "❌ [FAIL] ACL: User 'audit' has write permission on /var/shared (should be read-only)"
    FAILED=1
    # Cleanup if file was written
    rm -f /var/shared/test_write
else
    echo "✅ [PASS] ACL: User 'audit' is correctly blocked from writing to /var/shared"
fi

# Assertion 3: Verify sudoers configuration for user 'operator'
sudo_output=$(sudo -l -U operator 2>&1)

if echo "$sudo_output" | grep -qi "not allowed to run sudo"; then
    echo "❌ [FAIL] Sudoers: User 'operator' is not allowed to run sudo at all"
    FAILED=1
else
    # 3a. Verify they have access to service control commands (systemctl or service)
    if echo "$sudo_output" | grep -E "systemctl|service" >/dev/null; then
        echo "✅ [PASS] Sudoers: User 'operator' is allowed to execute service/systemctl control commands"
    else
        echo "❌ [FAIL] Sudoers: User 'operator' does not have access to run service or systemctl"
        FAILED=1
    fi

    # 3b. Verify they are NOT allowed to run arbitrary commands (ALL)
    # Check if they have the broad (ALL : ALL) ALL privilege
    if echo "$sudo_output" | grep -q "(ALL) ALL" || echo "$sudo_output" | grep -q "ALL=ALL" || echo "$sudo_output" | grep -q "(ALL : ALL) ALL"; then
        echo "❌ [FAIL] Sudoers: User 'operator' has unrestricted root access (ALL). Must be limited to services only."
        FAILED=1
    else
        echo "✅ [PASS] Sudoers: User 'operator' command execution is restricted"
    fi
fi

# Assertion 4: Verify SSH configuration hardening
# Run sshd -T to verify active runtime values (compiles main config + include dirs)
if sshd -T 2>/dev/null | grep -qi "^passwordauthentication no"; then
    echo "✅ [PASS] SSH: PasswordAuthentication is disabled"
else
    echo "❌ [FAIL] SSH: PasswordAuthentication is still enabled"
    FAILED=1
fi

if sshd -T 2>/dev/null | grep -qi "^pubkeyauthentication yes"; then
    echo "✅ [PASS] SSH: PubkeyAuthentication is enabled"
else
    echo "❌ [FAIL] SSH: PubkeyAuthentication is disabled"
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
