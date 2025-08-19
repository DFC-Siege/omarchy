#!/bin/bash

set -e

SCRIPT_NAME="todo Installer"
PACKAGE_NAME="todo"
REPO_URL="https://github.com/DFC-Siege/todo.git"

echo "[$SCRIPT_NAME] Starting $PACKAGE_NAME installation..."

if ! command -v cargo &>/dev/null; then
  echo "[$SCRIPT_NAME] Error: cargo is required but not installed."
  echo "[$SCRIPT_NAME] Please install the Rust toolchain first."
  exit 1
fi

echo "[$SCRIPT_NAME] Installing $PACKAGE_NAME from Git repository..."
cargo install --git "$REPO_URL"

if [ $? -ne 0 ]; then
  echo "[$SCRIPT_NAME] Error: Failed to install $PACKAGE_NAME"
  exit 1
fi

echo "[$SCRIPT_NAME] $PACKAGE_NAME installation completed successfully!"
