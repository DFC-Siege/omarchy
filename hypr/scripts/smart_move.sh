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
CUR_Y=$(echo "$ACTIVE" | jq -r '.at[1]')
CUR_CY=$(( CUR_Y + CUR_H / 2 ))

log "Active window: addr=$ADDR size=${CUR_W}x${CUR_H} center_y=${CUR_CY}"

hyprctl dispatch movefocus "$DIR" > /dev/null
NEXT=$(hyprctl activewindow -j)
NEXT_ADDR=$(echo "$NEXT" | jq -r '.address')
NEXT_W=$(echo "$NEXT" | jq -r '.size[0]')
NEXT_H=$(echo "$NEXT" | jq -r '.size[1]')

log "Next window:   addr=$NEXT_ADDR size=${NEXT_W}x${NEXT_H}"

MON_INFO=$(hyprctl monitors -j | jq '.[] | select(.focused == true)')
MON_H=$(echo "$MON_INFO" | jq -r '.height')
MON_Y=$(echo "$MON_INFO" | jq -r '.y')
MON_CY=$(( MON_Y + MON_H / 2 ))

log "Monitor center_y=${MON_CY}"

if [ "$ADDR" == "$NEXT_ADDR" ]; then
    log "No neighbor found — moving window to monitor: $MON"
    hyprctl dispatch movewindow "mon:$MON"
else
    hyprctl dispatch focuswindow "address:$ADDR" > /dev/null

    if [[ "$DIR" == "l" || "$DIR" == "r" ]]; then
        if [ "$CUR_H" -ne "$NEXT_H" ]; then
            log "Different heights (${CUR_H} vs ${NEXT_H}) — moving window $DIR"
            hyprctl dispatch movewindow "$DIR"
            if [ "$CUR_CY" -gt "$MON_CY" ]; then
                log "Window center (${CUR_CY}) is below screen center (${MON_CY}) — also moving down"
                hyprctl dispatch movewindow "d"
            elif [ "$CUR_CY" -lt "$MON_CY" ]; then
                log "Window center (${CUR_CY}) is above screen center (${MON_CY}) — also moving up"
                hyprctl dispatch movewindow "u"
            fi
        else
            log "Same height — swapping window $DIR"
            hyprctl dispatch swapwindow "$DIR"
        fi
    else
        if [ "$CUR_W" -ne "$NEXT_W" ]; then
            log "Different widths (${CUR_W} vs ${NEXT_W}) — moving window $DIR"
            hyprctl dispatch movewindow "$DIR"
        else
            log "Same width — swapping window $DIR"
            hyprctl dispatch swapwindow "$DIR"
        fi
    fi
fi
