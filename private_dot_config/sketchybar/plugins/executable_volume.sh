#!/bin/bash
# volume.sh — system output volume

VOL=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
MUTED=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)

if [ "$MUTED" = "true" ] || [ "${VOL:-0}" -eq 0 ]; then
  ICON="󰖁"
  COLOR=0xffa89984
elif [ "${VOL:-100}" -le 30 ]; then
  ICON="󰕿"
  COLOR=0xffd4be98
elif [ "${VOL:-100}" -le 65 ]; then
  ICON="󰖀"
  COLOR=0xffd4be98
else
  ICON="󰕾"
  COLOR=0xffd4be98
fi

sketchybar --set volume icon="$ICON" icon.color=$COLOR label="${VOL}%"
