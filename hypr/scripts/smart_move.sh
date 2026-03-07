#!/bin/bash

DIR=$1
case $DIR in
    l) MON="l" ;; r) MON="r" ;; u) MON="u" ;; d) MON="d" ;;
esac

ACTIVE=$(hyprctl activewindow -j)
ADDR=$(echo "$ACTIVE" | jq -r '.address')
CUR_W=$(echo "$ACTIVE" | jq -r '.size[0]')
CUR_H=$(echo "$ACTIVE" | jq -r '.size[1]')

# Peek at the neighbor
hyprctl dispatch movefocus "$DIR" > /dev/null
NEXT=$(hyprctl activewindow -j)
NEXT_ADDR=$(echo "$NEXT" | jq -r '.address')
NEXT_W=$(echo "$NEXT" | jq -r '.size[0]')
NEXT_H=$(echo "$NEXT" | jq -r '.size[1]')

# 1. Monitor Jump (Edge Detection)
if [ "$ADDR" == "$NEXT_ADDR" ]; then
    hyprctl dispatch movewindow "mon:$MON"
    exit 0
fi

# 2. Logic: Swap or Nest?
# We check if the windows are 'siblings' (same size) or in different branches.
IS_SWAP=false
if [[ "$DIR" == "l" || "$DIR" == "r" ]]; then
    [ "$CUR_H" -eq "$NEXT_H" ] && IS_SWAP=true
else
    [ "$CUR_W" -eq "$NEXT_W" ] && IS_SWAP=true
fi

if [ "$IS_SWAP" = true ]; then
    # Return to start and swap content only
    hyprctl dispatch focuswindow "address:$ADDR" > /dev/null
    hyprctl dispatch swapwindow "$DIR"
else
    # 3. The Structural Move (with Preselection)
    # We are already focused on the 'target' window from the peek.
    # Tell the target: 'The next window lands on my [DIR] side'
    hyprctl dispatch layoutmsg "preselect $DIR"
    
    # Go back to our window and move it into that preselected slot
    hyprctl dispatch focuswindow "address:$ADDR" > /dev/null
    hyprctl dispatch movewindow "$DIR"
fi
