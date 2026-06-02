#!/bin/bash

# Verification script for Lab 11: System Log Auditing & Monitoring
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 11 (System Log Auditing & Monitoring) state..."
echo ""

SCRIPT="/root/block-attackers.sh"
IPS_FILE="/tmp/block_ips.txt"

# Clean prior run outputs to test execution from scratch
rm -f "$IPS_FILE"
iptables -F INPUT || true

# Assertion 1: Verify log-auditing script exists and is executable
if [ -x "$SCRIPT" ]; then
    echo "✅ [PASS] Script: File $SCRIPT exists and is executable"
    
    # Execute the script
    if "$SCRIPT" &>/dev/null; then
         echo "✅ [PASS] Script: Executed successfully with status code 0"
    else
         echo "❌ [FAIL] Script: Execution failed (returned non-zero exit status)"
         FAILED=1
    fi
else
    echo "❌ [FAIL] Script: File $SCRIPT is missing or not executable"
    FAILED=1
fi

# Assertion 2: Verify /tmp/block_ips.txt contains exactly the malicious IPs
if [ -f "$IPS_FILE" ]; then
    # Attacking IPs should be:
    # 198.51.100.12 (6 failed attempts)
    # 203.0.113.88 (6 failed attempts)
    # 192.168.1.50 has only 2, 192.0.2.1 has only 1, 192.168.1.10 is accepted
    
    if grep -q "198.51.100.12" "$IPS_FILE" && grep -q "203.0.113.88" "$IPS_FILE"; then
         # Count total lines
         line_count=$(wc -l < "$IPS_FILE")
         # Cleanup formatting differences
         line_count=$(echo $line_count | xargs)
         if [ "$line_count" -eq 2 ]; then
              echo "✅ [PASS] Output List: /tmp/block_ips.txt contains exactly the 2 brute-forcing IPs"
         else
              echo "❌ [FAIL] Output List: /tmp/block_ips.txt contains wrong number of entries (contains $line_count entries, should be 2)"
              FAILED=1
         fi
    else
         echo "❌ [FAIL] Output List: /tmp/block_ips.txt is missing one or both malicious IPs"
         FAILED=1
    fi
else
    echo "❌ [FAIL] Output List: File $IPS_FILE was not created"
    FAILED=1
fi

# Assertion 3: Verify IPTables block rules
if iptables -L INPUT -n | grep -E "DROP.*198.51.100.12" >/dev/null || iptables -S INPUT | grep -E "198.51.100.12.*DROP" >/dev/null; then
     echo "✅ [PASS] Firewall: iptables DROP rule is active for IP 198.51.100.12"
else
     echo "❌ [FAIL] Firewall: Missing iptables DROP rule for IP 198.51.100.12"
     FAILED=1
fi

if iptables -L INPUT -n | grep -E "DROP.*203.0.113.88" >/dev/null || iptables -S INPUT | grep -E "203.0.113.88.*DROP" >/dev/null; then
     echo "✅ [PASS] Firewall: iptables DROP rule is active for IP 203.0.113.88"
else
     echo "❌ [FAIL] Firewall: Missing iptables DROP rule for IP 203.0.113.88"
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
