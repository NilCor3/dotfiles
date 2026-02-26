#!/bin/sh
# Runs inside the yazi WezTerm pane.
# Called by hx-explorer.sh with: hx-yazi-open.sh <helix_pane_id> <mode>
# Launches yazi, waits for selection, then sends :open/:vsplit/:hsplit to Helix.

hx_pane="$1"
mode="${2:-open}"
chooser_file=$(mktemp)

yazi --chooser-file="$chooser_file"

if [ -s "$chooser_file" ]; then
  # Build space-separated quoted file list
  files=$(while IFS= read -r f; do printf "%q " "$f"; done < "$chooser_file")
  # Send the open command to the Helix pane
  printf ":%s %s\r" "$mode" "$files" \
    | wezterm cli send-text --pane-id "$hx_pane" --no-paste
fi

rm -f "$chooser_file"
wezterm cli activate-pane --pane-id "$hx_pane"
