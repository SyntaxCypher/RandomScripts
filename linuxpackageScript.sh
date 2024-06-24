#!/bin/bash

# store the list of user packages
user_installed_packages_file="user_installed_packages.txt"

# log packages
log_packages() {
    local title="$1"
    shift
    local packages=("$@")
    
    echo "### $title ###" >> "$user_installed_packages_file"
    for pkg in "${packages[@]}"; do
        echo "$pkg" >> "$user_installed_packages_file"
    done
    echo "" >> "$user_installed_packages_file"
}

# check dpkg
if [ -f /var/log/dpkg.log ] || ls /var/log/dpkg.log.* &>/dev/null; then
    dpkg_packages=$(grep " install " /var/log/dpkg.log* | awk '{print $4}' | sort | uniq)
    log_packages "dpkg Packages" "${dpkg_packages[@]}"
fi

# Check snap 
if command -v snap &> /dev/null; then
    snap_packages=$(snap list | awk 'NR>1 {print $1}')
    log_packages "snap Packages" "${snap_packages[@]}"
fi

# Check flatpak 
if command -v flatpak &> /dev/null; then
    flatpak_packages=$(flatpak list --app | awk '{print $1}')
    log_packages "flatpak Packages" "${flatpak_packages[@]}"
fi

# Check /usr/local
local_packages=$(find /usr/local -type f -executable 2>/dev/null | sort | uniq)
if [ -n "$local_packages" ]; then
    log_packages "Manually Installed Software in /usr/local" "${local_packages[@]}"
fi

# Check /opt
opt_packages=$(find /opt -type f -executable 2>/dev/null | sort | uniq)
if [ -n "$opt_packages" ]; then
    log_packages "Manually Installed Software in /opt" "${opt_packages[@]}"
fi

echo "List of packages installed by the user:"
cat "$user_installed_packages_file"