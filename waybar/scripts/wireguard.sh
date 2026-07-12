#!/bin/bash

ifaces=$(ip -o link show type wireguard 2>/dev/null | awk -F': ' '{print $2}')

if [ -n "$ifaces" ]; then
  names=$(echo "$ifaces" | paste -sd ', ')
  echo "{\"text\":\"󰖂\",\"class\":\"connected\",\"tooltip\":\"WireGuard connected: $names\"}"
else
  echo '{"text":"󰖂","class":"disconnected","tooltip":"WireGuard disconnected"}'
fi
