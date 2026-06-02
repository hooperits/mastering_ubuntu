#!/bin/bash
set -e

# 1. Reset /etc/fstab to baseline settings
cat << 'EOF' > /etc/fstab
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
EOF

# 2. Clean out swap file if pre-existing
rm -f /swapfile

# 3. Clean out script files
rm -f /root/lvm-setup.sh

# 4. Create target mount directory
mkdir -p /mnt/data
