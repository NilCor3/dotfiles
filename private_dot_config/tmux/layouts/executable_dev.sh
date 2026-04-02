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

# Create session using actual terminal dimensions so splits stay proportional
COLS=$(tmux display-message -p '#{client_width}' 2>/dev/null)
ROWS=$(tmux display-message -p '#{client_height}' 2>/dev/null)
COLS=${COLS:-$(tput cols 2>/dev/null || echo 220)}
ROWS=${ROWS:-$(tput lines 2>/dev/null || echo 50)}

tmux new-session -d -s "$SESSION" -n "dev" -c "$CWD" -x "$COLS" -y "$ROWS"

# Top pane already exists (pane 1) — start helix
tmux send-keys -t "$SESSION:dev.1" "$EDITOR ." Enter
tmux select-pane -t "$SESSION:dev.1" -T "helix"

# Split bottom 30% for first shell
tmux split-window -t "$SESSION:dev.1" -v -l 30% -c "$CWD"
tmux select-pane -t "$SESSION:dev.2" -T "shell"

# Split right for second shell
tmux split-window -t "$SESSION:dev.2" -h -c "$CWD"
tmux select-pane -t "$SESSION:dev.3" -T "tests"

# Focus back on helix pane
tmux select-pane -t "$SESSION:dev.1"
