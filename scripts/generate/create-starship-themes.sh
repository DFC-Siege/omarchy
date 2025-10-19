#!/bin/bash
THEMES_DIR="$HOME/.config/omarchy/themes"

extract_color() {
  local file="$1"
  local color_key="$2"
  grep "^${color_key}[[:space:]]" "$file" | awk '{print $2}' | head -n1
}

generate_starship_config() {
  local theme_dir="$1"
  local kitty_file="$theme_dir/kitty.conf"
  local starship_file="$theme_dir/starship.toml"
  
  if [[ ! -f "$kitty_file" ]]; then
    echo "Warning: $kitty_file not found, skipping..."
    return
  fi
  
  local black=$(extract_color "$kitty_file" "color0")
  local red=$(extract_color "$kitty_file" "color1")
  local green=$(extract_color "$kitty_file" "color2")
  local yellow=$(extract_color "$kitty_file" "color3")
  local blue=$(extract_color "$kitty_file" "color4")
  local magenta=$(extract_color "$kitty_file" "color5")
  local cyan=$(extract_color "$kitty_file" "color6")
  local white=$(extract_color "$kitty_file" "color7")
  
  local bright_black=$(extract_color "$kitty_file" "color8")
  local bright_red=$(extract_color "$kitty_file" "color9")
  local bright_green=$(extract_color "$kitty_file" "color10")
  local bright_yellow=$(extract_color "$kitty_file" "color11")
  local bright_blue=$(extract_color "$kitty_file" "color12")
  local bright_magenta=$(extract_color "$kitty_file" "color13")
  local bright_cyan=$(extract_color "$kitty_file" "color14")
  local bright_white=$(extract_color "$kitty_file" "color15")
  
  local foreground=$(extract_color "$kitty_file" "foreground")
  local background=$(extract_color "$kitty_file" "background")
  
  cat >"$starship_file" <<EOF
format = """
[](fg:${yellow})\
\$username\
[](bg:${blue} fg:${yellow})\
\$directory\
[](fg:${blue} bg:${red})\
\$git_branch\
\$git_status\
[](fg:${red} bg:${magenta})\
\$time\
[ ](fg:${magenta})\
"""

[username]
show_always = true
style_user = "bg:${yellow}"
style_root = "bg:${yellow}"
format = '[\$user ](bg:${yellow} fg:${black})'
disabled = false

[directory]
style = "bg:${blue}"
format = "[ \$path ](bg:${blue} fg:${black})"
truncation_length = 3
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[git_branch]
symbol = ""
style = "bg:${red}"
format = '[[ \$symbol \$branch ](bg:${red} fg:${black})](\$style)'

[git_status]
style = "bg:${red}"
format = '[[(\$all_status\$ahead_behind )](bg:${red} fg:${black})](\$style)'

[time]
disabled = false
time_format = "%R"
style = "bg:${magenta}"
format = '[[  \$time ](bg:${magenta} fg:${black})](\$style)'

[line_break]
disabled = false

[character]
disabled = false
success_symbol = '[](bold fg:${green})'
error_symbol = '[](bold fg:${red})'
vimcmd_symbol = '[](bold fg:${green})'
vimcmd_replace_one_symbol = '[](bold fg:${bright_magenta})'
vimcmd_replace_symbol = '[](bold fg:${bright_magenta})'
vimcmd_visual_symbol = '[](bold fg:${yellow})'
EOF
  
  echo "Generated starship config for $(basename "$theme_dir")"
}

if [[ ! -d "$THEMES_DIR" ]]; then
  echo "Error: Themes directory $THEMES_DIR does not exist"
  exit 1
fi

for theme_dir in "$THEMES_DIR"/*; do
  if [[ -d "$theme_dir" ]]; then
    generate_starship_config "$theme_dir"
  fi
done

echo "Starship theme generation complete!"
