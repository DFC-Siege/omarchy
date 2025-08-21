#!/bin/bash

set -e

echo "Checking for existing Node.js installation..."

if mise ls node 2>/dev/null | grep -q node; then
        echo "Node.js is already installed via mise:"
        mise ls node
        echo "Current version: $(node --version 2>/dev/null || echo 'None active')"
        read -p "Do you want to install the latest version anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Skipping installation."
                exit 0
        fi
fi

echo "Installing latest Node.js with mise..."

mise install node@latest
mise use -g node@latest

echo "Node.js installation complete!"
eval "$(mise env -s bash)"
echo "Version: $(node --version)"
echo "npm version: $(npm --version)"
