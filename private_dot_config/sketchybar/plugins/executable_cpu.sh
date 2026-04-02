#!/bin/bash
# cpu.sh — CPU usage percentage

CPU_DATA=$(top -l 1 -s 0 -n 0 | grep "^CPU usage")
IDLE=$(echo "$CPU_DATA" | grep -oE '[0-9]+\.[0-9]+% idle' | grep -oE '[0-9]+\.[0-9]+')

if [ -n "$IDLE" ]; then
  CPU=$(echo "100 - $IDLE" | bc | awk '{printf "%.0f", $1}')
else
  CPU="?"
fi

COLOR=0xffa9b665  # green default
if [ "${CPU:-0}" -gt 80 ] 2>/dev/null; then
  COLOR=0xffea6962  # red
elif [ "${CPU:-0}" -gt 50 ] 2>/dev/null; then
  COLOR=0xffe78a4e  # orange
fi

sketchybar --set cpu label="${CPU}%" icon.color=$COLOR
