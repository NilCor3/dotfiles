#!/bin/sh
# Opens yazi file explorer in a left WezTerm pane.
# hx-yazi-open.sh (running inside that pane) handles sending the file back to Helix.
# Supports open, vsplit, hsplit as first argument (default: open).
#
# Keybinding in ~/.config/helix/config.toml:
# [keys.normal.space.","]
# e = ":sh ~/.config/helix/scripts/hx-explorer.sh open"

mode="${1:-open}"
hx_pane="$WEZTERM_PANE"
helper="$HOME/.config/helix/scripts/hx-yazi-open.sh"

# Reuse existing left pane or create one at 25% width
pane_id=$(wezterm cli get-pane-direction left)
if [ -z "$pane_id" ]; then
  pane_id=$(wezterm cli split-pane --left --percent 25)
fi

wezterm cli activate-pane --pane-id "$pane_id"

# Run the helper inside the yazi pane; it handles chooser-file and sending back
printf "%s %s %s\r" "$helper" "$hx_pane" "$mode" \
  | wezterm cli send-text --pane-id "$pane_id" --no-paste
