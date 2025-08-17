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

    awk '
        /^\[colors\.primary\]/ { section="primary"; next }
        /^\[colors\.normal\]/ { section="normal"; next }
        /^\[colors\.bright\]/ { section="bright"; next }
        /^\[colors\.selection\]/ { section="selection"; next }
        /^\[/ { section=""; next }
        
        section == "primary" && /background/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "background " $0 
        }
        section == "primary" && /foreground/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "foreground " $0 
        }
        
        section == "selection" && /background/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "selection_background " $0 
        }
        section == "selection" && /foreground/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "selection_foreground " $0 
        }
        
        section == "normal" && /black/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color0 " $0 
        }
        section == "normal" && /red/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color1 " $0 
        }
        section == "normal" && /green/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color2 " $0 
        }
        section == "normal" && /yellow/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color3 " $0 
        }
        section == "normal" && /blue/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color4 " $0 
        }
        section == "normal" && /magenta/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color5 " $0 
        }
        section == "normal" && /cyan/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color6 " $0 
        }
        section == "normal" && /white/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color7 " $0 
        }
        
        section == "bright" && /black/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color8 " $0 
        }
        section == "bright" && /red/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color9 " $0 
        }
        section == "bright" && /green/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color10 " $0 
        }
        section == "bright" && /yellow/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color11 " $0 
        }
        section == "bright" && /blue/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color12 " $0 
        }
        section == "bright" && /magenta/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color13 " $0 
        }
        section == "bright" && /cyan/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color14 " $0 
        }
        section == "bright" && /white/ { 
            gsub(/.*= ./, ""); gsub(/.$/, ""); print "color15 " $0 
        }
        ' "$alacritty_file"

    echo ""
    echo "cursor \$(grep '^foreground' \"$kitty_file\" | awk '{print \$2}' 2>/dev/null || echo '#ffffff')"
    echo "cursor_text_color \$(grep '^background' \"$kitty_file\" | awk '{print \$2}' 2>/dev/null || echo '#000000')"
    echo ""
    echo "url_color \$(grep '^color4' \"$kitty_file\" | awk '{print \$2}' 2>/dev/null || echo '#0000ff')"
    echo ""
    echo "active_border_color \$(grep '^color4' \"$kitty_file\" | awk '{print \$2}' 2>/dev/null || echo '#0000ff')"
    echo "inactive_border_color \$(grep '^color0' \"$kitty_file\" | awk '{print \$2}' 2>/dev/null || echo '#000000')"

  } >"$kitty_file"

  sed -i 's/\$(grep[^)]*)//' "$kitty_file"

  bg_color=$(grep '^background' "$kitty_file" | awk '{print $2}')
  fg_color=$(grep '^foreground' "$kitty_file" | awk '{print $2}')
  blue_color=$(grep '^color4' "$kitty_file" | awk '{print $2}')
  black_color=$(grep '^color0' "$kitty_file" | awk '{print $2}')

  {
    echo ""
    echo "cursor ${fg_color:-#ffffff}"
    echo "cursor_text_color ${bg_color:-#000000}"
    echo ""
    echo "url_color ${blue_color:-#0000ff}"
    echo ""
    echo "active_border_color ${blue_color:-#0000ff}"
    echo "inactive_border_color ${black_color:-#000000}"
    echo ""
    echo "active_tab_background ${blue_color:-#0000ff}"
    echo "active_tab_foreground ${bg_color:-#000000}"
    echo "inactive_tab_background ${black_color:-#000000}"
    echo "inactive_tab_foreground ${fg_color:-#ffffff}"
  } >>"$kitty_file"
}

find "$THEMES_DIR" -name "alacritty.toml" -type f | while read -r alacritty_file; do
  convert_alacritty_to_kitty "$alacritty_file"
done

echo "Conversion complete!"

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
