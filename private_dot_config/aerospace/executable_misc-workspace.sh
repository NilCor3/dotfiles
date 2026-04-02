#!/bin/bash
# Route newly opened windows to the misc workspace for their monitor.
# Called from on-window-detected catch-all in aerospace.toml.
#
# AeroSpace monitor IDs (from 'aerospace list-monitors'):
#   1 = P24h-2L (2)          → left monitor  → workspace 8 (misc)
#   2 = P24h-2L (1)          → main monitor  → workspace 5 (misc)
#   3 = Built-in Retina      → laptop        → workspace 9

MONITOR=$(aerospace list-monitors --focused 2>/dev/null | awk 'NR==1{print $1}')

case "$MONITOR" in
  1) aerospace move-node-to-workspace 8 ;;
  2) aerospace move-node-to-workspace 5 ;;
  3) aerospace move-node-to-workspace 9 ;;
esac
