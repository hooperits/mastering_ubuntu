# 🚀 Lab 01: Systemd Service Mastery

## Scenario Context
An administrator created a custom web application script at `/usr/local/bin/web-app.sh` and set up a systemd service unit at `/etc/systemd/system/web-app.service` to manage it. Unfortunately, the app is failing to start, and running it as `root` violates security policies.

Your job is to diagnose the failure, secure the service by running it as a standard system user, and make it resilient by adding an auto-restart policy.

---

## 🎯 Lab Objectives
1. **Fix the Path**: Locate the executable script and correct the `ExecStart` path in `/etc/systemd/system/web-app.service`.
2. **Apply Principle of Least Privilege**: Configure the service to run as the standard `sysadm` user (already created for you) rather than `root`.
3. **Configure Auto-Restart**: Setup systemd to automatically restart the service if it encounters failures.
4. **Boot and Activate**: Reload the systemd daemon configuration, start the service, and verify it is running on port 80.

---

## 🔍 Handy Troubleshooting Commands
Here are some helpful Ubuntu/systemd command patterns you can use inside the container:

* **Inspect service logs**:
  ```bash
  journalctl -u web-app.service -n 50 --no-pager
  ```
* **Check systemd service status**:
  ```bash
  systemctl status web-app.service
  ```
* **Reload configuration changes**:
  ```bash
  systemctl daemon-reload
  ```
* **Verify listening sockets**:
  ```bash
  ss -lntp
  ```

---

## 💡 How to Complete
1. Use `u-lab attach 01-systemd` to enter the container.
2. Edit `/etc/systemd/system/web-app.service` using `vim` or `nano`.
3. Save, reload systemd (`systemctl daemon-reload`), and restart the service (`systemctl restart web-app`).
4. Once you see the service is active and listening on port 80, exit the container and run `u-lab check 01-systemd` on your host.
