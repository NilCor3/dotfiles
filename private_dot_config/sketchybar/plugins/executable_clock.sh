#!/bin/bash
# clock.sh — date and time display
DATE=$(date '+%a %-d %b  %H:%M')
sketchybar --set clock label="$DATE"
