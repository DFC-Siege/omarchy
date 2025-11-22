#!/bin/bash

direction=$1

active_window=$(hyprctl activewindow -j)
initial_pos=$(echo "$active_window" | jq -r '.at')
monitor_id=$(echo "$active_window" | jq -r '.monitor')
initial_address=$(echo "$active_window" | jq -r '.address')

hyprctl dispatch movewindow "$direction"

sleep 0.01

active_window=$(hyprctl activewindow -j)
new_pos=$(echo "$active_window" | jq -r '.at')
new_monitor_id=$(echo "$active_window" | jq -r '.monitor')

if [ "$monitor_id" != "$new_monitor_id" ] || [ "$initial_pos" != "$new_pos" ]; then
    exit 0
fi

all_windows=$(hyprctl clients -j)
current_monitor_windows=$(echo "$all_windows" | jq --arg mon "$monitor_id" '[.[] | select(.monitor == ($mon | tonumber))]')

window_count=$(echo "$current_monitor_windows" | jq 'length')

if [ "$window_count" -le 1 ]; then
    exit 0
fi

hyprctl dispatch swapwindow "$direction"

sleep 0.05

active_window=$(hyprctl activewindow -j)
new_monitor_after_swap=$(echo "$active_window" | jq -r '.monitor')

if [ "$monitor_id" != "$new_monitor_after_swap" ]; then
    hyprctl dispatch swapwindow "$direction"
fi
