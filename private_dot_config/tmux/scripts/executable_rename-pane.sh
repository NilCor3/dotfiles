#!/bin/sh
# rename-pane.sh — set or clear a static pane title via fzf
# Usage: rename-pane.sh <pane_id>
# Stores the name in @user_title pane option (shown in pane-border-format).
# Selecting nothing or pressing Escape clears the pin → dynamic naming resumes.

PANE_ID="$1"

PRESETS="shell
tests
git
server
logs
docker"

output=$(printf '%s\n' "$PRESETS" | fzf \
  --prompt='pane name> ' \
  --print-query \
  --height=40% \
  --border=rounded \
  --info=hidden 2>/dev/null)
rc=$?

name=$(printf '%s' "$output" | tail -1)

if [ $rc -eq 0 ] && [ -n "$name" ]; then
  tmux select-pane -t "$PANE_ID" -T "$name"
  tmux set-option -p -t "$PANE_ID" @user_title "$name"
else
  # Clear static name → fall back to dynamic display
  tmux set-option -up -t "$PANE_ID" @user_title
fi
