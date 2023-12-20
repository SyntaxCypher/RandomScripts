#!/bin/bash

encrypted_device="/dev/sda1"
decrypted_device="/dev/mapper/YOUR_VOL_NAME_HERE"
mount_point="YOUR_PATH_HERE"

# Check if the mount point is already mounted
if grep -qs "$mount_point" /proc/mounts; then
    echo "The device is already mounted at $mount_point."
else
    # Open the encrypted partition
    sudo cryptsetup luksOpen "$encrypted_device" VOL_NAME_HERE

    # Mount the decrypted partition
    sudo mount "$decrypted_device" "$mount_point"
    echo "Encrypted partition has been successfully mounted to $mount_point."
fi
