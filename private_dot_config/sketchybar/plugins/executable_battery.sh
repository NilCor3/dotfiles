#!/bin/bash
# battery.sh — battery level and charging state

BATT_INFO=$(pmset -g batt)
PERCENT=$(echo "$BATT_INFO" | grep -oE '[0-9]+%' | head -1 | tr -d '%')
CHARGING=$(echo "$BATT_INFO" | grep -c 'charging;' || true)

[ -z "$PERCENT" ] && { sketchybar --set battery drawing=off; exit 0; }

if [ "$CHARGING" -gt 0 ]; then
  ICON="󰂄"  # charging
  COLOR=0xffa9b665
elif [ "$PERCENT" -le 10 ]; then
  ICON="󰁺"
  COLOR=0xffea6962  # red
elif [ "$PERCENT" -le 20 ]; then
  ICON="󰁻"
  COLOR=0xffe78a4e  # orange
elif [ "$PERCENT" -le 50 ]; then
  ICON="󰁾"
  COLOR=0xffd8a657  # yellow
else
  ICON="󰁹"
  COLOR=0xffa9b665  # green
fi

sketchybar --set battery drawing=on icon="$ICON" icon.color=$COLOR label="${PERCENT}%"
