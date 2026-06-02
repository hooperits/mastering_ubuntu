# 🚀 Lab 04: Storage & LVM Partitioning

## Scenario Context
You are adding storage expansion to an active server. Because block device allocation inside Docker containers is kernel-locked for host OS safety, you will perform **simulative script validation** for the disk partitioning and Logical Volume setup, and **real configuration** for filesystem mounting (`/etc/fstab`) and swapfile expansion.

Your objectives will prepare you for partitioning, creating Logical Volumes, securing reboots on dynamic filesystems, and expanding system swap memory.

---

## 🎯 Lab Objectives

### 1. Write the LVM Setup Script
Write a bash script at `/root/lvm-setup.sh` that documents the correct step-by-step partition and volume creations for a new secondary disk `/dev/sdb`:
- **Physical Volume**: Create a physical volume on the disk `/dev/sdb`.
- **Volume Group**: Create a volume group named `vg_data` incorporating `/dev/sdb`.
- **Logical Volume**: Create a logical volume named `lv_storage` inside `vg_data`.
- **Format Filesystem**: Format the logical volume path `/dev/vg_data/lv_storage` as `ext4`.

### 2. Configure Persistent Mount in `/etc/fstab`
Configure `/etc/fstab` to persistently mount a mock secondary drive mapping UUID `fe382b90-1c39-4d82-89b2-38d73b22b100` to the directory `/mnt/data`:
- Filesystem: `ext4`
- Mount Options: Configure with `defaults` and the crucial `nofail` flag.
  *(The `nofail` flag is critical: it prevents the system from failing to boot or hanging if the mock block drive is absent during reboot)*

### 3. Configure Swap File Expansion
Create a swap file at the root `/swapfile`:
- Size: Exactly `256MB`. Use `dd` to copy bytes.
- Permissions: Lock down the file permissions to exactly `0600` (readable/writable only by root).
- Format: Format the file as swap space.
- Persistence: Add the correct swap mounting line to `/etc/fstab` to ensure it is configured automatically on boot.
  *(Do not run `swapon` inside the container, as it is blocked by Docker namespaces. The check will verify the file properties and the fstab configuration).*

---

## 🔍 Disk & Swap Command Reference

### Swap File Creation Flow:
1. **Allocate the swapfile** (256 Blocks of 1MB = 256MB):
   ```bash
   dd if=/dev/zero of=/swapfile bs=1M count=256
   ```
2. **Restrict access permissions**:
   ```bash
   chmod 600 /swapfile
   ```
3. **Format as swap filesystem**:
   ```bash
   mkswap /swapfile
   ```
4. **Append entry to `/etc/fstab`**:
   ```text
   /swapfile none swap sw 0 0
   ```

### LVM Setup Script structure example (`/root/lvm-setup.sh`):
```bash
#!/bin/bash
pvcreate /dev/sdb
vgcreate vg_data /dev/sdb
lvcreate -n lv_storage -l 100%FREE vg_data
mkfs.ext4 /dev/vg_data/lv_storage
```

---

## 💡 How to Complete
1. Use `u-lab attach 04-storage` to enter the container.
2. Create `/root/lvm-setup.sh` containing the correct setup shell commands.
3. Write the 256MB `/swapfile`, set permissions to `600`, and format with `mkswap`.
4. Edit `/etc/fstab` to append:
   - The `/swapfile` mounting directive.
   - The mount mapping line for UUID `fe382b90-1c39-4d82-89b2-38d73b22b100` to `/mnt/data` with options `defaults,nofail`.
5. Exit the container and run `u-lab check 04-storage` to verify.
