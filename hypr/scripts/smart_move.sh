#!/bin/bash

DIR=$1
case $DIR in
    l) MON="l" ;;
    r) MON="r" ;;
    u) MON="u" ;;
    d) MON="d" ;;
esac

ACTIVE=$(hyprctl activewindow -j)
ADDR=$(echo "$ACTIVE" | jq -r '.address')
CUR_W=$(echo "$ACTIVE" | jq -r '.size[0]')
CUR_H=$(echo "$ACTIVE" | jq -r '.size[1]')

hyprctl dispatch movefocus "$DIR" > /dev/null
NEXT=$(hyprctl activewindow -j)
NEXT_ADDR=$(echo "$NEXT" | jq -r '.address')
NEXT_W=$(echo "$NEXT" | jq -r '.size[0]')
NEXT_H=$(echo "$NEXT" | jq -r '.size[1]')

if [ "$ADDR" == "$NEXT_ADDR" ]; then
    hyprctl dispatch movewindow "mon:$MON"
else
    hyprctl dispatch focuswindow "address:$ADDR" > /dev/null
    
    if [[ "$DIR" == "l" || "$DIR" == "r" ]]; then
        if [ "$CUR_H" -ne "$NEXT_H" ]; then
            hyprctl dispatch movewindow "$DIR"
        else
            hyprctl dispatch swapwindow "$DIR"
        fi
    else
        if [ "$CUR_W" -ne "$NEXT_W" ]; then
            hyprctl dispatch movewindow "$DIR"
        else
            hyprctl dispatch swapwindow "$DIR"
        fi
    fi
fi
