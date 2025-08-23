#!/bin/bash
set -e

SCRIPT_NAME="zsh Installer"
PACKAGE_NAME="zsh"

echo "[$SCRIPT_NAME] Starting $PACKAGE_NAME installation..."

# Check if pacman is available
if ! command -v pacman &>/dev/null; then
        echo "[$SCRIPT_NAME] Error: pacman is required but not installed."
        echo "[$SCRIPT_NAME] This script is for Arch-based systems only."
        exit 1
fi

# Install zsh if not already installed
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

# Install Oh My Zsh
echo "[$SCRIPT_NAME] Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
        # Use unattended installation to prevent interactive prompts
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
        echo "[$SCRIPT_NAME] Oh My Zsh is already installed."
fi

# Install zsh-autosuggestions plugin
echo "[$SCRIPT_NAME] Installing zsh-autosuggestions plugin..."
AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

if [ ! -d "$AUTOSUGGESTIONS_DIR" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
        echo "[$SCRIPT_NAME] zsh-autosuggestions plugin installed successfully."
else
        echo "[$SCRIPT_NAME] zsh-autosuggestions plugin is already installed."
fi

# Install zsh-syntax-highlighting plugin (bonus - provides command syntax highlighting)
echo "[$SCRIPT_NAME] Installing zsh-syntax-highlighting plugin..."
SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

if [ ! -d "$SYNTAX_HIGHLIGHTING_DIR" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$SYNTAX_HIGHLIGHTING_DIR"
        echo "[$SCRIPT_NAME] zsh-syntax-highlighting plugin installed successfully."
else
        echo "[$SCRIPT_NAME] zsh-syntax-highlighting plugin is already installed."
fi

# Configure .zshrc to enable plugins
echo "[$SCRIPT_NAME] Configuring .zshrc to enable plugins..."
ZSHRC_FILE="$HOME/.zshrc"

if [ -f "$ZSHRC_FILE" ]; then
        # Check if plugins line exists and update it
        if grep -q "^plugins=" "$ZSHRC_FILE"; then
                # Check if autosuggestions is already in plugins
                if ! grep -q "zsh-autosuggestions" "$ZSHRC_FILE"; then
                        # Add plugins to existing plugins line
                        sed -i 's/^plugins=(/plugins=(zsh-autosuggestions zsh-syntax-highlighting /' "$ZSHRC_FILE"
                        echo "[$SCRIPT_NAME] Added plugins to existing .zshrc configuration."
                else
                        echo "[$SCRIPT_NAME] Plugins are already configured in .zshrc."
                fi
        else
                # Add plugins line if it doesn't exist
                echo "" >>"$ZSHRC_FILE"
                echo "# Plugins" >>"$ZSHRC_FILE"
                echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >>"$ZSHRC_FILE"
                echo "[$SCRIPT_NAME] Added plugins configuration to .zshrc."
        fi
else
        echo "[$SCRIPT_NAME] Warning: .zshrc file not found. Plugins may need to be configured manually."
fi

echo "[$SCRIPT_NAME] $PACKAGE_NAME installation completed successfully!"
echo "[$SCRIPT_NAME] Installed features:"
echo "  - zsh shell"
echo "  - Oh My Zsh framework"
echo "  - zsh-autosuggestions (type hints based on history)"
echo "  - zsh-syntax-highlighting (command syntax highlighting)"
echo ""
echo "[$SCRIPT_NAME] Note: Please log out and log back in (or run 'exec zsh') to start using zsh with all features."
echo "[$SCRIPT_NAME] Auto-suggestions will appear in gray as you type. Press → (right arrow) to accept them."
