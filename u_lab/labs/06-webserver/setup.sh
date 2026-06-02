#!/bin/bash
set -e

# 1. Create a persistent application server running on port 8080 via systemd
cat << 'EOF' > /etc/systemd/system/app-server.service
[Unit]
Description=Labyrinth App Upstream Server
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 -m http.server 8080
Restart=always
WorkingDirectory=/tmp

[Install]
WantedBy=multi-user.target
EOF

# 2. Reload systemd and start the app-server
systemctl daemon-reload
systemctl enable app-server
systemctl restart app-server

# 3. Create app log directory and dummy files for logrotate
mkdir -p /var/log/web-app
touch /var/log/web-app/access.log
chown -R www-data:www-data /var/log/web-app

# 4. Clear default Nginx site configurations
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-enabled/reverse-proxy.conf
rm -f /etc/nginx/sites-available/reverse-proxy.conf

# 5. Remove any pre-existing SSL certificate configurations
rm -f /etc/ssl/certs/labyrinth.crt
rm -f /etc/ssl/private/labyrinth.key

# 6. Remove any pre-existing logrotate configurations
rm -f /etc/logrotate.d/web-app

# 7. Restart Nginx to load configuration changes
systemctl restart nginx || true
