#!/bin/bash

# Verification script for Lab 09: PAM Security & User Hardening
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 09 (PAM Security & User Hardening) state..."
echo ""

# Assertion 1: Check failed login lockout modules and limits (deny=3)
if grep -q "pam_faillock.so" /etc/pam.d/common-auth || grep -q "pam_tally2.so" /etc/pam.d/common-auth; then
    # Check if limit matches deny=3
    if grep -E "pam_faillock.so.*deny=3" /etc/pam.d/common-auth >/dev/null || grep -E "pam_tally2.so.*deny=3" /etc/pam.d/common-auth >/dev/null; then
         echo "✅ [PASS] PAM: common-auth restricts failed logins with limit deny=3"
    else
         echo "❌ [FAIL] PAM: common-auth contains lockout module but is missing or has incorrect limit (must contain 'deny=3')"
         FAILED=1
    fi
else
    echo "❌ [FAIL] PAM: Lockout module (pam_faillock.so or pam_tally2.so) is missing in /etc/pam.d/common-auth"
    FAILED=1
fi

# Assertion 2: Check common-account contains registration rules for lockouts reset
if grep -q "pam_faillock.so" /etc/pam.d/common-account || grep -q "pam_tally2.so" /etc/pam.d/common-account; then
    echo "✅ [PASS] PAM: common-account contains active login registration rules for accounts lockout reset"
else
    echo "❌ [FAIL] PAM: common-account is missing lockout module registration rules"
    FAILED=1
fi

# Assertion 3: Check common-password enforces password strength and length limits (minlen=12)
if grep -q "pam_pwquality.so" /etc/pam.d/common-password; then
    # Check if minimum length matches minlen=12
    if grep -E "pam_pwquality.so.*minlen=12" /etc/pam.d/common-password >/dev/null; then
         echo "✅ [PASS] PAM: common-password enforces minimum password length (minlen=12)"
    else
         echo "❌ [FAIL] PAM: common-password contains pam_pwquality.so but is missing or has incorrect 'minlen=12' option"
         FAILED=1
    fi
else
    echo "❌ [FAIL] PAM: Password quality module (pam_pwquality.so) is missing in /etc/pam.d/common-password"
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
