#!/bin/bash

cache_file="/tmp/waybar-weather-cache"
location="zaltbommel"

weather=$(curl -sf "wttr.in/${location}?format=%c%t")

if [[ $? -eq 0 && -n "$weather" ]]; then
        echo "$weather" >"$cache_file"
else
        if [[ -f "$cache_file" ]]; then
                weather=$(cat "$cache_file")
        else
                weather="N/A"
        fi
fi

echo "{\"text\":\"$weather\", \"tooltip\":\"Weather in $location\"}"
