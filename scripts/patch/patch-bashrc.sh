#!/bin/bash

if ! grep -q "source ~/.config/shell/bashrc" ~/.bashrc; then
  echo "" >>~/.bashrc
  echo "# Source custom configuration" >>~/.bashrc
  echo "source ~/.config/shell/bashrc" >>~/.bashrc
fi
