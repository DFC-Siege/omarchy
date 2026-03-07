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
CUR_CX=$(( $(echo "$ACTIVE" | jq -r '.at[0]') + CUR_W / 2 ))
CUR_CY=$(( $(echo "$ACTIVE" | jq -r '.at[1]') + CUR_H / 2 ))

hyprctl dispatch movefocus "$DIR" > /dev/null

NEXT=$(hyprctl activewindow -j)
NEXT_ADDR=$(echo "$NEXT" | jq -r '.address')
NEXT_W=$(echo "$NEXT" | jq -r '.size[0]')
NEXT_H=$(echo "$NEXT" | jq -r '.size[1]')
NEXT_CX=$(( $(echo "$NEXT" | jq -r '.at[0]') + NEXT_W / 2 ))
NEXT_CY=$(( $(echo "$NEXT" | jq -r '.at[1]') + NEXT_H / 2 ))

WIN_COUNT=$(hyprctl clients -j | jq '[.[] | select(.workspace.id == '"$(hyprctl activewindow -j | jq '.workspace.id')"')] | length')

MON_INFO=$(hyprctl monitors -j | jq '.[] | select(.focused == true)')
MON_X=$(echo "$MON_INFO" | jq -r '.x')
MON_Y=$(echo "$MON_INFO" | jq -r '.y')
MON_W=$(echo "$MON_INFO" | jq -r '.width')
MON_H=$(echo "$MON_INFO" | jq -r '.height')

NEXT_AT_EDGE=false
case $DIR in
        l) [ "$NEXT_CX" -le "$MON_X" ] && NEXT_AT_EDGE=true ;;
        r) [ $(( NEXT_CX + NEXT_W )) -ge $(( MON_X + MON_W )) ] && NEXT_AT_EDGE=true ;;
        u) [ "$NEXT_CY" -le "$MON_Y" ] && NEXT_AT_EDGE=true ;;
        d) [ $(( NEXT_CY + NEXT_H )) -ge $(( MON_Y + MON_H )) ] && NEXT_AT_EDGE=true ;;
esac

log "$NEXT_CX, $NEXT_W, $MON_W"

hyprctl dispatch focuswindow "address:$ADDR" > /dev/null

if [ "$ADDR" == "$NEXT_ADDR" ]; then
        log "No neighbor — moving to monitor $MON"
        hyprctl dispatch movewindow "mon:$MON"
elif [[ "$DIR" == "l" || "$DIR" == "r" ]] && [ "$CUR_H" -ne "$NEXT_H" ]; then
        log "Different heights (${CUR_H} vs ${NEXT_H}) — moving $DIR"
        hyprctl dispatch movewindow "$DIR"
        if [[ "$DIR" == "r" ]] && [ "$CUR_CY" -gt "$NEXT_CY" ]; then
                log "moving down"
                hyprctl dispatch movewindow "d"
        fi
        if [[ "$DIR" == "l" ]] && [ "$CUR_CY" -lt "$NEXT_CY" ]; then
                log "moving up"
                hyprctl dispatch movewindow "u"
        fi
elif [[ "$DIR" == "u" || "$DIR" == "d" ]] && [ "$CUR_W" -ne "$NEXT_W" ]; then
        log "Different widths (${CUR_W} vs ${NEXT_W}) — moving $DIR"
        hyprctl dispatch movewindow "$DIR"
        if [[ "$DIR" == "u" ]] && [ "$CUR_CX" -lt "$NEXT_CX" ]; then
                log "moving left"
                hyprctl dispatch movewindow "l"
        fi
        if [[ "$DIR" == "d" ]] && [ "$CUR_CX" -gt "$NEXT_CX" ]; then
                log "moving right"
                hyprctl dispatch movewindow "r"
        fi
else
        log "swapwindow $DIR"
        hyprctl dispatch swapwindow "$DIR"
fi
