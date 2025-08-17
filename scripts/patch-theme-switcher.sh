#!/bin/bash

OMARCHY_SCRIPT_LOCATIONS=(
  "/usr/local/bin/omarchy-theme-set"
  "/usr/bin/omarchy-theme-set"
  "$HOME/.local/bin/omarchy-theme-set"
  "$(which omarchy-theme-set 2>/dev/null)"
)

STARSHIP_RELOAD_CODE='
# Update starship config symlink
if [[ -f ~/.config/omarchy/current/theme/starship.toml ]]; then
    ln -sf ~/.config/omarchy/current/theme/starship.toml ~/.config/starship.toml
fi'

MARKER_LINE="# Trigger alacritty config reload"

find_omarchy_script() {
  for location in "${OMARCHY_SCRIPT_LOCATIONS[@]}"; do
    if [[ -f "$location" && -x "$location" ]]; then
      echo "$location"
      return 0
    fi
  done
  return 1
}

SCRIPT_PATH=$(find_omarchy_script)
if [[ -z "$SCRIPT_PATH" ]]; then
  echo "Error: omarchy-theme-set script not found in common locations"
  echo "Please specify the path manually or ensure omarchy is installed"
  exit 1
fi

echo "Found omarchy-theme-set at: $SCRIPT_PATH"

if grep -q "starship.toml" "$SCRIPT_PATH"; then
  echo "Starship reload code already present in $SCRIPT_PATH"
  exit 0
fi

if ! grep -q "$MARKER_LINE" "$SCRIPT_PATH"; then
  echo "Error: Could not find marker line '$MARKER_LINE' in $SCRIPT_PATH"
  echo "The script may have been modified or this is an incompatible version"
  exit 1
fi

echo "Backing up original script to ${SCRIPT_PATH}.backup"
cp "$SCRIPT_PATH" "${SCRIPT_PATH}.backup" 2>/dev/null || sudo cp "$SCRIPT_PATH" "${SCRIPT_PATH}.backup"

if [[ ! -w "$SCRIPT_PATH" ]]; then
  echo "Need sudo privileges to modify $SCRIPT_PATH"

  awk -v starship_code="$STARSHIP_RELOAD_CODE" '
    /# Trigger alacritty config reload/ {
      print $0
      getline
      print $0
      print starship_code
      next
    }
    { print }
  ' "$SCRIPT_PATH" | sudo tee "${SCRIPT_PATH}.tmp" >/dev/null

  sudo mv "${SCRIPT_PATH}.tmp" "$SCRIPT_PATH"
  sudo chmod +x "$SCRIPT_PATH"
else
  awk -v starship_code="$STARSHIP_RELOAD_CODE" '
    /# Trigger alacritty config reload/ {
      print $0
      getline  
      print $0
      print starship_code
      next
    }
    { print }
  ' "$SCRIPT_PATH" >"${SCRIPT_PATH}.tmp"

  mv "${SCRIPT_PATH}.tmp" "$SCRIPT_PATH"
  chmod +x "$SCRIPT_PATH"
fi

echo "Successfully patched omarchy-theme-set to reload starship configs"
echo "Backup saved as ${SCRIPT_PATH}.backup"
