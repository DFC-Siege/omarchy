#!/bin/bash

set -e

echo "Checking for re2c dependency..."
if ! command -v re2c &>/dev/null; then
        echo "re2c not found. Installing re2c..."
        sudo pacman -S re2c
else
        echo "re2c found: $(re2c --version | head -1)"
fi

echo "Checking for PHP build dependencies..."
DEPS=(gd libxml2 openssl curl zlib readline gettext libjpeg-turbo libpng freetype2 libzip oniguruma sqlite)
MISSING_DEPS=()

for dep in "${DEPS[@]}"; do
        if ! pacman -Qi "$dep" &>/dev/null; then
                MISSING_DEPS+=("$dep")
        fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
        echo "Installing missing dependencies: ${MISSING_DEPS[*]}"
        sudo pacman -S "${MISSING_DEPS[@]}"
else
        echo "All PHP build dependencies are installed."
fi

echo "Checking for existing PHP installation..."

if mise ls php 2>/dev/null | grep -q php; then
        echo "PHP is already installed via mise:"
        mise ls php
        echo "Current version: $(php --version 2>/dev/null | head -1 || echo 'None active')"
        read -p "Do you want to install the latest version anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Skipping installation."
                exit 0
        fi
fi

echo "Installing latest PHP with mise..."

mise install php@latest
mise use -g php@latest

echo "PHP installation complete!"
eval "$(mise env -s bash)"
echo "Version: $(php --version)"
