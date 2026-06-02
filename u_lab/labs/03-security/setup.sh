#!/bin/bash
set -e

# 1. Create standard system user accounts
id -u operator &>/dev/null || useradd -m -s /bin/bash operator
id -u audit &>/dev/null || useradd -m -s /bin/bash audit

# Set passwords (simple baseline)
echo "operator:operator123" | chpasswd
echo "audit:audit123" | chpasswd

# 2. Create restricted folder structure
mkdir -p /var/shared
chown root:root /var/shared
chmod 700 /var/shared
# Remove any prior ACLs
setfacl -b /var/shared || true

# 3. Clean sudoers configurations
rm -f /etc/sudoers.d/operator
rm -f /etc/sudoers.d/audit

# 4. Set SSH unhardened state
mkdir -p /etc/ssh/sshd_config.d
rm -f /etc/ssh/sshd_config.d/*.conf

# Configure sshd_config with password auth enabled
if [ -f /etc/ssh/sshd_config ]; then
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
else
    # Fallback if config is missing
    cat << 'EOF' > /etc/ssh/sshd_config
PasswordAuthentication yes
PubkeyAuthentication yes
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
EOF
fi

# Ensure ssh host keys are generated and start sshd service
ssh-keygen -A || true
systemctl restart ssh || systemctl restart sshd || true
