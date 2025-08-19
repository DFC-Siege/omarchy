#!/bin/bash

SCRIPT_NAME="Discord Installer"
DOWNLOAD_URL="https://discord.com/api/download?platform=linux&format=deb"
TEMP_DIR="/tmp"
DEB_FILE="$TEMP_DIR/discord.deb"

echo "[$SCRIPT_NAME] Starting Discord installation..."

if ! command -v curl &>/dev/null; then
  echo "[$SCRIPT_NAME] Error: curl is required but not installed."
  echo "[$SCRIPT_NAME] Please install curl: sudo apt install curl"
  exit 1
fi

echo "[$SCRIPT_NAME] Downloading Discord..."
curl -L -o "$DEB_FILE" "$DOWNLOAD_URL"

if [ ! -f "$DEB_FILE" ]; then
  echo "[$SCRIPT_NAME] Error: Failed to download Discord"
  exit 1
fi

echo "[$SCRIPT_NAME] Installing Discord..."
sudo dpkg -i "$DEB_FILE"

if [ $? -ne 0 ]; then
  echo "[$SCRIPT_NAME] Installing missing dependencies..."
  sudo apt-get install -f -y
fi

echo "[$SCRIPT_NAME] Cleaning up..."
rm -f "$DEB_FILE"

echo "[$SCRIPT_NAME] Discord installation completed successfully!"
echo "[$SCRIPT_NAME] You can now launch Discord from your application menu or run 'discord' in terminal."
