#!/bin/bash
set -e
SCRIPT_NAME="openssh Installer"
PACKAGE_NAME="openssh"
SERVICE_NAME="sshd"

echo "[$SCRIPT_NAME] Starting $PACKAGE_NAME installation..."

if ! command -v pacman &>/dev/null; then
        echo "[$SCRIPT_NAME] Error: pacman is required but not installed."
        echo "[$SCRIPT_NAME] This script is for Arch-based systems only."
        exit 1
fi

if pacman -Q "$PACKAGE_NAME" &>/dev/null; then
        echo "[$SCRIPT_NAME] $PACKAGE_NAME is already installed."
else
        echo "[$SCRIPT_NAME] Installing $PACKAGE_NAME..."
        sudo pacman -S --noconfirm "$PACKAGE_NAME"
        if [ $? -ne 0 ]; then
                echo "[$SCRIPT_NAME] Error: Failed to install $PACKAGE_NAME"
                exit 1
        fi
        echo "[$SCRIPT_NAME] $PACKAGE_NAME installation completed successfully!"
fi

if systemctl is-enabled "$SERVICE_NAME" &>/dev/null; then
        echo "[$SCRIPT_NAME] $SERVICE_NAME is already enabled."
else
        echo "[$SCRIPT_NAME] Enabling and starting $SERVICE_NAME..."
        sudo systemctl enable --now "$SERVICE_NAME"
        echo "[$SCRIPT_NAME] $SERVICE_NAME enabled and started successfully!"
fi
