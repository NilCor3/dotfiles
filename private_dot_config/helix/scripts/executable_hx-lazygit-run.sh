#!/bin/sh
# Runs inside the lazygit WezTerm pane.
# Launches lazygit, then kills the pane and returns focus to Helix.

hx_pane="$1"
if [ -z "$hx_pane" ]; then
  hx_pane=$(~/.config/helix/scripts/wezterm-find-hx.sh --same-tab)
fi
if [ -z "$hx_pane" ]; then
  hx_pane=$(~/.config/helix/scripts/wezterm-find-hx.sh)
fi

lazygit

wezterm cli activate-pane --pane-id "$hx_pane"
wezterm cli kill-pane --pane-id "$WEZTERM_PANE"
