#!/bin/sh
# Dispatches to the appropriate test runner based on file extension.
# Usage: hx-test.sh <file> <line> <mode>
#   mode: cursor | func | file

file="$1"
line="$2"
mode="${3:-cursor}"

case "$file" in
  *.go)
    exec ~/.config/helix/scripts/hx-gotest.sh "$file" "$line" "$mode"
    ;;
  *.rs)
    exec ~/.config/helix/scripts/hx-rusttest.sh "$file" "$line" "$mode"
    ;;
  *)
    if [ -n "$TMUX" ]; then
      tmux display-message "hx-test: unsupported file type: $file"
    fi
    exit 1
    ;;
esac
