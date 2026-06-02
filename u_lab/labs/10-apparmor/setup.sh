#!/bin/bash
set -e

# Try installing apparmor-utils (fails gracefully if offline)
apt-get update -qq || true
apt-get install -y -qq apparmor-utils &>/dev/null || true

# 1. Clean Nginx AppArmor profile configuration
rm -f /etc/apparmor.d/usr.sbin.nginx

# 2. Ensure /etc/apparmor.d directory exists
mkdir -p /etc/apparmor.d
