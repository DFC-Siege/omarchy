#!/bin/bash

THEMES_DIR="$HOME/.config/omarchy/themes"

if [ ! -d "$THEMES_DIR" ]; then
  echo "Error: $THEMES_DIR not found"
  exit 1
fi

convert_alacritty_to_kitty() {
  local alacritty_file="$1"
  local kitty_file="${alacritty_file%/*}/kitty.conf"

  echo "Converting $alacritty_file -> $kitty_file"

  {
    echo "# Generated from alacritty.toml"
    echo ""

    # Awk script to extract and reformat colors
    awk '
      function format_color(hex_str) {
          # Remove leading "0x" or "#" or quotes
          gsub(/["'\'' ]/, "", hex_str)
          sub(/^0x/, "", hex_str)
          sub(/^#/, "", hex_str)
          return "#" hex_str
      }

      function extract_value(line) {
          match(line, /= *["'\'' ]*([^"'\'' ]+)/, arr)
          value = arr[1]
          # Skip non-hex values like "CellForeground"
          if (value ~ /^(#|0x)?[0-9a-fA-F]{6}$/) {
              return format_color(value)
          } else {
              return ""  # Skip invalid values
          }
      }

      /^\[colors\.primary\]/ { section = "primary"; next }
      /^\[colors\.normal\]/  { section = "normal"; next }
      /^\[colors\.bright\]/  { section = "bright"; next }
      /^\[colors\.cursor\]/  { section = "cursor"; next }
      /^\[colors\.selection\]/ { section = "selection"; next }
      /^\[/ { section = ""; next }

      section == "primary" && /background/ {
          print "background " extract_value($0)
      }
      section == "primary" && /foreground/ {
          print "foreground " extract_value($0)
      }

      section == "selection" && /background/ {
          print "selection_background " extract_value($0)
      }
      section == "selection" && /text/ {
          print "selection_foreground " extract_value($0)
      }

      section == "cursor" && /text/ {
          print "cursor_text_color " extract_value($0)
      }
      section == "cursor" && /cursor/ {
          print "cursor " extract_value($0)
      }

      section == "normal" && /black/   { print "color0 "  extract_value($0) }
      section == "normal" && /red/     { print "color1 "  extract_value($0) }
      section == "normal" && /green/   { print "color2 "  extract_value($0) }
      section == "normal" && /yellow/  { print "color3 "  extract_value($0) }
      section == "normal" && /blue/    { print "color4 "  extract_value($0) }
      section == "normal" && /magenta/ { print "color5 "  extract_value($0) }
      section == "normal" && /cyan/    { print "color6 "  extract_value($0) }
      section == "normal" && /white/   { print "color7 "  extract_value($0) }

      section == "bright" && /black/   { print "color8 "  extract_value($0) }
      section == "bright" && /red/     { print "color9 "  extract_value($0) }
      section == "bright" && /green/   { print "color10 " extract_value($0) }
      section == "bright" && /yellow/  { print "color11 " extract_value($0) }
      section == "bright" && /blue/    { print "color12 " extract_value($0) }
      section == "bright" && /magenta/ { print "color13 " extract_value($0) }
      section == "bright" && /cyan/    { print "color14 " extract_value($0) }
      section == "bright" && /white/   { print "color15 " extract_value($0) }
    ' "$alacritty_file"

  } >"$kitty_file"

  # Extract fallback color values
  bg_color=$(grep '^background' "$kitty_file" | awk '{print $2}' || echo '#000000')
  fg_color=$(grep '^foreground' "$kitty_file" | awk '{print $2}' || echo '#ffffff')
  blue_color=$(grep '^color4' "$kitty_file" | awk '{print $2}' || echo '#0000ff')
  black_color=$(grep '^color0' "$kitty_file" | awk '{print $2}' || echo '#3c3836')

  {
    echo ""
    echo "cursor ${fg_color}"
    echo "cursor_text_color ${bg_color}"
    echo ""
    echo "url_color ${blue_color}"
    echo ""
    echo "active_border_color ${blue_color}"
    echo "inactive_border_color ${black_color}"
    echo ""
    echo "active_tab_background ${blue_color}"
    echo "active_tab_foreground ${bg_color}"
    echo "inactive_tab_background ${black_color}"
    echo "inactive_tab_foreground ${fg_color}"
    echo "confirm_os_window_close 0"
    echo "window_padding_width 8 8 8 8"
  } >>"$kitty_file"
}

# Convert all alacritty.toml files found
find "$THEMES_DIR" -name "alacritty.toml" -type f | while read -r alacritty_file; do
  convert_alacritty_to_kitty "$alacritty_file"
done

echo "Conversion complete!"

# Set up symlink for the current theme
CURRENT_THEME_KITTY="$HOME/.config/omarchy/current/theme/kitty.conf"
KITTY_CONFIG_DIR="$HOME/.config/kitty"
KITTY_CONFIG="$KITTY_CONFIG_DIR/kitty.conf"

if [ -f "$CURRENT_THEME_KITTY" ]; then
  mkdir -p "$KITTY_CONFIG_DIR"

  if [ -L "$KITTY_CONFIG" ] || [ -f "$KITTY_CONFIG" ]; then
    rm "$KITTY_CONFIG"
  fi

  ln -s "$CURRENT_THEME_KITTY" "$KITTY_CONFIG"
  echo "Created symlink: $KITTY_CONFIG -> $CURRENT_THEME_KITTY"
else
  echo "Warning: $CURRENT_THEME_KITTY not found. Make sure you have a current theme set."
fi
