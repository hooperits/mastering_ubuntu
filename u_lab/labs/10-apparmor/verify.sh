#!/bin/bash

# Verification script for Lab 10: AppArmor Security Profiles
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 10 (AppArmor Security Profiles) state..."
echo ""

PROFILE="/etc/apparmor.d/usr.sbin.nginx"

# Assertion 1: Verify profile file exists
if [ -f "$PROFILE" ]; then
    echo "✅ [PASS] Profile: Configuration file $PROFILE exists"
    
    # Assertion 2: Verify it targets /usr/sbin/nginx
    if grep -q "/usr/sbin/nginx" "$PROFILE"; then
        echo "✅ [PASS] Profile: Targets the Nginx binary path (/usr/sbin/nginx)"
    else
        echo "❌ [FAIL] Profile: Missing target path mapping for Nginx binary (/usr/sbin/nginx)"
        FAILED=1
    fi

    # Assertion 3: Verify read access is configured for /var/www/html/
    if grep -E "var/www/html/.*\br" "$PROFILE" >/dev/null || grep -E "var/www/.*r" "$PROFILE" >/dev/null; then
        echo "✅ [PASS] Profile: Confirms read access to web layouts directory (/var/www/html/)"
    else
        echo "❌ [FAIL] Profile: Missing read permissions (r) for /var/www/html/"
        FAILED=1
    fi

    # Assertion 4: Verify syntax checks pass
    if apparmor_parser -n "$PROFILE" >/dev/null 2>&1; then
        echo "✅ [PASS] Parser: Configuration syntax parsed successfully without errors"
    else
        # Try finding if parser exists before failing
        if command -v apparmor_parser >/dev/null 2>&1; then
            echo "❌ [FAIL] Parser: Configuration file has syntax/parse errors"
            FAILED=1
        else
            echo "⚠️ [WARN] Parser: apparmor_parser utility not found. Skipping syntax check."
        fi
    fi
else
    echo "❌ [FAIL] Profile: Configuration file $PROFILE does not exist"
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
