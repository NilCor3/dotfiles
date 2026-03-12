#!/bin/sh
# shell.sh — single shell layout
# Usage: shell.sh <session-name> <cwd>

SESSION="$1"
CWD="${2:-$HOME}"

if [ -z "$SESSION" ]; then
  echo "Usage: shell.sh <session-name> [cwd]" >&2
  exit 1
fi

COLS=$(tmux display-message -p '#{client_width}' 2>/dev/null)
ROWS=$(tmux display-message -p '#{client_height}' 2>/dev/null)
COLS=${COLS:-$(tput cols 2>/dev/null || echo 220)}
ROWS=${ROWS:-$(tput lines 2>/dev/null || echo 50)}tmux new-session -d -s "$SESSION" -n "shell" -c "$CWD" -x "$COLS" -y "$ROWS"
tmux select-pane -t "$SESSION:shell.1" -T "shell"
