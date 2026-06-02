#!/bin/bash
set -e

# Try to install libpam-pwquality in case caching/mirror is available (fallback gracefully)
apt-get update -qq || true
apt-get install -y -qq libpam-pwquality &>/dev/null || true

# Restore default /etc/pam.d/common-auth
cat << 'EOF' > /etc/pam.d/common-auth
# Default common-auth file baseline
auth	[success=1 default=ignore]	pam_unix.so nullok
auth	requisite			pam_deny.so
auth	required			pam_permit.so
EOF

# Restore default /etc/pam.d/common-account
cat << 'EOF' > /etc/pam.d/common-account
# Default common-account file baseline
account	[success=1 default=ignore]	pam_unix.so
account	requisite			pam_deny.so
account	required			pam_permit.so
EOF

# Restore default /etc/pam.d/common-password
cat << 'EOF' > /etc/pam.d/common-password
# Default common-password file baseline
password	[success=1 default=ignore]	pam_unix.so obscure sha512
password	required			pam_deny.so
EOF
