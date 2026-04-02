#!/bin/bash
# media.sh — now playing via nowplaying-cli

STATUS=$(nowplaying-cli get playbackRate 2>/dev/null)

if [ "$STATUS" = "1" ]; then
  TITLE=$(nowplaying-cli get title 2>/dev/null)
  ARTIST=$(nowplaying-cli get artist 2>/dev/null)
  if [ -n "$TITLE" ]; then
    if [ -n "$ARTIST" ]; then
      LABEL="$ARTIST — $TITLE"
    else
      LABEL="$TITLE"
    fi
    # Truncate to 40 chars
    if [ "${#LABEL}" -gt 40 ]; then
      LABEL="${LABEL:0:37}…"
    fi
    sketchybar --set media drawing=on label="$LABEL"
  else
    sketchybar --set media drawing=off
  fi
else
  sketchybar --set media drawing=off
fi
