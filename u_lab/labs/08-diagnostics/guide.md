# 🚀 Lab 08: System Diagnostics & Performance

## Scenario Context
Your server is experiencing slow response times. System monitoring indicates a process is consuming server memory, and logs report filesystem errors due to "No space left on device" (which often indicates available disk space is fine, but **filesystem inodes** are completely exhausted by millions of small files).

Your task is to identify and terminate the leaking process, locate the directory clogging the inodes, and delete it.

---

## 🎯 Lab Objectives

### 1. Terminate Resource Leaks
Analyze running processes using tools like `ps`, `top`, or `pgrep`:
- Identify the process named `leaker` that is running in the background.
- Kill the process cleanly or force terminate it.

### 2. Resolve Inode Exhaustion
Locate files accumulating on the drive:
- Identify the directory under `/var/log/app/` that contains a massive accumulation of small log files.
- Delete the files or the folder itself to reclaim available filesystem inodes.

---

## 🔍 Diagnostics Command Reference

### Process Profiling:
* **Display active CPU/Memory usage**:
  ```bash
  top -b -n 1 | head -n 30
  ```
* **Filter processes by memory consumption**:
  ```bash
  ps aux --sort=-%mem | head -n 15
  ```
* **Kill process by name or PID**:
  ```bash
  pkill -f leaker
  # Or force-kill:
  kill -9 <PID>
  ```

### Filesystem Inodes Auditing:
* **Check inode usage percentage per mount point**:
  ```bash
  df -i
  ```
* **Search directories recursively and count files**:
  ```bash
  find /var/log -type d -exec sh -c 'echo -n "{}: "; find "{}" -maxdepth 1 -type f | wc -l' \;
  ```
  *(This prints each directory name and the number of files inside it, helping locate file clusters)*
* **Delete massive directories fast**:
  ```bash
  rm -rf /var/log/app/inodes/
  ```

---

## 💡 How to Complete
1. Use `u-lab attach 08-diagnostics` to enter the container.
2. Run `ps aux` to locate the PID of `/usr/local/bin/leaker`.
3. Kill the process.
4. Scan `/var/log` for file accumulation. Locate the folder with 5000 small log files.
5. Delete `/var/log/app/inodes/`.
6. Exit the container and run `u-lab check 08-diagnostics` to verify.
