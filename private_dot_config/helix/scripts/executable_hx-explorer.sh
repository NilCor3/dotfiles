#!/bin/sh
# Opens yazi file explorer in a left WezTerm pane.
# Selected files are sent back to the calling Helix pane via WezTerm.
# Supports open, vsplit, hsplit as first argument (default: open).
#
# Keybinding in ~/.config/helix/config.toml:
# [keys.normal.space.","]
# e = ":sh ~/.config/helix/scripts/hx-explorer.sh open"

mode="${1:-open}"
hx_pane="$WEZTERM_PANE"
chooser_file=$(mktemp)

# Reuse existing left pane or create one at 25% width
pane_id=$(wezterm cli get-pane-direction left)
if [ -z "$pane_id" ]; then
  pane_id=$(wezterm cli split-pane --left --percent 25)
fi

wezterm cli activate-pane --pane-id "$pane_id"

# Run yazi with chooser-file, wait for it to finish
echo "yazi --chooser-file=$chooser_file; wezterm cli activate-pane --pane-id $hx_pane\r" \
  | wezterm cli send-text --pane-id "$pane_id" --no-paste

# Poll until yazi exits and chooser-file is written
while wezterm cli list --format json 2>/dev/null \
  | grep -q "\"pane_id\":$pane_id"; do
  sleep 0.1
done

# Send chosen files to Helix
if [ -s "$chooser_file" ]; then
  files=$(cat "$chooser_file" | while IFS= read -r f; do printf "%q " "$f"; done)
  echo ":$mode $files\r" | wezterm cli send-text --pane-id "$hx_pane" --no-paste
fi

rm -f "$chooser_file"
