#!/bin/bash
set -e

# 1. Create standard system user without login shell
id -u sysadm &>/dev/null || useradd -r -s /usr/sbin/nologin sysadm

# 2. Write the web app script in /usr/local/bin/
cat << 'EOF' > /usr/local/bin/web-app.sh
#!/bin/bash
echo "Web-App service starting on port 80..."
# Start minimal python server on port 80
exec python3 -m http.server 80
EOF
chmod +x /usr/local/bin/web-app.sh

# 3. Create a broken systemd unit pointing to wrong exec path and running as root
cat << 'EOF' > /etc/systemd/system/web-app.service
[Unit]
Description=Labyrinth Web Application
After=network.target

[Service]
Type=simple
# Broken executable path
ExecStart=/usr/bin/web-app.sh
User=root

[Install]
WantedBy=multi-user.target
EOF

# 4. Reload systemd daemon
systemctl daemon-reload
