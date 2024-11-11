#!/bin/bash

# Identify the Disk: First, ensure you know the disk you want to mount. You can find it using lsblk or fdisk -l.
# Create a Mount Point: Decide the directory where you want to mount the disk.
# Update /etc/fstab: Automate the mounting by adding an entry in /etc/fstab.
# To run use: sudo ./automount.sh
# Replace /dev/sdX1 with your actual disk or partition.
# Ensure the filesystem type (ext4) matches your disk’s format.
# This script assumes ext4; adjust if your disk uses a different filesystem, like xfs or ntfs.

# Define variables
DISK="/dev/sdX1"  # Replace with your actual disk/partition
MOUNT_POINT="/mnt/mydisk"  # Replace with your desired mount point

# Ensure the disk exists
if [ ! -b "$DISK" ]; then
  echo "Error: Disk $DISK not found."
  exit 1
fi

# Create the mount point if it doesn't exist
if [ ! -d "$MOUNT_POINT" ]; then
  echo "Creating mount point: $MOUNT_POINT"
  sudo mkdir -p "$MOUNT_POINT"
fi

# Get the UUID of the disk
UUID=$(sudo blkid -s UUID -o value "$DISK")

if [ -z "$UUID" ]; then
  echo "Error: Unable to fetch UUID for $DISK."
  exit 1
fi

# Backup fstab
echo "Backing up /etc/fstab to /etc/fstab.bak"
sudo cp /etc/fstab /etc/fstab.bak

# Add entry to /etc/fstab if not already present
if ! grep -qs "$UUID" /etc/fstab; then
  echo "Adding $DISK to /etc/fstab"
  echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 2" | sudo tee -a /etc/fstab
else
  echo "Disk $DISK is already in /etc/fstab"
fi

# Mount the disk immediately
echo "Mounting $DISK to $MOUNT_POINT"
sudo mount -a

# Verify mount
if mountpoint -q "$MOUNT_POINT"; then
  echo "Disk successfully mounted at $MOUNT_POINT"
else
  echo "Error: Failed to mount disk."
fi
How to Use the Script:
Save the script as automount.sh.
Make it executable:
bash
Copy code
chmod +x automount.sh

