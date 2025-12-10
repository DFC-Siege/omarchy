#!/bin/bash

set -e

SCRIPT_NAME="noto-fonts-cjk Installer"
PACKAGE_NAME="noto-fonts-cjk"

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

echo "[$SCRIPT_NAME] Installing $PACKAGE_NAME..."
sudo pacman -S --noconfirm "$PACKAGE_NAME"

if [ $? -ne 0 ]; then
        echo "[$SCRIPT_NAME] Error: Failed to install $PACKAGE_NAME"
        exit 1
fi

echo "[$SCRIPT_NAME] $PACKAGE_NAME installation completed successfully!"
