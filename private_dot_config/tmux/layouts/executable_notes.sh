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

# Top pane: helix editing inbox
tmux send-keys -t "$SESSION:todos.1" "$EDITOR $CWD/todos/inbox.md" Enter
tmux select-pane -t "$SESSION:todos.1" -T "helix"

# Bottom 15%: shell (split first so helix + todos share remaining 85%)
tmux split-window -t "$SESSION:todos.1" -v -l 15% -c "$CWD"
tmux select-pane -t "$SESSION:todos.2" -T "shell"

# Split helix area (85%) in half → helix ~42.5%, todos ~42.5%
tmux split-window -t "$SESSION:todos.1" -v -l 50% -c "$CWD/todos"
tmux select-pane -t "$SESSION:todos.2" -T "todos"
tmux send-keys -t "$SESSION:todos.2" "tl" Enter

# ── Window 2: notes ───────────────────────────────────────────────────────────
tmux new-window -t "$SESSION" -n "notes" -c "$CWD"

# Top 80%: helix for browsing notes
tmux send-keys -t "$SESSION:notes.1" "$EDITOR $CWD" Enter
tmux select-pane -t "$SESSION:notes.1" -T "helix"

# Bottom 20%: shell for note commands
tmux split-window -t "$SESSION:notes.1" -v -l 20% -c "$CWD"
tmux select-pane -t "$SESSION:notes.2" -T "shell"

# Focus todos window, helix pane
tmux select-window -t "$SESSION:todos"
tmux select-pane -t "$SESSION:todos.1"
