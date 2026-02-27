#!/bin/bash

lat=51.81
lon=5.25
cache_file="/tmp/waybar-weather-cache"

weather_json=$(curl -sf "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code&timezone=auto")

if [[ $? -eq 0 && -n "$weather_json" ]]; then
        temp=$(echo "$weather_json" | jq -r '.current.temperature_2m | round')
        code=$(echo "$weather_json" | jq -r '.current.weather_code')

        case $code in
        0) icon="☀️" ;;
        1) icon="🌤️" ;;
        2) icon="⛅" ;;
        3) icon="☁️" ;;
        45 | 48) icon="🌫️" ;;
        51 | 53 | 55) icon="🌦️" ;;
        56 | 57) icon="❄️💧" ;;
        61) icon="💧" ;;
        63) icon="🌧️" ;;
        65) icon="🌊" ;;
        66 | 67) icon="🧊" ;;
        71) icon="🌨️" ;;
        73) icon="❄️" ;;
        75) icon="🏔️" ;;
        77) icon="🍚" ;;
        80 | 81 | 82) icon="☔" ;;
        85 | 86) icon="⛄" ;;
        95) icon="⚡" ;;
        96 | 99) icon="⛈️" ;;
        *) icon="❓" ;;
        esac

        weather="$icon ${temp}°C"
        echo "$weather" >"$cache_file"
else
        if [[ -f "$cache_file" ]]; then
                weather=$(cat "$cache_file")
        else
                weather="N/A"
        fi
fi

echo "{\"text\":\"$weather\", \"tooltip\":\"Weather in Zaltbommel\"}"
