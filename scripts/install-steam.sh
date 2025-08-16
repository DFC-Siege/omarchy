#!/bin/bash

set -e

SCRIPT_NAME="Steam Installer"
PACKAGE_NAME="steam"

echo "[$SCRIPT_NAME] Starting $PACKAGE_NAME installation..."

if ! command -v pacman &>/dev/null; then
  echo "[$SCRIPT_NAME] Error: pacman is required but not installed."
  echo "[$SCRIPT_NAME] This script is for Arch-based systems only."
  exit 1
fi

if pacman -Q "$PACKAGE_NAME" &>/dev/null; then
  echo "[$SCRIPT_NAME] $PACKAGE_NAME is already installed."
  exit 0
fi

# Check if multilib repository is enabled
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
  echo "[$SCRIPT_NAME] The 'multilib' repository is not enabled."
  echo "[$SCRIPT_NAME] Please uncomment the 'multilib' section in /etc/pacman.conf and run this script again."
  exit 1
fi

echo "[$SCRIPT_NAME] Installing $PACKAGE_NAME..."
sudo pacman -S --noconfirm "$PACKAGE_NAME"

if [ $? -ne 0 ]; then
  echo "[$SCRIPT_NAME] Error: Failed to install $PACKAGE_NAME."
  exit 1
fi

echo "[$SCRIPT_NAME] $PACKAGE_NAME installation completed successfully!"
