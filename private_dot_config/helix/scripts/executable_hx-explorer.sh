#!/bin/sh
# Opens yazi file explorer in a left WezTerm pane.
# When a file is selected in yazi, it opens in Helix via the hx-open event.
#
# Keybinding in ~/.config/helix/config.toml:
# [keys.normal.space.","]
# e = ":sh ~/.config/helix/scripts/hx-explorer.sh"

# Reuse existing left pane or create one at 25% width
pane_id=$(wezterm cli get-pane-direction left)
if [ -z "$pane_id" ]; then
  pane_id=$(wezterm cli split-pane --left --percent 25)
fi

wezterm cli activate-pane --pane-id "$pane_id"
echo "yazi\r" | wezterm cli send-text --pane-id "$pane_id" --no-paste
