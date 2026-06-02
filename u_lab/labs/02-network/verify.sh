#!/bin/bash

# Verification script for Lab 02: Network & Firewall Engineering
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 02 (Network & Firewall Engineering) state..."
echo ""

# Assertion 1: Validate Netplan static configurations
python3 - << 'EOF'
import sys
import yaml

try:
    with open('/etc/netplan/50-cloud-init.yaml', 'r') as f:
        data = yaml.safe_load(f)
except Exception as e:
    print(f"❌ [FAIL] Netplan config is not valid YAML: {e}")
    sys.exit(1)

# Check structure
try:
    net = data.get('network', {})
    eths = net.get('ethernets', {})
    eth0 = eths.get('eth0', {})
    
    # 1. Verify DHCP is disabled
    dhcp = eth0.get('dhcp4', True)
    if dhcp is True or dhcp == 'yes':
         print("❌ [FAIL] Netplan: dhcp4 is still enabled or not explicitly set to false/no")
         sys.exit(1)
         
    # 2. Verify static IP address
    addrs = eth0.get('addresses', [])
    if '192.168.1.100/24' not in addrs:
         print("❌ [FAIL] Netplan: addresses does not contain '192.168.1.100/24'")
         sys.exit(1)
         
    # 3. Verify nameservers
    ns = eth0.get('nameservers', {})
    ns_addrs = ns.get('addresses', [])
    if '8.8.8.8' not in ns_addrs or '8.8.4.4' not in ns_addrs:
         print("❌ [FAIL] Netplan: nameservers addresses must contain both 8.8.8.8 and 8.8.4.4")
         sys.exit(1)
         
    # 4. Verify gateway/route pointing to 192.168.1.1
    gateway = eth0.get('gateway4')
    routes = eth0.get('routes', [])
    has_gw = False
    
    if gateway == '192.168.1.1':
        has_gw = True
    else:
        # Check routes lists for default route
        for r in routes:
            if r.get('to') == 'default' and r.get('via') == '192.168.1.1':
                has_gw = True
                break
                
    if not has_gw:
         print("❌ [FAIL] Netplan: missing gateway4: 192.168.1.1 or a default route via 192.168.1.1")
         sys.exit(1)
         
    print("✅ [PASS] Netplan configuration structure and parameters are correct")
    sys.exit(0)
    
except AttributeError as e:
    print(f"❌ [FAIL] Netplan config matches wrong hierarchy schema: {e}")
    sys.exit(1)
EOF

if [ $? -ne 0 ]; then
    FAILED=1
fi

# Assertion 2: Verify /etc/hosts DNS resolution
if getent hosts labyrinth-db.local | grep -q "127.0.0.1"; then
    echo "✅ [PASS] Hostname labyrinth-db.local successfully resolves to 127.0.0.1"
else
    echo "❌ [FAIL] Hostname labyrinth-db.local does not resolve to 127.0.0.1 in /etc/hosts"
    FAILED=1
fi

if getent hosts labyrinth-web.local | grep -q "127.0.0.1"; then
    echo "✅ [PASS] Hostname labyrinth-web.local successfully resolves to 127.0.0.1"
else
    echo "❌ [FAIL] Hostname labyrinth-web.local does not resolve to 127.0.0.1 in /etc/hosts"
    FAILED=1
fi

# Assertion 3: Verify UFW status active
if ufw status | grep -q "Status: active"; then
    echo "✅ [PASS] UFW Firewall is active"
else
    echo "❌ [FAIL] UFW Firewall is not active (Status: inactive)"
    FAILED=1
fi

# Assertion 4: Verify default incoming policy is deny
if ufw status verbose | grep -qi "Default: deny (incoming)"; then
    echo "✅ [PASS] UFW default policy is Deny Incoming"
else
    echo "❌ [FAIL] UFW default incoming policy is not set to deny"
    FAILED=1
fi

# Assertion 5: Verify SSH restriction (Port 22 ALLOW from 192.168.1.0/24)
if ufw status | grep -iE "22/tcp.*ALLOW.*192.168.1.0/24" >/dev/null || ufw status | grep -iE "22.*ALLOW.*192.168.1.0/24" >/dev/null; then
    echo "✅ [PASS] Port 22 (SSH) is allowed only from subnet 192.168.1.0/24"
else
    echo "❌ [FAIL] Port 22 (SSH) rule is missing or not restricted to subnet 192.168.1.0/24"
    FAILED=1
fi

# Assertion 6: Verify HTTP rule (Port 80 ALLOW from Anywhere)
if ufw status | grep -iE "80/tcp.*ALLOW.*Anywhere" >/dev/null || ufw status | grep -iE "80.*ALLOW.*Anywhere" >/dev/null; then
    echo "✅ [PASS] Port 80 (HTTP) is allowed from anywhere"
else
    echo "❌ [FAIL] Port 80 (HTTP) rule is missing or not allowed from Anywhere"
    FAILED=1
fi

# Assertion 7: Verify DB blocked rule (Port 3306 DENY from Anywhere)
if ufw status | grep -iE "3306/tcp.*DENY.*Anywhere" >/dev/null || ufw status | grep -iE "3306.*DENY.*Anywhere" >/dev/null; then
    echo "✅ [PASS] Port 3306 (DB) is explicitly denied from anywhere"
else
    echo "❌ [FAIL] Port 3306 (DB) is not denied from Anywhere"
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
