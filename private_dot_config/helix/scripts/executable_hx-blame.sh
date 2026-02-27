#!/bin/sh
# Opens tig blame for the current file at the current line in a WezTerm pane.
# Usage: hx-blame.sh <buffer_name> <cursor_line>
#
# Add to ~/.config/helix/config.toml:
# [keys.normal.space.","]
# b = ":sh ~/.config/helix/scripts/hx-blame.sh %{buffer_name} %{cursor_line}"

buffer_name=$1
cursor_line=$2

# Reuse existing right pane or create one
pane_id=$(wezterm cli get-pane-direction right)
if [ -z "$pane_id" ]; then
  pane_id=$(wezterm cli split-pane --right --percent 40)
fi

wezterm cli activate-pane --pane-id "$pane_id"
echo "tig blame $buffer_name +$cursor_line\r" | wezterm cli send-text --pane-id "$pane_id" --no-paste
