#!/bin/sh
# Opens lazygit in a zoomed bottom pane (overlay effect).
# Quitting lazygit kills the pane and returns focus to Helix.
#
# Keybinding in ~/.config/helix/config.toml:
# [keys.normal.space.","]
# g = ":sh ~/.config/helix/scripts/hx-lazygit.sh"

hx_pane="$WEZTERM_PANE"
helper="$HOME/.config/helix/scripts/hx-lazygit-run.sh"

if [ -n "$ZELLIJ" ]; then
  # Zellij: floating pane, closes when lazygit exits
  zellij action new-pane --floating --close-on-exit --name "lazygit" -- lazygit
elif [ -n "$TMUX" ]; then
  # tmux: 80%x80% popup
  tmux display-popup -E -w 80% -h 80% -b rounded -s "fg=#d79921" lazygit
else
  # WezTerm: bottom pane zoomed for overlay effect
  pane_id=$(wezterm cli split-pane --bottom --percent 40)
  wezterm cli zoom-pane --pane-id "$pane_id"
  wezterm cli activate-pane --pane-id "$pane_id"
  printf "%s %s\r" "$helper" "$hx_pane" \
    | wezterm cli send-text --pane-id "$pane_id" --no-paste
fi
