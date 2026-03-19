#!/bin/sh
# Open a file in the Helix pane that launched lazygit.
# Called by lazygit's os.edit command.
#
# Usage: hx-remote-open.sh <filename> [line]
#
# When lazygit is opened from Helix via hx-lazygit.sh, the env var
# HELIX_PANE is set to the tmux pane ID of the Helix instance.
# This script sends :open to that pane instead of spawning a new editor.

FILE="$1"
LINE="${2:-1}"

if [ -z "$FILE" ]; then
  exit 1
fi

if [ -n "$HELIX_PANE" ] && [ -n "$TMUX" ]; then
  tmux send-keys -t "$HELIX_PANE" ":open ${FILE}:${LINE}" Enter
else
  # Fallback: open a new Helix instance
  hx "${FILE}:${LINE}"
fi
