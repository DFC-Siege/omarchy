#!/bin/bash
if tailscale status &>/dev/null; then
  echo '{"class":"connected","tooltip":"Tailscale Connected"}'
else
  echo '{"class":"disconnected","tooltip":"Tailscale Disconnected"}'
fi
