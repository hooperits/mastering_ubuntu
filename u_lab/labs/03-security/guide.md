# 🚀 Lab 03: Permissions & Security Hardening

## Scenario Context
You have been hired as a security auditor for an Ubuntu server staging machine. The current directory configuration leaks administrative directories, standard users have unrestricted access, and the SSH daemon allows password login (subjecting it to brute-force attacks).

You need to lock down access privileges and harden the SSH server.

---

## 🎯 Lab Objectives

### 1. Configure ACLs on a Shared Directory
Configure access privileges for the directory `/var/shared/`:
- The directory is owned by `root:root` and has permission `700` (blocking standard groups/others).
- Grant the user `audit` read access (`r-x` or `r--`) to `/var/shared/` using Access Control Lists (ACLs).
- Ensure the user `audit` **cannot** write to the directory.

### 2. Restrict Sudo Executions
Allow the user `operator` to run administrative service controls, but limit them from executing arbitrary system commands:
- Create a sudoers rule file (e.g. `/etc/sudoers.d/operator`).
- Allow user `operator` to run `/usr/bin/systemctl` or `/usr/sbin/service` commands.
- Ensure the user `operator` is **blocked** from running broad commands (they must not have the unrestricted `(ALL) ALL` rule).

### 3. Harden SSH Daemon
Harden SSH ingress options:
- Disable password-based logins: Set `PasswordAuthentication no`.
- Enable key-based logins: Set `PubkeyAuthentication yes`.
- Ensure changes are loaded by restarting the SSH service.

---

## 🔍 Security Command Reference

### Advanced Access Control Lists (ACLs):
To set user-specific access controls without changing default file groups:
* **Read-only permission grant**:
  ```bash
  setfacl -m u:audit:rx /var/shared
  ```
* **Verify permissions layout**:
  ```bash
  getfacl /var/shared
  ```

### Sudoers Configuration:
To edit sudoers files safely, use the syntax-validating editor:
* **Edit sudoers rules**:
  ```bash
  visudo -f /etc/sudoers.d/operator
  ```
* **Rule format example**:
  ```text
  operator ALL=(ALL) NOPASSWD: /usr/bin/systemctl, /usr/sbin/service
  ```
  *(This allows the operator to execute systemctl and service commands as root without a password prompt)*

### SSH Configuration:
* Check file paths `/etc/ssh/sshd_config` or files in `/etc/ssh/sshd_config.d/`.
* Change settings to:
  ```text
  PasswordAuthentication no
  PubkeyAuthentication yes
  ```
* **Reload daemon state**:
  ```bash
  systemctl restart ssh
  ```

---

## 💡 How to Complete
1. Use `u-lab attach 03-security` to enter the container.
2. Grant read ACL access to user `audit` on `/var/shared`.
3. Create the `/etc/sudoers.d/operator` file with the custom limited rule.
4. Edit the SSH config files to disable PasswordAuthentication and restart the SSH service.
5. Exit the container and run `u-lab check 03-security` to audit.
