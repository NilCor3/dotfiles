#!/bin/sh
# ai.sh — copilot left 70%, shell right 30%
# Usage: ai.sh <session-name> <cwd>

SESSION="$1"
CWD="${2:-$HOME}"

if [ -z "$SESSION" ]; then
  echo "Usage: ai.sh <session-name> [cwd]" >&2
  exit 1
fi

COLS=$(tmux display-message -p '#{client_width}' 2>/dev/null)
ROWS=$(tmux display-message -p '#{client_height}' 2>/dev/null)
COLS=${COLS:-$(tput cols 2>/dev/null || echo 220)}
ROWS=${ROWS:-$(tput lines 2>/dev/null || echo 50)}

tmux new-session -d -s "$SESSION" -n "ai" -c "$CWD" -x "$COLS" -y "$ROWS"
tmux select-pane -t "$SESSION:ai.1" -T "copilot"
tmux set-option -p -t "$SESSION:ai.1" @user_title "copilot"

# Start copilot --resume via mise in the left pane
tmux send-keys -t "$SESSION:ai.1" "/opt/homebrew/bin/mise exec -- copilot --resume" Enter

# Split right 30% for shell
tmux split-window -t "$SESSION:ai.1" -h -l 30% -c "$CWD"
tmux select-pane -t "$SESSION:ai.2" -T "shell"
tmux set-option -p -t "$SESSION:ai.2" @user_title "shell"

# Focus left pane
tmux select-pane -t "$SESSION:ai.1"
