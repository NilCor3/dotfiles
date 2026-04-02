#!/bin/bash
# aerospace.sh — workspace pill highlight plugin
# Called with $1 = workspace id; FOCUSED_WORKSPACE env var set by AeroSpace

WS="$1"
FOCUSED="$FOCUSED_WORKSPACE"

# Check if workspace has any windows
HAS_WINDOWS=false
if aerospace list-windows --workspace "$WS" 2>/dev/null | grep -q .; then
  HAS_WINDOWS=true
fi

if [ "$WS" = "$FOCUSED" ]; then
  # Active workspace: gold pill, dark text
  sketchybar --set "space.$WS" \
    background.drawing=on \
    background.color=0xffd79921 \
    icon.color=0xff1d2021 \
    label.color=0xff3c3836
elif [ "$HAS_WINDOWS" = true ]; then
  # Has windows but not focused: dim pill
  sketchybar --set "space.$WS" \
    background.drawing=on \
    background.color=0x663c3836 \
    icon.color=0xffd4be98 \
    label.color=0xffa89984
else
  # Empty workspace: no background, faint text
  sketchybar --set "space.$WS" \
    background.drawing=off \
    icon.color=0xff665c54 \
    label.color=0xff504945
fi
