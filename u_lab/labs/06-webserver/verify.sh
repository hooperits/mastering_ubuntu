#!/bin/bash

# Verification script for Lab 06: Web Server & Reverse Proxy Design
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 06 (Web Server & Reverse Proxy Design) state..."
echo ""

# Assertion 1: Verify SSL Certificates exist and are valid
if [ -f "/etc/ssl/certs/labyrinth.crt" ] && [ -f "/etc/ssl/private/labyrinth.key" ]; then
    # Verify certificate details via openssl
    if openssl x509 -in /etc/ssl/certs/labyrinth.crt -text -noout >/dev/null 2>&1; then
        echo "✅ [PASS] SSL: Certificate and Key files exist and compile correctly"
    else
        echo "❌ [FAIL] SSL: Certificate file /etc/ssl/certs/labyrinth.crt is corrupted or not a valid X.509 cert"
        FAILED=1
    fi
else
    echo "❌ [FAIL] SSL: Missing certificate /etc/ssl/certs/labyrinth.crt or private key /etc/ssl/private/labyrinth.key"
    FAILED=1
fi

# Assertion 2: Verify Nginx configurations syntax
if nginx -t >/dev/null 2>&1; then
    echo "✅ [PASS] Nginx: Server configurations are syntax valid"
else
    echo "❌ [FAIL] Nginx: Configuration has syntax errors (check 'nginx -t')"
    FAILED=1
fi

# Assertion 3: Verify Nginx is listening on Ports 80 and 443
if ss -lntp | grep -q ":80 "; then
    echo "✅ [PASS] Network: Port 80 (HTTP) is listening"
else
    echo "❌ [FAIL] Network: Port 80 (HTTP) is not listening (Nginx is offline or misconfigured)"
    FAILED=1
fi

if ss -lntp | grep -q ":443 "; then
    echo "✅ [PASS] Network: Port 443 (HTTPS) is listening"
else
    echo "❌ [FAIL] Network: Port 443 (HTTPS) is not listening"
    FAILED=1
fi

# Assertion 4: Verify HTTP-to-HTTPS redirect rules
redirect_header=$(curl -s -I http://127.0.0.1 2>/dev/null | grep -i "location:" | tr -d '\r\n')
if [[ "$redirect_header" =~ https:// ]]; then
    echo "✅ [PASS] Reverse Proxy: Port 80 requests correctly redirect to HTTPS"
else
    echo "❌ [FAIL] Reverse Proxy: Port 80 requests do not redirect to HTTPS (redirect header is '$redirect_header')"
    FAILED=1
fi

# Assertion 5: Verify HTTPS Proxies requests to port 8080 (python upstream directory)
response_body=$(curl -k -s https://127.0.0.1 2>/dev/null)
if echo "$response_body" | grep -q "Directory listing" || echo "$response_body" | grep -q "HTTP Server"; then
    echo "✅ [PASS] Reverse Proxy: HTTPS port 443 successfully proxies to port 8080 upstream"
else
    echo "❌ [FAIL] Reverse Proxy: HTTPS port 443 proxy failed (did not return upstream body content)"
    FAILED=1
fi

# Assertion 6: Verify Logrotate configuration
LOG_CONF="/etc/logrotate.d/web-app"
if [ -f "$LOG_CONF" ]; then
    # Dry-run check for syntax validation
    if logrotate -d "$LOG_CONF" >/dev/null 2>&1; then
        # Check for rotation interval and limit
        if grep -q "daily" "$LOG_CONF" && grep -qE "rotate[[:space:]]+7" "$LOG_CONF"; then
            echo "✅ [PASS] Logrotate: /etc/logrotate.d/web-app is configured with daily rotations and limit 7"
        else
            echo "❌ [FAIL] Logrotate: /etc/logrotate.d/web-app is missing 'daily' or 'rotate 7' directives"
            FAILED=1
        fi
    else
        echo "❌ [FAIL] Logrotate: Configuration file /etc/logrotate.d/web-app has syntax errors"
        FAILED=1
    fi
else
    echo "❌ [FAIL] Logrotate: Configuration file /etc/logrotate.d/web-app does not exist"
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
