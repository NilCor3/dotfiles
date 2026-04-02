#!/bin/sh
# notes.sh — notes workspace: todos window + notes window
# Usage: notes.sh <session-name> <cwd>

SESSION="${1:-notes}"
CWD="${2:-$HOME/notes}"

COLS=$(tmux display-message -p '#{client_width}' 2>/dev/null)
ROWS=$(tmux display-message -p '#{client_height}' 2>/dev/null)
COLS=${COLS:-$(tput cols 2>/dev/null || echo 220)}
ROWS=${ROWS:-$(tput lines 2>/dev/null || echo 50)}
# ── Window 1: todos ───────────────────────────────────────────────────────────
tmux new-session -d -s "$SESSION" -n "todos" -c "$CWD/todos" -x "$COLS" -y "$ROWS"

# Left pane: editor opening inbox
tmux send-keys -t "$SESSION:todos.1" "$EDITOR $CWD/todos/inbox.md" Enter
tmux select-pane -t "$SESSION:todos.1" -T "editor"
tmux set-option -p -t "$SESSION:todos.1" @user_title "editor"

# Split right 40% for todos list
tmux split-window -t "$SESSION:todos.1" -h -l 40% -c "$CWD/todos"
tmux select-pane -t "$SESSION:todos.2" -T "todos"
tmux set-option -p -t "$SESSION:todos.2" @user_title "todos"
tmux send-keys -t "$SESSION:todos.2" "tl" Enter

# Split todos pane: shell at bottom 30%
tmux split-window -t "$SESSION:todos.2" -v -l 30% -c "$CWD"
tmux select-pane -t "$SESSION:todos.3" -T "shell"
tmux set-option -p -t "$SESSION:todos.3" @user_title "shell"

# ── Window 2: notes ───────────────────────────────────────────────────────────
tmux new-window -t "$SESSION" -n "notes" -c "$CWD"

# Left pane: editor for browsing notes
tmux send-keys -t "$SESSION:notes.1" "$EDITOR $CWD" Enter
tmux select-pane -t "$SESSION:notes.1" -T "editor"
tmux set-option -p -t "$SESSION:notes.1" @user_title "editor"

# Split right 20% for shell
tmux split-window -t "$SESSION:notes.1" -h -l 20% -c "$CWD"
tmux select-pane -t "$SESSION:notes.2" -T "shell"
tmux set-option -p -t "$SESSION:notes.2" @user_title "shell"

# Focus todos window, editor pane
tmux select-window -t "$SESSION:todos"
tmux select-pane -t "$SESSION:todos.1"
