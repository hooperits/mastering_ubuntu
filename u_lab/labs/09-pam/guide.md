# 🚀 Lab 09: PAM Security & User Hardening

## Scenario Context
Ubuntu Server uses the **Pluggable Authentication Modules (PAM)** architecture to handle authentication, authorization, sessions, and password management. Security compliance standards (like PCI-DSS) mandate that servers lock out users after multiple failed logins and enforce password complexity.

Your task is to configure PAM to enforce brute-force lockouts and require complex passwords.

---

## 🎯 Lab Objectives

### 1. Enforce Bruteforce Login Lockouts
Configure the system to lock out accounts after **3 failed login attempts**:
- Edit `/etc/pam.d/common-auth`. Add the `pam_faillock.so` module constraints:
  - Add `auth required pam_faillock.so preauth silent deny=3 unlock_time=600` before `pam_unix.so`.
  - Add `auth [default=die] pam_faillock.so authfail deny=3 unlock_time=600` after `pam_unix.so`.
- Edit `/etc/pam.d/common-account` to clear lockouts on successful login:
  - Add `account required pam_faillock.so`.

### 2. Configure Password Complexity Rules
Enforce password constraints:
- Edit `/etc/pam.d/common-password`. Add the `pam_pwquality.so` module rules:
  - Add `password required pam_pwquality.so retry=3 minlen=12 dcredit=-1 ucredit=-1` before `pam_unix.so`.
  - *(This specifies a minimum length of 12 characters, and requires at least 1 digit and 1 uppercase letter).*

---

## 🔍 PAM Configuration Reference

### Failed Login Lockouts (`/etc/pam.d/common-auth`):
```text
# Ensure pam_faillock is configured preauth (before pam_unix) and authfail (after pam_unix)
auth        required      pam_env.so
auth        required      pam_faillock.so preauth silent deny=3 unlock_time=600
auth        [success=1 default=ignore]    pam_unix.so nullok
auth        [default=die] pam_faillock.so authfail deny=3 unlock_time=600
auth        requisite     pam_deny.so
auth        required      pam_permit.so
```

### Resetting Lockouts (`/etc/pam.d/common-account`):
```text
# Ensure pam_faillock registers session resets
account     required      pam_faillock.so
account     [success=1 default=ignore]    pam_unix.so
account     requisite     pam_deny.so
account     required      pam_permit.so
```

### Password Quality (`/etc/pam.d/common-password`):
```text
# Add pam_pwquality before pam_unix
password    required      pam_pwquality.so retry=3 minlen=12 dcredit=-1 ucredit=-1
password    [success=1 default=ignore]    pam_unix.so obscure sha512
password    required      pam_deny.so
```

### Operational Commands:
* **Check lockout status for a user**:
  ```bash
  faillock --user <username>
  ```
* **Reset lockouts for a user**:
  ```bash
  faillock --user <username> --reset
  ```

---

## 💡 How to Complete
1. Use `u-lab attach 09-pam` to enter the container.
2. Edit `/etc/pam.d/common-auth` to add the `pam_faillock.so` rules with `deny=3`.
3. Edit `/etc/pam.d/common-account` to register `pam_faillock.so`.
4. Edit `/etc/pam.d/common-password` to add `pam_pwquality.so` with `minlen=12`.
5. Exit the container and run `u-lab check 09-pam` to verify.
