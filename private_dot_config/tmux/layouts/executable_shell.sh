#!/bin/sh
# shell.sh — single shell layout
# Usage: shell.sh <session-name> <cwd>

SESSION="$1"
CWD="${2:-$HOME}"

if [ -z "$SESSION" ]; then
  echo "Usage: shell.sh <session-name> [cwd]" >&2
  exit 1
fi

COLS=$(tmux display-message -p '#{client_width}')
ROWS=$(tmux display-message -p '#{client_height}')
tmux new-session -d -s "$SESSION" -n "shell" -c "$CWD" -x "$COLS" -y "$ROWS"
tmux select-pane -t "$SESSION:shell.1" -T "shell"
