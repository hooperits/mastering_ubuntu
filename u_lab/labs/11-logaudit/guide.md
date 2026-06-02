# 🚀 Lab 11: System Log Auditing & Monitoring

## Scenario Context
Your server is constantly targeted by ssh brute force attacks. Analyzing security authentication logs (`/var/log/auth.log` or equivalent) lets you detect failed login spikes. In enterprise setups, you write log-monitoring scripts to parse logs, extract attacking IPs, and block them dynamically in the firewall.

Your task is to write a script that does this automatically against a simulated log at `/var/log/auth_brute.log`.

---

## 🎯 Lab Objectives

### 1. Write the Log Parser Script
Create a bash script at `/root/block-attackers.sh`:
- It must parse `/var/log/auth_brute.log` to find lines containing `Failed password`.
- Count the number of failed attempts per IP address.
- Extract unique IP addresses that have **more than 5 failed attempts** (i.e. strictly greater than 5).
- Output the unique list of these IP addresses (one per line) to `/tmp/block_ips.txt`.

### 2. Append IPTables Drop Rules
Extend `/root/block-attackers.sh` to read the extracted list and dynamically block the IPs:
- For each IP address written to `/tmp/block_ips.txt`, append an IPTables rules drop statement in the `INPUT` chain.
- Command syntax: `iptables -A INPUT -s <IP> -j DROP`
- Ensure the script is executable (`chmod +x`).

---

## 🔍 Log Parsing & Firewall Reference

### Parsing logs using grep, awk, and sort:
To search for failures and count instances:
* Filter lines and print column 11 (where the IP address resides in standard SSH logs):
  ```bash
  grep "Failed password" /var/log/auth_brute.log | awk '{print $11}'
  ```
  *(Note: In the mock log format, check the column position of the IP address. For 'Failed password for invalid user admin from 198.51.100.12 ...', the IP address is at column 11. For 'Failed password for user support from 192.168.1.50 ...', the IP address is at column 9).*
  
  **Pro-Tip**: You can use regular expression matches inside `grep` to extract IP addresses robustly regardless of column index:
  ```bash
  grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" /var/log/auth_brute.log
  ```
* **Aggregate and count unique lines**:
  ```bash
  grep "Failed password" /var/log/auth_brute.log | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sort | uniq -c
  ```
  *(This outputs lines like: '6 198.51.100.12' indicating 6 occurrences of that IP).*
* **Filter counts greater than 5 and extract IP**:
  ```bash
  grep "Failed password" /var/log/auth_brute.log | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sort | uniq -c | awk '$1 > 5 {print $2}'
  ```

### Appending Firewall Blocks (IPTables):
* **Block traffic from an IP**:
  ```bash
  iptables -A INPUT -s 198.51.100.12 -j DROP
  ```
* **List active rules in detail**:
  ```bash
  iptables -L INPUT -n -v
  ```

---

## 💡 How to Complete
1. Use `u-lab attach 11-logaudit` to enter the container.
2. Formulate your grep/awk/sort command chain to extract the target IPs from `/var/log/auth_brute.log`.
3. Create the script `/root/block-attackers.sh` to output the IPs to `/tmp/block_ips.txt` and iterate through them to run `iptables -A INPUT -s $ip -j DROP`.
4. Run the script `/root/block-attackers.sh` and verify the results via `iptables -L`.
5. Exit the container and run `u-lab check 11-logaudit` to verify.
