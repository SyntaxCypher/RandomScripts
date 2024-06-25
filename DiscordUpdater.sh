#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Function to get the current installed version of Discord
get_current_version() {
  dpkg-query -W -f='${Version}' discord 2>/dev/null || echo "none"
}

# Function to calculate progress bar width
calculate_progress_bar() {
  local width=$(tput cols)
  local max_width=$((width - 20))  # Adjusting for text and percentage
  local progress=$1
  local total=$2
  local percent=$((progress * 100 / total))
  local bar_length=$((progress * max_width / total))
  printf "["
  printf "%-${bar_length}s" "#" | tr ' ' '#'
  printf "%$((max_width - bar_length))s"
  printf "] %d%%" "$percent"
}

# Variables
DISCORD_URL="https://discord.com/api/download?platform=linux&format=deb"
DOWNLOAD_FILE="/tmp/discord-latest.deb"

# Download the latest version of Discord with a progress bar
echo "Downloading Discord and comparing versions..."
curl -L --progress-bar -o "$DOWNLOAD_FILE" "$DISCORD_URL" 2>&1 | tr '\r' '\n' | tail -n 1
echo

# Check if download was successful
if [ $? -ne 0 ]; then
  echo "Download failed. Please check your internet connection or try again later."
  exit 1
fi

# Extract the version number from the downloaded file name
LATEST_VERSION=$(basename $(curl -Ls -o /dev/null -w "%{url_effective}" "$DISCORD_URL") | grep -oP '[0-9]+(\.[0-9]+)+')

# Get the current installed version
CURRENT_VERSION=$(get_current_version)

# Check if Discord is up to date
if [ "$LATEST_VERSION" == "$CURRENT_VERSION" ]; then
  echo "Discord is up to date, downloaded package not installed..."
  rm "$DOWNLOAD_FILE"
  exit 0
fi

# Install the downloaded package, suppressing normal output
echo -n "Installing Discord... "
if dpkg -i "$DOWNLOAD_FILE" >/dev/null 2>&1; then
  echo "Discord has been updated to version $LATEST_VERSION"
else
  echo "Error installing Discord. Please install manually."
  exit 1
fi

# Clean up
rm "$DOWNLOAD_FILE"
