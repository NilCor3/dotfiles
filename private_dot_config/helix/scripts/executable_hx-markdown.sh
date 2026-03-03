#!/bin/sh
# Preview markdown file using glow in a floating pane.
# Keybinding: Space+,+m in Helix config.toml

file="$1"

if [ -n "$ZELLIJ" ]; then
  zellij action new-pane --floating --close-on-exit --name "preview" \
    -- glow "$file"
elif [ -n "$TMUX" ]; then
  tmux display-popup -E -w 80% -h 80% -b rounded -s "fg=#d79921" glow "$file"
elif [ -n "$WEZTERM_PANE" ]; then
  wezterm cli split-pane --bottom --percent 40 -- glow "$file"
else
  glow "$file"
fi
