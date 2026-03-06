#!/bin/sh
# Open yazi file manager in a tmux popup at the current buffer's directory.
# Chosen files are sent to Helix via tmux send-keys (:open).
# Usage: hx-yazi.sh <buffer_name>

BUFFER="$1"

# Determine directory: use buffer's dir if it's a real file, else cwd
if [ -f "$BUFFER" ]; then
  DIR=$(dirname "$BUFFER")
else
  DIR=$(pwd)
fi

CHOOSER=$(mktemp /tmp/hx-yazi-chosen-XXXXXX)
HELIX_PANE=$(tmux display-message -p '#{pane_id}')

if [ -n "$TMUX" ]; then
  tmux display-popup -E -w 80% -h 80% -b rounded -s "fg=#d79921" \
    "yazi --chooser-file '$CHOOSER' '$DIR'"
else
  yazi --chooser-file "$CHOOSER" "$DIR"
fi

# Send :open commands to Helix for each chosen file
if [ -s "$CHOOSER" ]; then
  while IFS= read -r file; do
    [ -n "$file" ] || continue
    tmux send-keys -t "$HELIX_PANE" Escape
    tmux send-keys -t "$HELIX_PANE" ":open ${file}" Enter
  done < "$CHOOSER"
fi

rm -f "$CHOOSER"
