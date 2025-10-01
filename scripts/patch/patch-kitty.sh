#!/bin/bash

config_file="$HOME/.local/share/omarchy/config/kitty/kitty.conf"
include_line="include ~/.config/kitty/custom.conf"

if [ ! -f "$config_file" ]; then
        echo "Error: $config_file does not exist"
        exit 1
fi

if grep -Fxq "$include_line" "$config_file"; then
        echo "Include already exists in $config_file"
        exit 0
fi

echo "$include_line" >>"$config_file"
echo "Successfully added include to $config_file"
