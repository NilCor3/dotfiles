#!/bin/sh
# Opens lazygit in a zoomed bottom pane (overlay effect).
# Quitting lazygit kills the pane and returns focus to Helix.
#
# Keybinding in ~/.config/helix/config.toml:
# [keys.normal.space.","]
# g = ":sh ~/.config/helix/scripts/hx-lazygit.sh"

hx_pane="$WEZTERM_PANE"
helper="$HOME/.config/helix/scripts/hx-lazygit-run.sh"

# Spawn a new bottom pane at 40% height
pane_id=$(wezterm cli split-pane --bottom --percent 40)

# Zoom it to fill the tab (overlay effect)
wezterm cli zoom-pane --pane-id "$pane_id"

# Activate it and run the helper inside
wezterm cli activate-pane --pane-id "$pane_id"
printf "%s %s\r" "$helper" "$hx_pane" \
  | wezterm cli send-text --pane-id "$pane_id" --no-paste
