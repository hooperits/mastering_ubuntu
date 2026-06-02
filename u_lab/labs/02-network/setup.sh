#!/bin/bash
set -e

# 1. Write DHCP template for Netplan to /etc/netplan/50-cloud-init.yaml
# (User must change this to a static IP config)
mkdir -p /etc/netplan
cat << 'EOF' > /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
EOF

# 2. Reset UFW to a completely open configuration to force user implementation
ufw disable
echo "y" | ufw reset
ufw default allow incoming
ufw default allow outgoing

# 3. Ensure hosts file doesn't have our target DNS local entries
sed -i '/labyrinth-db.local/d' /etc/hosts
sed -i '/labyrinth-web.local/d' /etc/hosts
