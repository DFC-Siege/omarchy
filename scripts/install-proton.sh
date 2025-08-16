#!/bin/bash

set -e

SCRIPT_NAME="Proton Installer"
PACKAGE_MAIL="proton-mail-bin"
PACKAGE_PASS="proton-pass-bin"

echo "[$SCRIPT_NAME] Starting Proton applications installation..."

if ! command -v yay &>/dev/null; then
  echo "[$SCRIPT_NAME] Error: yay is required but not installed."
  echo "[$SCRIPT_NAME] This script is for Arch-based systems with yay only."
  exit 1
fi

echo "[$SCRIPT_NAME] Installing $PACKAGE_MAIL and $PACKAGE_PASS..."
yay -S --noconfirm "$PACKAGE_MAIL" "$PACKAGE_PASS"

if [ $? -ne 0 ]; then
  echo "[$SCRIPT_NAME] Error: Failed to install one or more packages."
  exit 1
fi

echo "[$SCRIPT_NAME] Proton applications installation completed successfully!"
