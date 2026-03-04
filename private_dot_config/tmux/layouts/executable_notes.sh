#!/bin/sh
# notes.sh — notes workspace: todos window + notes window
# Usage: notes.sh <session-name> <cwd>

SESSION="${1:-notes}"
CWD="${2:-$HOME/notes}"

COLS=$(tmux display-message -p '#{client_width}')
ROWS=$(tmux display-message -p '#{client_height}')

# ── Window 1: todos ───────────────────────────────────────────────────────────
tmux new-session -d -s "$SESSION" -n "todos" -c "$CWD/todos" -x "$COLS" -y "$ROWS"

# Top 60%: helix editing inbox
tmux send-keys -t "$SESSION:todos.1" "hx $CWD/todos/inbox.md" Enter
tmux select-pane -t "$SESSION:todos.1" -T "helix"

# Middle 25%: todo list (interactive, user runs tl)
tmux split-window -t "$SESSION:todos.1" -v -l 25% -c "$CWD/todos"
tmux select-pane -t "$SESSION:todos.2" -T "todos"

# Bottom 15%: shell
tmux split-window -t "$SESSION:todos.2" -v -l 37% -c "$CWD"
tmux select-pane -t "$SESSION:todos.3" -T "shell"

# ── Window 2: notes ───────────────────────────────────────────────────────────
tmux new-window -t "$SESSION" -n "notes" -c "$CWD"

# Top 80%: helix for browsing notes
tmux send-keys -t "$SESSION:notes.1" "hx $CWD" Enter
tmux select-pane -t "$SESSION:notes.1" -T "helix"

# Bottom 20%: shell for note commands
tmux split-window -t "$SESSION:notes.1" -v -l 20% -c "$CWD"
tmux select-pane -t "$SESSION:notes.2" -T "shell"

# Focus todos window, helix pane
tmux select-window -t "$SESSION:todos"
tmux select-pane -t "$SESSION:todos.1"
