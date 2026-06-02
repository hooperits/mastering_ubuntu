#!/bin/bash

# Verification script for Lab 12: Container Engine Deployments
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 12 (Container Engine Deployments) state..."
echo ""

SCRIPT="/root/launch-container.sh"
COMPOSE="/root/docker-compose.yml"

# Assertion 1: Verify launcher script exists and is executable
if [ -f "$SCRIPT" ]; then
    if [ -x "$SCRIPT" ]; then
         echo "✅ [PASS] Launcher Script: File $SCRIPT exists and is executable"
    else
         echo "❌ [FAIL] Launcher Script: File $SCRIPT is not executable (run 'chmod +x')"
         FAILED=1
    fi
    
    # Check for docker network create
    if grep -q "docker network create" "$SCRIPT" && grep -q "mastery-net" "$SCRIPT"; then
         echo "✅ [PASS] Launcher Script: Includes bridge network creation ('mastery-net')"
    else
         echo "❌ [FAIL] Launcher Script: Missing 'docker network create mastery-net' command"
         FAILED=1
    fi

    # Check for docker run
    if grep -q "docker run" "$SCRIPT" && grep -q "\--name web-nested" "$SCRIPT"; then
         echo "✅ [PASS] Launcher Script: Includes docker run statement targeting container name 'web-nested'"
    else
         echo "❌ [FAIL] Launcher Script: Missing 'docker run' command with '--name web-nested'"
         FAILED=1
    fi
    
    # Check for network mapping in docker run
    if grep -q "\--network mastery-net" "$SCRIPT" || grep -q "\--net mastery-net" "$SCRIPT"; then
         echo "✅ [PASS] Launcher Script: Docker run statements map network to 'mastery-net'"
    else
         echo "❌ [FAIL] Launcher Script: Docker run statement is missing network assignment ('--network mastery-net')"
         FAILED=1
    fi

    # Check for port bindings in docker run
    if grep -q "\-p 8080:80" "$SCRIPT" || grep -q "\--publish 8080:80" "$SCRIPT" || grep -q "\--publish=8080:80" "$SCRIPT"; then
         echo "✅ [PASS] Launcher Script: Docker run statements bind host port 8080 to container port 80"
    else
         echo "❌ [FAIL] Launcher Script: Docker run statement is missing port binding ('-p 8080:80')"
         FAILED=1
    fi
else
    echo "❌ [FAIL] Launcher Script: File $SCRIPT does not exist"
    FAILED=1
fi

# Assertion 2: Verify docker-compose.yml parameters structure
if [ -f "$COMPOSE" ]; then
    python3 - << 'EOF'
import sys
import yaml

try:
    with open('/root/docker-compose.yml', 'r') as f:
        data = yaml.safe_load(f)
except Exception as e:
    print(f"❌ [FAIL] Compose: File is not valid YAML: {e}")
    sys.exit(1)

try:
    services = data.get('services', {})
    if not services:
        print("❌ [FAIL] Compose: No services block defined")
        sys.exit(1)
        
    # Look for a web or app service
    web_service = None
    for name, s in services.items():
        # Match service with nginx:alpine image or mapping port 8080
        img = s.get('image', '')
        ports = s.get('ports', [])
        if 'nginx:alpine' in img or '8080:80' in ports:
            web_service = s
            break
            
    if not web_service:
        print("❌ [FAIL] Compose: Missing app/web service using 'nginx:alpine' or mapping '8080:80'")
        sys.exit(1)
        
    # Check port mapping
    ports = web_service.get('ports', [])
    if '8080:80' not in ports:
        print("❌ [FAIL] Compose: Target service ports do not map '8080:80'")
        sys.exit(1)
        
    # Check volume mapping
    vols = web_service.get('volumes', [])
    has_vol = False
    for v in vols:
        if '/var/www/html:/usr/share/nginx/html' in v:
            has_vol = True
            break
    if not has_vol:
        print("❌ [FAIL] Compose: Target service volumes must mount '/var/www/html' to '/usr/share/nginx/html'")
        sys.exit(1)
        
    print("✅ [PASS] Compose: File structure, services, ports, and volumes are correct")
    sys.exit(0)
    
except Exception as e:
    print(f"❌ [FAIL] Compose: Failed during properties validation: {e}")
    sys.exit(1)
EOF

    if [ $? -ne 0 ]; then
        FAILED=1
    fi
else
    echo "❌ [FAIL] Compose: File /root/docker-compose.yml does not exist"
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
