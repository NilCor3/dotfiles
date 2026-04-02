#!/bin/sh
# dev.sh — horizontal monitor layout
# Usage: dev.sh <session-name> <cwd>
# Left 70%: editor; Right 30%: shell (top) + tests (bottom)

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

# Left pane (pane 1) — editor
tmux send-keys -t "$SESSION:dev.1" "$EDITOR ." Enter
tmux select-pane -t "$SESSION:dev.1" -T "editor"
tmux set-option -p -t "$SESSION:dev.1" @user_title "editor"

# Split right 30% for shell
tmux split-window -t "$SESSION:dev.1" -h -l 30% -c "$CWD"
tmux select-pane -t "$SESSION:dev.2" -T "shell"
tmux set-option -p -t "$SESSION:dev.2" @user_title "shell"

# Split shell pane in half vertically for tests
tmux split-window -t "$SESSION:dev.2" -v -l 50% -c "$CWD"
tmux select-pane -t "$SESSION:dev.3" -T "tests"
tmux set-option -p -t "$SESSION:dev.3" @user_title "tests"

# Focus back on editor pane
tmux select-pane -t "$SESSION:dev.1"
