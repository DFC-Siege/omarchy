#!/bin/bash

location="zaltbommel"

weather=$(curl -s "wttr.in/${location}?format=%c%t")

if [ $? -eq 0 ] && [ -n "$weather" ]; then
    echo "{\"text\":\"$weather\", \"tooltip\":\"Weather in $location\"}"
else
    echo "{\"text\":\"\", \"tooltip\":\"Weather unavailable\"}"
fi
