#!/bin/bash

# Verification script for Lab 05: Package Management & Compilation
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 05 (Package Management & Compilation) state..."
echo ""

# Assertion 1: Verify custom local APT repository source file configuration
APT_FILE="/etc/apt/sources.list.d/local.list"
if [ -f "$APT_FILE" ]; then
    # Verify it references the local repository file path and contains trusted override
    if grep -E "deb.*\[trusted=yes\].*file:/var/local/repo" "$APT_FILE" >/dev/null; then
        echo "✅ [PASS] APT: Local trusted repository configured in /etc/apt/sources.list.d/local.list"
    else
        echo "❌ [FAIL] APT: local.list does not match expected format (must be trusted and point to file:/var/local/repo)"
        FAILED=1
    fi
else
    echo "❌ [FAIL] APT: Repository file /etc/apt/sources.list.d/local.list does not exist"
    FAILED=1
fi

# Assertion 2: Verify shared library libmastery.so compiled and placed
LIB_FILE="/usr/local/lib/libmastery.so"
if [ -f "$LIB_FILE" ]; then
    # Verify it is a valid ELF shared object
    if file "$LIB_FILE" | grep -q "shared object" || file "$LIB_FILE" | grep -q "dynamically linked"; then
        echo "✅ [PASS] Shared Library: libmastery.so compiled and placed in /usr/local/lib/"
    else
        echo "❌ [FAIL] Shared Library: libmastery.so exists but is not a valid shared object"
        FAILED=1
    fi
else
    echo "❌ [FAIL] Shared Library: File /usr/local/lib/libmastery.so does not exist"
    FAILED=1
fi

# Assertion 3: Verify library linker mapping via ldconfig
if ldconfig -p | grep -q "libmastery.so.*usr/local/lib"; then
    echo "✅ [PASS] Linker Cache: libmastery.so successfully cached in ldconfig paths"
else
    echo "❌ [FAIL] Linker Cache: libmastery.so is not registered in ldconfig cache (did you run ldconfig?)"
    FAILED=1
fi

# Assertion 4: Verify application my_app compiled and runs correctly
APP_FILE="/usr/local/bin/my_app"
if [ -x "$APP_FILE" ]; then
    output=$("$APP_FILE" 2>/dev/null)
    if [ "$output" = "Labyrinth: Ubuntu Server Mastery Completed!" ]; then
        echo "✅ [PASS] Application: my_app successfully compiled, linked, and run"
    else
        echo "❌ [FAIL] Application: my_app executed but returned wrong output: '$output'"
        FAILED=1
    fi
else
    echo "❌ [FAIL] Application: Binary /usr/local/bin/my_app does not exist or is not executable"
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
