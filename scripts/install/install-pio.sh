#!/bin/bash
set -e

SCRIPT_NAME="platformio-core Installer"
PACKAGE_NAME="platformio-core"

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

# Add user to uucp group for serial port access
echo "[$SCRIPT_NAME] Adding user to uucp group for serial port access..."
if groups "$USER" | grep -q "\buucp\b"; then
        echo "[$SCRIPT_NAME] User $USER is already in the uucp group."
else
        sudo usermod -a -G uucp "$USER"
        if [ $? -eq 0 ]; then
                echo "[$SCRIPT_NAME] User $USER has been added to the uucp group."
                echo "[$SCRIPT_NAME] You need to log out and back in (or restart) for the group change to take effect."
        else
                echo "[$SCRIPT_NAME] Warning: Failed to add user to uucp group. You may need to do this manually:"
                echo "[$SCRIPT_NAME]   sudo usermod -a -G uucp $USER"
        fi
fi

echo "[$SCRIPT_NAME] Setup completed!"
echo "[$SCRIPT_NAME] Remember to log out and back in if you were added to the uucp group."
