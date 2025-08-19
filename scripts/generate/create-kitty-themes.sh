#!/bin/bash

THEMES_DIR="$HOME/.local/share/omarchy/themes"

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
      # Function to format a raw hex color string (e.g., "0xRRGGBB" or "#RRGGBB")
      # into the "#RRGGBB" format required by Kitty.
      function format_color(hex_str) {
          # Remove leading "0x" if present
          if (substr(hex_str, 1, 2) == "0x") {
              hex_str = substr(hex_str, 3)
          }
          # Ensure the string starts with "#"
          if (substr(hex_str, 1, 1) != "#") {
              return "#" hex_str
          }
          return hex_str
      }

      # Function to extract the quoted color value from a line and format it
      function get_and_format_quoted_color(line) {
          # Use match to find the content inside quotes
          match(line, /"([^"]+)"/, arr)
          # arr[1] contains the string inside the quotes, pass it to format_color
          return format_color(arr[1])
      }

      # Set section variables based on Alacritty TOML headers
      /^\[colors\.primary\]/ { section="primary"; next }
      /^\[colors\.normal\]/ { section="normal"; next }
      /^\[colors\.bright\]/ { section="bright"; next }
      /^\[colors\.selection\]/ { section="selection"; next }
      /^\[colors\.cursor\]/ { section="cursor"; next }
      /^\[/ { section=""; next } # Reset section for other headers

      # Process colors based on the current section
      section == "primary" && /background/ {
          print "background " get_and_format_quoted_color($0)
      }
      section == "primary" && /foreground/ {
          print "foreground " get_and_format_quoted_color($0)
      }

      section == "selection" && /background/ {
          print "selection_background " get_and_format_quoted_color($0)
      }
      section == "selection" && /text/ { # Alacritty "text" in selection maps to Kitty "selection_foreground"
          print "selection_foreground " get_and_format_quoted_color($0)
      }

      section == "cursor" && /text/ {
          print "cursor_text_color " get_and_format_quoted_color($0)
      }
      section == "cursor" && /cursor/ {
          print "cursor " get_and_format_quoted_color($0)
      }
      
      # Process normal (color0-color7) palette
      section == "normal" && /black/ { print "color0 " get_and_format_quoted_color($0) }
      section == "normal" && /red/ { print "color1 " get_and_format_quoted_color($0) }
      section == "normal" && /green/ { print "color2 " get_and_format_quoted_color($0) }
      section == "normal" && /yellow/ { print "color3 " get_and_format_quoted_color($0) }
      section == "normal" && /blue/ { print "color4 " get_and_format_quoted_color($0) }
      section == "normal" && /magenta/ { print "color5 " get_and_format_quoted_color($0) }
      section == "normal" && /cyan/ { print "color6 " get_and_format_quoted_color($0) }
      section == "normal" && /white/ { print "color7 " get_and_format_quoted_color($0) }

      # Process bright (color8-color15) palette
      section == "bright" && /black/ { print "color8 " get_and_format_quoted_color($0) }
      section == "bright" && /red/ { print "color9 " get_and_format_quoted_color($0) }
      section == "bright" && /green/ { print "color10 " get_and_format_quoted_color($0) }
      section == "bright" && /yellow/ { print "color11 " get_and_format_quoted_color($0) }
      section == "bright" && /blue/ { print "color12 " get_and_format_quoted_color($0) }
      section == "bright" && /magenta/ { print "color13 " get_and_format_quoted_color($0) }
      section == "bright" && /cyan/ { print "color14 " get_and_format_quoted_color($0) }
      section == "bright" && /white/ { print "color15 " get_and_format_quoted_color($0) }
    ' "$alacritty_file"

  } >"$kitty_file"

  # Read the correctly formatted colors from the newly generated kitty_file
  # and append the remaining Kitty-specific configurations.
  # Using default values if a color is not found in the file.
  bg_color=$(grep '^background' "$kitty_file" | awk '{print $2}' || echo '#000000')
  fg_color=$(grep '^foreground' "$kitty_file" | awk '{print $2}' || echo '#ffffff')
  blue_color=$(grep '^color4' "$kitty_file" | awk '{print $2}' || echo '#0000ff')
  black_color=$(grep '^color0' "$kitty_file" | awk '{print $2}' || echo '#3c3836') # Using a more specific default

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
  } >>"$kitty_file"
}

# Find all alacritty.toml files and convert them
find "$THEMES_DIR" -name "alacritty.toml" -type f | while read -r alacritty_file; do
  convert_alacritty_to_kitty "$alacritty_file"
done

echo "Conversion complete!"

# Set up symlink for the current Kitty theme
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
