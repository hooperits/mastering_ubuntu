#!/bin/bash

# Verification script for Lab 04: Storage & LVM Partitioning
# Returns exit code 0 if all assertions pass, non-zero otherwise.

FAILED=0

echo "🔍 Auditing Labyrinth Lab 04 (Storage & LVM Partitioning) state..."
echo ""

# Assertion 1: Verify LVM Script /root/lvm-setup.sh exists and has correct commands
SCRIPT_FILE="/root/lvm-setup.sh"
if [ -f "$SCRIPT_FILE" ]; then
    echo "✅ [PASS] LVM Script: File /root/lvm-setup.sh exists"
    
    # Check for pvcreate
    if grep -q "pvcreate " "$SCRIPT_FILE" && grep -q "/dev/sdb" "$SCRIPT_FILE"; then
        echo "✅ [PASS] LVM Script: Includes physical volume creation (pvcreate) on /dev/sdb"
    else
        echo "❌ [FAIL] LVM Script: Missing pvcreate command targeting /dev/sdb"
        FAILED=1
    fi
    
    # Check for vgcreate
    if grep -q "vgcreate " "$SCRIPT_FILE" && grep -q "vg_data" "$SCRIPT_FILE"; then
        echo "✅ [PASS] LVM Script: Includes volume group creation (vgcreate) named 'vg_data'"
    else
        echo "❌ [FAIL] LVM Script: Missing vgcreate command for volume group 'vg_data'"
        FAILED=1
    fi
    
    # Check for lvcreate
    if grep -q "lvcreate " "$SCRIPT_FILE" && grep -q "lv_storage" "$SCRIPT_FILE"; then
        echo "✅ [PASS] LVM Script: Includes logical volume creation (lvcreate) named 'lv_storage'"
    else
        echo "❌ [FAIL] LVM Script: Missing lvcreate command for logical volume 'lv_storage'"
        FAILED=1
    fi
    
    # Check for mkfs.ext4
    if grep -q "mkfs" "$SCRIPT_FILE" && grep -q "ext4" "$SCRIPT_FILE"; then
        echo "✅ [PASS] LVM Script: Includes filesystem format operation (mkfs.ext4)"
    else
        echo "❌ [FAIL] LVM Script: Missing format command (mkfs.ext4) inside setup script"
        FAILED=1
    fi
else
    echo "❌ [FAIL] LVM Script: File /root/lvm-setup.sh is missing"
    FAILED=1
fi

# Assertion 2: Verify Swap file size, permissions and fstab entry
SWAP_FILE="/swapfile"
if [ -f "$SWAP_FILE" ]; then
    # Size check (200MB to 300MB)
    size=$(stat -c%s "$SWAP_FILE" 2>/dev/null || echo 0)
    # 200MB = 209715200 bytes, 300MB = 314572800 bytes
    if [ "$size" -ge 209715200 ] && [ "$size" -le 314572800 ]; then
        echo "✅ [PASS] Swapfile: File size is correct (~256MB)"
    else
        echo "❌ [FAIL] Swapfile: File size is $size bytes (should be between 200MB and 300MB)"
        FAILED=1
    fi
    
    # Permissions check (600)
    perms=$(stat -c%a "$SWAP_FILE" 2>/dev/null || echo 0)
    if [ "$perms" -eq 600 ]; then
        echo "✅ [PASS] Swapfile: Permissions are secure (0600)"
    else
        echo "❌ [FAIL] Swapfile: Permissions are $perms (should be 600)"
        FAILED=1
    fi
    
    # /etc/fstab entry check for swap
    if grep -q "/swapfile" /etc/fstab && grep -q "swap" /etc/fstab; then
        echo "✅ [PASS] Swapfile: Persistent entry exists in /etc/fstab"
    else
        echo "❌ [FAIL] Swapfile: Persistent entry is missing in /etc/fstab"
        FAILED=1
    fi
else
    echo "❌ [FAIL] Swapfile: File /swapfile does not exist"
    FAILED=1
fi

# Assertion 3: Verify fstab persistent mount configuration for UUID fe382b90-1c39-4d82-89b2-38d73b22b100
TARGET_UUID="fe382b90-1c39-4d82-89b2-38d73b22b100"
if grep -q "$TARGET_UUID" /etc/fstab; then
    # Check directory, filesystem, and nofail option
    if grep -E "$TARGET_UUID.*/mnt/data.*ext4.*nofail" /etc/fstab >/dev/null; then
        echo "✅ [PASS] Mount: Persistent mount configuration for UUID $TARGET_UUID is correct and has 'nofail' flag"
    else
        echo "❌ [FAIL] Mount: Persistent config matches wrong parameters (must target /mnt/data, use ext4, and contain the 'nofail' option)"
        FAILED=1
    fi
else
    echo "❌ [FAIL] Mount: No fstab entry found for disk UUID $TARGET_UUID"
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
