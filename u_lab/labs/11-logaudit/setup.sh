#!/bin/bash
set -e

# 1. Create a simulated security log file with brute force SSH attacks
mkdir -p /var/log
cat << 'EOF' > /var/log/auth_brute.log
Jun  2 10:00:01 ubuntu sshd[12345]: Failed password for invalid user admin from 198.51.100.12 port 34522 ssh2
Jun  2 10:00:05 ubuntu sshd[12345]: Failed password for invalid user root from 198.51.100.12 port 34526 ssh2
Jun  2 10:01:10 ubuntu sshd[12348]: Failed password for user support from 192.168.1.50 port 41200 ssh2
Jun  2 10:01:12 ubuntu sshd[12345]: Failed password for invalid user admin from 198.51.100.12 port 34530 ssh2
Jun  2 10:01:15 ubuntu sshd[12345]: Failed password for invalid user guest from 198.51.100.12 port 34532 ssh2
Jun  2 10:02:20 ubuntu sshd[12352]: Failed password for invalid user oracle from 203.0.113.88 port 51100 ssh2
Jun  2 10:02:22 ubuntu sshd[12348]: Failed password for user support from 192.168.1.50 port 41202 ssh2
Jun  2 10:02:25 ubuntu sshd[12345]: Failed password for invalid user postgres from 198.51.100.12 port 34536 ssh2
Jun  2 10:02:30 ubuntu sshd[12352]: Failed password for invalid user root from 203.0.113.88 port 51102 ssh2
Jun  2 10:03:01 ubuntu sshd[12345]: Failed password for invalid user admin from 198.51.100.12 port 34540 ssh2
Jun  2 10:03:10 ubuntu sshd[12352]: Failed password for invalid user user1 from 203.0.113.88 port 51106 ssh2
Jun  2 10:03:20 ubuntu sshd[12352]: Failed password for invalid user test from 203.0.113.88 port 51110 ssh2
Jun  2 10:03:30 ubuntu sshd[12352]: Failed password for invalid user ftp from 203.0.113.88 port 51114 ssh2
Jun  2 10:04:01 ubuntu sshd[12352]: Failed password for invalid user mysql from 203.0.113.88 port 51118 ssh2
Jun  2 10:04:12 ubuntu sshd[12360]: Failed password for user ubuntu from 192.0.2.1 port 38902 ssh2
Jun  2 10:05:00 ubuntu sshd[12345]: Accepted publickey for user juanca from 192.168.1.10 port 42300 ssh2
EOF

# 2. Clean out files
rm -f /root/block-attackers.sh
rm -f /tmp/block_ips.txt

# 3. Clean IPTables rules in INPUT chain
iptables -F INPUT || true
