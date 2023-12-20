#!/bin/bash
sudo umount /home/git/YOUR_PATH_HERE
sudo cryptsetup luksClose YOUR_VOLUME_NAME_HERE
echo CodeStore has been successfully unmounted and closed. Device Encrypted...
