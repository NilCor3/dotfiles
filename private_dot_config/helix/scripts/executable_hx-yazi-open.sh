#!/bin/sh
# Runs inside the yazi WezTerm pane.
# Called by hx-explorer.sh with: hx-yazi-open.sh <helix_pane_id> <mode>
# Launches yazi, waits for selection, then sends :open/:vsplit/:hsplit to Helix.

hx_pane="$1"
mode="${2:-open}"
chooser_file=$(mktemp)

yazi --chooser-file="$chooser_file"

if [ -s "$chooser_file" ]; then
  while IFS= read -r f; do
    printf ":%s %s\r" "$mode" "$f" \
      | wezterm cli send-text --pane-id "$hx_pane" --no-paste
    # After first file use open so subsequent files become buffers
    mode="open"
  done < "$chooser_file"
fi

rm -f "$chooser_file"
wezterm cli activate-pane --pane-id "$hx_pane"
