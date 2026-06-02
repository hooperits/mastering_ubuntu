# 🚀 Lab 02: Network & Firewall Engineering

## Scenario Context
You have been tasked with securing and configuring the network parameters of a newly provisioned staging server. Currently, the firewall is completely open to all incoming connections, there are no local host mappings, and the network card profile relies on DHCP.

You need to harden the firewall policies, configure the Netplan static configuration file, and setup local domain name maps.

---

## 🎯 Lab Objectives

### 1. Configure Netplan Static IP Profile
Edit `/etc/netplan/50-cloud-init.yaml` to represent a static network configuration:
- IP Address: `192.168.1.100` (Subnet mask `/24`)
- Gateway (Routes via): `192.168.1.1`
- DNS Nameservers: `8.8.8.8` and `8.8.4.4`
- DHCP4: Disabled (`false` or `no`)
- *Note: Since Docker manages container interfaces, you do NOT need to run `netplan apply`. The verification script will parse and validate the YAML file itself.*

### 2. Hardening Ingress Rules with UFW
Harden the server firewall policies:
- Default Incoming: Set default incoming traffic policy to **DENY**.
- Default Outgoing: Set default outgoing traffic policy to **ALLOW**.
- SSH Access (Port 22): Allow SSH incoming connections **only** from the subnet `192.168.1.0/24`.
- HTTP Access (Port 80): Allow HTTP incoming traffic from **anywhere**.
- Database Port (Port 3306): Explicitly **deny** database connections from anywhere.
- Enable the firewall.

### 3. Setup Local Domain Maps
Configure local name resolution so services can communicate:
- Map local name `labyrinth-db.local` to resolve to `127.0.0.1` in `/etc/hosts`.
- Map local name `labyrinth-web.local` to resolve to `127.0.0.1` in `/etc/hosts`.

---

## 🔍 Netplan & UFW Guide Reference

### Netplan static format template example:
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: false
      addresses:
        - 192.168.1.100/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```
*(Make sure to use correct spaces indentation in Netplan config!)*

### UFW Rules commands:
* **Set defaults**:
  ```bash
  ufw default deny incoming
  ufw default allow outgoing
  ```
* **Allow SSH from subnet**:
  ```bash
  ufw allow from 192.168.1.0/24 to any port 22 proto tcp
  ```
* **Allow HTTP**:
  ```bash
  ufw allow 80/tcp
  ```
* **Block Database Port**:
  ```bash
  ufw deny 3306/tcp
  ```
* **Activate UFW**:
  ```bash
  ufw enable
  ```

---

## 💡 How to Complete
1. Use `u-lab attach 02-network` to enter the container.
2. Edit `/etc/netplan/50-cloud-init.yaml`.
3. Configure UFW rules and run `ufw enable`.
4. Append mapping rules to `/etc/hosts`.
5. Exit the container and run `u-lab check 02-network` to audit.
