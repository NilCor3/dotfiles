#!/bin/bash
# keyboard.sh — current keyboard layout short code

LAYOUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist \
  AppleCurrentKeyboardLayoutInputSourceID 2>/dev/null \
  | awk -F'.' '{print $NF}' \
  | tr '[:lower:]' '[:upper:]' \
  | cut -c1-2)

[ -z "$LAYOUT" ] && LAYOUT="EN"

sketchybar --set keyboard label="$LAYOUT"
