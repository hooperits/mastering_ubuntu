#!/bin/bash
set -e

# 1. Kill any existing leaker processes
pkill -f "/usr/local/bin/leaker" || true
rm -f /usr/local/bin/leaker

# 2. Write the leaker script
cat << 'EOF' > /usr/local/bin/leaker
#!/usr/bin/env python3
import time
# Mock memory array to allocate ~15MB
dummy_data = [bytearray(1024 * 1024) for _ in range(15)]
try:
    while True:
        time.sleep(2)
except KeyboardInterrupt:
    pass
EOF
chmod +x /usr/local/bin/leaker

# 3. Launch leaker process in background
nohup /usr/local/bin/leaker &>/dev/null &

# 4. Clean and recreate inode files directory
rm -rf /var/log/app
mkdir -p /var/log/app/inodes

# 5. Populate directory with 5000 small empty files (inode accumulation mock)
# Using seq to run fast inside container
for i in $(seq 1 5000); do
    touch "/var/log/app/inodes/log-file-${i}.log"
done
echo "Setup complete. Simulated process active and 5000 file inodes created under /var/log/app/inodes/"
