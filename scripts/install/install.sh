#!/bin/bash

set -e
cd "$(dirname "$0")" || exit 1

echo "Installing all programs"

for script in ./*; do
        if [ -f "$script" ] && [ "$(basename "$script")" != "install.sh" ]; then
                echo "  Executing: $(basename "$script")"
                sh "$script"
        fi
done

echo "Installations done"
