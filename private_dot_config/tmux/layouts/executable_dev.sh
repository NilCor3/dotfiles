#!/bin/sh
# dev.sh — vertical monitor layout
# Usage: dev.sh <session-name> <cwd>
# Top 70%: helix; Bottom 30%: two shells side by side

SESSION="$1"
CWD="${2:-$HOME}"

if [ -z "$SESSION" ]; then
  echo "Usage: dev.sh <session-name> [cwd]" >&2
  exit 1
fi

# Create session with first window named "dev"
tmux new-session -d -s "$SESSION" -n "dev" -c "$CWD"

# Top pane already exists (pane 1) — start helix
tmux send-keys -t "$SESSION:dev.1" "hx ." Enter

# Split bottom 30% for first shell
tmux split-window -t "$SESSION:dev.1" -v -p 30 -c "$CWD"

# Split right for second shell
tmux split-window -t "$SESSION:dev.2" -h -c "$CWD"

# Focus back on helix pane
tmux select-pane -t "$SESSION:dev.1"
