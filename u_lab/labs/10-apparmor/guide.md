# 🚀 Lab 10: AppArmor Security Profiles

## Scenario Context
Ubuntu Server uses **AppArmor (Application Armor)** as its default Mandatory Access Control (MAC) system. AppArmor allows administrators to define security profiles for specific binaries (like Nginx, BIND, or SSH), confining their file reads, writes, network bindings, and execution privileges to prevent vulnerabilities exploitation.

Your task is to write an AppArmor security profile to confine Nginx.

---

## 🎯 Lab Objectives

### 1. Create the AppArmor Profile File
Write a profile configuration file at `/etc/apparmor.d/usr.sbin.nginx`:
- The profile must target the Nginx absolute path `/usr/sbin/nginx`.
- Include the standard AppArmor base abstraction imports: `#include <abstractions/base>`.
- Allow read access (`r`) to the web layouts directory: `/var/www/html/` and all its children. (e.g. `/var/www/html/** r`).
- Allow read access (`r`) to Nginx configuration files: `/etc/nginx/** r`.
- Allow read/write access to logs and processes:
  - `/var/log/nginx/** w`
  - `/run/nginx.pid rw`
- Allow standard library links read permissions: `/usr/lib/** r` (or similar).

### 2. Verify Profile Syntax
Validate that the profile contains correct AppArmor parameters syntax:
- Run a parsing check using `apparmor_parser`:
  ```bash
  apparmor_parser -n /etc/apparmor.d/usr.sbin.nginx
  ```
  *(This compiles the policy and checks for syntax errors without loading it into the kernel, allowing verification to succeed even if your host environment doesn't support AppArmor).*

---

## 🔍 AppArmor Profile Reference

### Nginx Profile Template Example (`/etc/apparmor.d/usr.sbin.nginx`):
```text
#include <tunables/global>

/usr/sbin/nginx {
  #include <abstractions/base>
  #include <abstractions/nameservice>

  # Allow reading Nginx configurations
  /etc/nginx/** r;
  /etc/nginx/ s;

  # Allow reading web layouts
  /var/www/html/** r;
  /var/www/html/ r;

  # Allow reading libraries and basic capabilities
  /usr/lib/** r;
  /usr/share/nginx/** r;
  
  # Allow log writing and PID checks
  /var/log/nginx/* w;
  /run/nginx.pid rw;
}
```
*(Make sure to terminate each rule line with a semicolon `;` inside AppArmor profiles!)*

### Operational Commands:
* **Validate configuration syntax (dry-run)**:
  ```bash
  apparmor_parser -n /etc/apparmor.d/usr.sbin.nginx
  ```
* **Enforce the profile (load to kernel)**:
  ```bash
  apparmor_parser -a /etc/apparmor.d/usr.sbin.nginx
  ```
* **Check system AppArmor profiles status**:
  ```bash
  aa-status
  ```

---

## 💡 How to Complete
1. Use `u-lab attach 10-apparmor` to enter the container.
2. Create the file `/etc/apparmor.d/usr.sbin.nginx`.
3. Write the Nginx confinement rules, terminating each path rule with a semicolon `;`.
4. Validate the profile syntax by running `apparmor_parser -n /etc/apparmor.d/usr.sbin.nginx`.
5. Exit the container and run `u-lab check 10-apparmor` to verify.
