#!/bin/sh
# wezterm-picker.sh — launch tmux picker as the outer WezTerm process
#
# Behavior:
# - Fresh window: show picker
# - Attach to tmux: when detached, show picker again
# - Cancel picker: exit so the WezTerm window closes

set -eu

PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin${PATH:+:$PATH}"
export PATH

PICKER="$HOME/.config/tmux/scripts/picker.sh"

while :; do
  if "$PICKER"; then
    status=0
  else
    status=$?
  fi

  case "$status" in
    0)
      # Detached from tmux after a successful attach/switch: show picker again.
      ;;
    130)
      # User cancelled the picker: close the WezTerm window.
      exit 0
      ;;
    *)
      # Unexpected error — loop with a brief pause rather than closing the window.
      sleep 1
      ;;
  esac
done
