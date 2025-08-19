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

KITTY_RELOAD_CODE='
# Trigger kitty config reload
if pgrep kitty > /dev/null; then
    kill -SIGUSR1 $(pgrep kitty)
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

if grep -q "starship.toml" "$SCRIPT_PATH" && grep -q "pgrep kitty" "$SCRIPT_PATH"; then
  echo "Starship and Kitty reload code already present in $SCRIPT_PATH"
  exit 0
fi

if ! grep -q "$MARKER_LINE" "$SCRIPT_PATH"; then
  echo "Error: Could not find marker line '$MARKER_LINE' in $SCRIPT_PATH"
  echo "The script may have been modified or this is an incompatible version"
  exit 1
fi

echo "Backing up original script to ${SCRIPT_PATH}.backup"
cp "$SCRIPT_PATH" "${SCRIPT_PATH}.backup" 2>/dev/null || sudo cp "$SCRIPT_PATH" "${SCRIPT_PATH}.backup"

awk_script='
  { print }
  /alacritty config reload/ {
    print ""
    print "# Update starship config symlink"
    print "if [[ -f ~/.config/omarchy/current/theme/starship.toml ]]; then"
    print "    ln -sf ~/.config/omarchy/current/theme/starship.toml ~/.config/starship.toml"
    print "fi"
    print ""
    print "# Trigger kitty config reload"
    print "if pgrep kitty > /dev/null; then"
    print "    kill -SIGUSR1 $(pgrep kitty)"
    print "fi"
  }
'

if [[ ! -w "$SCRIPT_PATH" ]]; then
  echo "Need sudo privileges to modify $SCRIPT_PATH"
  awk "$awk_script" "$SCRIPT_PATH" | sudo tee "${SCRIPT_PATH}.tmp" >/dev/null
  sudo mv "${SCRIPT_PATH}.tmp" "$SCRIPT_PATH"
  sudo chmod +x "$SCRIPT_PATH"
else
  awk "$awk_script" "$SCRIPT_PATH" >"${SCRIPT_PATH}.tmp"
  mv "${SCRIPT_PATH}.tmp" "$SCRIPT_PATH"
  chmod +x "$SCRIPT_PATH"
fi

echo "Successfully patched omarchy-theme-set to reload starship and kitty configs"
echo "Backup saved as ${SCRIPT_PATH}.backup"
