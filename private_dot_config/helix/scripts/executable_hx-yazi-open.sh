#!/bin/sh
# Runs inside the yazi WezTerm pane.
# Called by hx-explorer.sh with: hx-yazi-open.sh <helix_pane_id> <mode>
# Launches yazi, waits for selection, then sends :open/:vsplit/:hsplit to Helix.

hx_pane="$1"
# If no pane passed, auto-detect helix pane in same tab
if [ -z "$hx_pane" ]; then
  hx_pane=$(~/.config/helix/scripts/wezterm-find-hx.sh --same-tab)
fi
if [ -z "$hx_pane" ]; then
  hx_pane=$(~/.config/helix/scripts/wezterm-find-hx.sh)
fi
mode="${2:-open}"
chooser_file=$(mktemp)
log="/tmp/hx-yazi-debug.log"

echo "hx_pane=$hx_pane mode=$mode chooser=$chooser_file" > "$log"

yazi --chooser-file="$chooser_file"

selected=$(cat "$chooser_file" 2>/dev/null)
echo "yazi exited, selected=[$selected]" >> "$log"

if [ -n "$selected" ]; then
  printf "%s\n" "$selected" | while IFS= read -r f; do
    echo "sending: :$mode $f" >> "$log"
    printf ":%s %s\r" "$mode" "$f" \
      | wezterm cli send-text --pane-id "$hx_pane" --no-paste
    mode="open"
  done
else
  echo "nothing selected" >> "$log"
fi

rm -f "$chooser_file"
wezterm cli activate-pane --pane-id "$hx_pane"
wezterm cli kill-pane --pane-id "$WEZTERM_PANE"
