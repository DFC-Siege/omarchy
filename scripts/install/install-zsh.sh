#!/bin/bash
set -e

SCRIPT_NAME="zsh Installer"
PACKAGE_NAME="zsh"

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
fi

# Check if zsh is already the default shell
if [ "$SHELL" = "$(which zsh)" ]; then
        echo "[$SCRIPT_NAME] zsh is already the default shell."
else
        echo "[$SCRIPT_NAME] Setting zsh as the default shell..."
        # Verify zsh is in /etc/shells
        if ! grep -q "$(which zsh)" /etc/shells; then
                echo "[$SCRIPT_NAME] Adding zsh to /etc/shells..."
                echo "$(which zsh)" | sudo tee -a /etc/shells
        fi

        # Change default shell
        chsh -s "$(which zsh)"
        if [ $? -eq 0 ]; then
                echo "[$SCRIPT_NAME] Default shell changed to zsh. Please log out and log back in for changes to take effect."
        else
                echo "[$SCRIPT_NAME] Warning: Failed to change default shell. You may need to run 'chsh -s \$(which zsh)' manually."
        fi
fi

echo "[$SCRIPT_NAME] Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "[$SCRIPT_NAME] $PACKAGE_NAME installation completed successfully!"
echo "[$SCRIPT_NAME] Note: If the shell was changed, please log out and log back in to use zsh as your default shell."
