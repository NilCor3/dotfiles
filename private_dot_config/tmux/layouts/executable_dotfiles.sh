#!/bin/sh
# dotfiles.sh — copilot top 80%, shell bottom 20%, cwd = chezmoi source
# Usage: dotfiles.sh <session-name> <cwd>

SESSION="$1"
CWD="${2:-$HOME/.local/share/chezmoi}"

if [ -z "$SESSION" ]; then
  echo "Usage: dotfiles.sh <session-name> [cwd]" >&2
  exit 1
fi

COLS=$(tmux display-message -p '#{client_width}' 2>/dev/null)
ROWS=$(tmux display-message -p '#{client_height}' 2>/dev/null)
COLS=${COLS:-$(tput cols 2>/dev/null || echo 220)}
ROWS=${ROWS:-$(tput lines 2>/dev/null || echo 50)}

tmux new-session -d -s "$SESSION" -n "dotfiles" -c "$CWD" -x "$COLS" -y "$ROWS"
tmux select-pane -t "$SESSION:dotfiles.1" -T "copilot"

# Start copilot --resume in the top pane
tmux send-keys -t "$SESSION:dotfiles.1" "/opt/homebrew/bin/mise exec -- copilot --resume" Enter

# Split bottom 20% for shell
tmux split-window -t "$SESSION:dotfiles.1" -v -l 20% -c "$CWD"
tmux select-pane -t "$SESSION:dotfiles.2" -T "shell"

# Focus top pane
tmux select-pane -t "$SESSION:dotfiles.1"
