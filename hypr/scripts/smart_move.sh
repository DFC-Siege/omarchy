#!/bin/bash

LOG=/tmp/hypr-move.log
log() { echo "[$(date '+%H:%M:%S')] $*" >> "$LOG"; }

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
CUR_X=$(echo "$ACTIVE" | jq -r '.at[0]')
CUR_Y=$(echo "$ACTIVE" | jq -r '.at[1]')
CUR_CX=$(( CUR_X + CUR_W / 2 ))
CUR_CY=$(( CUR_Y + CUR_H / 2 ))
CUR_MON=$(echo "$ACTIVE" | jq -r '.monitor')

hyprctl dispatch movefocus "$DIR" > /dev/null

NEXT=$(hyprctl activewindow -j)
NEXT_ADDR=$(echo "$NEXT" | jq -r '.address')
NEXT_W=$(echo "$NEXT" | jq -r '.size[0]')
NEXT_H=$(echo "$NEXT" | jq -r '.size[1]')
NEXT_CX=$(( $(echo "$NEXT" | jq -r '.at[0]') + NEXT_W / 2 ))
NEXT_CY=$(( $(echo "$NEXT" | jq -r '.at[1]') + NEXT_H / 2 ))
NEXT_MON=$(echo "$NEXT" | jq -r '.monitor')

hyprctl dispatch focuswindow "address:$ADDR" > /dev/null

if [ "$CUR_MON" != "$NEXT_MON" ]; then
    log "Different monitors — moving $DIR"
    hyprctl dispatch movewindow "$DIR"
elif [[ "$DIR" == "l" || "$DIR" == "r" ]] && [ "$CUR_H" -ne "$NEXT_H" ]; then
    log "Different heights (${CUR_H} vs ${NEXT_H}) — moving $DIR"
    hyprctl dispatch movewindow "$DIR"
    [[ "$DIR" == "r" ]] && [ "$CUR_CY" -gt "$NEXT_CY" ] && { log "moving down"; hyprctl dispatch movewindow "d"; }
    [[ "$DIR" == "l" ]] && [ "$CUR_CY" -lt "$NEXT_CY" ] && { log "moving up";   hyprctl dispatch movewindow "u"; }
elif [[ "$DIR" == "u" || "$DIR" == "d" ]] && [ "$CUR_W" -ne "$NEXT_W" ]; then
    log "Different widths (${CUR_W} vs ${NEXT_W}) — moving $DIR"
    hyprctl dispatch movewindow "$DIR"
    [[ "$DIR" == "u" ]] && [ "$CUR_CX" -lt "$NEXT_CX" ] && { log "moving left";  hyprctl dispatch movewindow "l"; }
    [[ "$DIR" == "d" ]] && [ "$CUR_CX" -gt "$NEXT_CX" ] && { log "moving right"; hyprctl dispatch movewindow "r"; }
else
    hyprctl dispatch movewindow "$DIR"
    MOVED=$(hyprctl activewindow -j)
    NEW_X=$(echo "$MOVED" | jq -r '.at[0]')
    NEW_Y=$(echo "$MOVED" | jq -r '.at[1]')
    if [ "$NEW_X" == "$CUR_X" ] && [ "$NEW_Y" == "$CUR_Y" ]; then
        log "move failed — swapping $DIR"
        hyprctl dispatch swapwindow "$DIR"
    fi
fi
