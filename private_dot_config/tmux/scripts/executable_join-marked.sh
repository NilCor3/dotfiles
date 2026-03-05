#!/bin/sh
# Join the marked pane as a full-width split.
# Usage: join-marked.sh [-b]   (-b = above, default = below)

FLAGS="-v -f"
[ "$1" = "-b" ] && FLAGS="-v -f -b"

MARKED=$(tmux list-panes -a -F '#{pane_id} #{pane_marked}' | awk '$2==1{print $1}')
CURRENT=$(tmux display-message -p '#{pane_id}')

if [ -z "$MARKED" ]; then
  tmux display-message "No marked pane — use prefix+m to mark one first"
  exit 1
fi

if [ "$MARKED" = "$CURRENT" ]; then
  tmux display-message "Navigate to a different pane before joining"
  exit 1
fi

# shellcheck disable=SC2086
tmux join-pane $FLAGS -s "$MARKED"
