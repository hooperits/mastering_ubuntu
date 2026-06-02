# 🚀 Lab 06: Web Server & Reverse Proxy Design

## Scenario Context
You are preparing the staging environment for public release. Currently, the server is running a backend Python application directly on port 8080. Exposing this port directly to the internet is slow and insecure.

You need to put Nginx in front of it as a secure reverse proxy, generate a self-signed SSL/TLS certificate to enable HTTPS (port 443), enforce automatic redirect from HTTP (port 80) to HTTPS (port 443), and set up log rotation for the application logs.

---

## 🎯 Lab Objectives

### 1. Generate SSL Certificates
Generate a self-signed SSL certificate and private key using OpenSSL:
- Key Path: `/etc/ssl/private/labyrinth.key`
- Certificate Path: `/etc/ssl/certs/labyrinth.crt`
- Validity: 365 days, RSA 2048-bit key.

### 2. Configure HTTPS Reverse Proxy Block in Nginx
Configure a server block at `/etc/nginx/sites-available/reverse-proxy.conf` and link it to `/etc/nginx/sites-enabled/` to activate it:
- The server block must listen on port `443 ssl`.
- Reference the certificate paths generated in Objective 1.
- Reverse-proxy incoming connections to the upstream backend server running locally at `http://127.0.0.1:8080`.

### 3. Enforce HTTP to HTTPS Redirect
Configure Nginx to listen on port `80`.
- All requests on port 80 must return a permanent HTTP redirect (301 or 302) to `https://$host$request_uri`.

### 4. Configure Log Rotation
Create a custom logrotate configuration block at `/etc/logrotate.d/web-app` for the log files located in `/var/log/web-app/`:
- Rotate interval: **daily**
- Rotation count: Keep **7** rotations (`rotate 7`)
- Operations: `compress`, `delaycompress`, `missingok`, `notifempty`
- Creation directive: `create 0660 www-data www-data`

---

## 🔍 Server Configuration Reference

### OpenSSL Certificate Generation:
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/labyrinth.key \
  -out /etc/ssl/certs/labyrinth.crt
```
*(You can fill out default values or press enter for the prompt fields)*

### Nginx Reverse Proxy Configuration Template:
Write `/etc/nginx/sites-available/reverse-proxy.conf`:
```text
server {
    listen 80;
    server_name localhost;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /etc/ssl/certs/labyrinth.crt;
    ssl_certificate_key /etc/ssl/private/labyrinth.key;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
* **Link configuration file to enable it**:
  ```bash
  ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/
  ```
* **Verify configuration syntax and reload Nginx**:
  ```bash
  nginx -t
  systemctl reload nginx
  ```

### Logrotate Script Configuration Template:
Write `/etc/logrotate.d/web-app`:
```text
/var/log/web-app/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0660 www-data www-data
}
```

---

## 💡 How to Complete
1. Use `u-lab attach 06-webserver` to enter the container.
2. Run the `openssl` command to generate the certificate and key.
3. Define the virtual host server block at `/etc/nginx/sites-available/reverse-proxy.conf`, symbolic link it to sites-enabled, and restart Nginx.
4. Define the Logrotate configuration block at `/etc/logrotate.d/web-app`.
5. Exit the container and run `u-lab check 06-webserver` to audit.
