#!/bin/sh
# ai.sh — AI assistant top 70%, shell bottom 30%
# Usage: ai.sh <session-name> <cwd>
# Top pane: "ai"   — start your AI tool here manually
# Bottom pane: "shell"

SESSION="$1"
CWD="${2:-$HOME}"

if [ -z "$SESSION" ]; then
  echo "Usage: ai.sh <session-name> [cwd]" >&2
  exit 1
fi

tmux new-session -d -s "$SESSION" -n "ai" -c "$CWD"
tmux select-pane -t "$SESSION:ai.1" -T "ai"

# Split bottom 30% for shell
tmux split-window -t "$SESSION:ai.1" -v -p 30 -c "$CWD"
tmux select-pane -t "$SESSION:ai.2" -T "shell"

# Focus top pane
tmux select-pane -t "$SESSION:ai.1"
