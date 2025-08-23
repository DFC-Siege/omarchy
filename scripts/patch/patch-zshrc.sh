#!/bin/bash

if ! grep -q "source ~/.config/shell/zshrc" ~/.zshrc; then
        echo "" >>~/.zshrc
        echo "# Source custom configuration" >>~/.zshrc
        echo "source ~/.config/shell/zshrc" >>~/.zshrc
fi
