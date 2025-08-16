#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
INSTALL_SCRIPTS_DIR="$CONFIG_DIR/scripts" # Directory for install scripts

# Add source line to actual ~/.bashrc
if ! grep -q "source ~/.config/shell/bashrc" ~/.bashrc; then
  echo "" >>~/.bashrc
  echo "# Source custom configuration" >>~/.bashrc
  echo "source ~/.config/shell/bashrc" >>~/.bashrc
fi

# Run custom scripts in ~/.config/scripts
if [ -d "$INSTALL_SCRIPTS_DIR" ]; then
  echo "Running custom scripts from $INSTALL_SCRIPTS_DIR..."
  for script in "$INSTALL_SCRIPTS_DIR"/*; do
    # Skip if it's the current script or not a file
    if [ -f "$script" ] && [ "$(basename "$script")" != "install.sh" ]; then
      echo "  Executing: $(basename "$script")"
      bash "$script"
    fi
  done
else
  echo "No custom scripts directory found at $INSTALL_SCRIPTS_DIR."
fi

echo "Dotfiles installed!"
