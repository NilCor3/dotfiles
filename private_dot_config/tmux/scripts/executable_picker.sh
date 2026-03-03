#!/bin/sh
# picker.sh — fzf project/session picker for tmux
# Flow: existing sessions + layouts → layout selected → workspace → repo → create/attach session

LAYOUTS_DIR="$HOME/.config/tmux/layouts"
DEV_DIR="$HOME/dev"
SOURCE_DIR="$HOME/source"

# Build option list: running sessions prefixed with "session:", layouts with "layout:"
options=""

# Existing sessions
if tmux list-sessions -F "#S" 2>/dev/null | while IFS= read -r s; do
  printf "session: %s\n" "$s"
done | sort > /tmp/tmux-picker-sessions.txt; then
  :
fi
options="$(cat /tmp/tmux-picker-sessions.txt 2>/dev/null)"

# Layout names from .sh files
for f in "$LAYOUTS_DIR"/*.sh; do
  [ -f "$f" ] || continue
  name=$(basename "$f" .sh)
  options="$options
layout: $name"
done

# Remove leading newline
options=$(printf '%s' "$options" | sed '/^$/d')

if [ -z "$options" ]; then
  options="layout: dev"
fi

# First fzf: choose session or layout
choice=$(printf '%s\n' "$options" | \
  fzf --prompt="tmux > " \
      --height=40% \
      --border=rounded \
      --color="bg+:#3c3836,fg+:#ebdbb2,hl+:#d79921,border:#504945,prompt:#458588,pointer:#d79921" \
      --no-info \
      --ansi)

[ -z "$choice" ] && exit 0

type=$(printf '%s' "$choice" | cut -d: -f1 | tr -d ' ')
name=$(printf '%s' "$choice" | cut -d' ' -f2-)

if [ "$type" = "session" ]; then
  # Attach to existing session
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$name"
  else
    tmux attach-session -t "$name"
  fi
  exit 0
fi

# Layout selected → pick workspace
workspace=$(printf 'dev\nsource' | \
  fzf --prompt="workspace > " \
      --height=30% \
      --border=rounded \
      --color="bg+:#3c3836,fg+:#ebdbb2,hl+:#d79921,border:#504945,prompt:#458588,pointer:#d79921" \
      --no-info)

[ -z "$workspace" ] && exit 0

case "$workspace" in
  dev)    base_dir="$DEV_DIR" ;;
  source) base_dir="$SOURCE_DIR" ;;
  *)      base_dir="$HOME/$workspace" ;;
esac

# Pick repo from workspace directory
repo=$(find "$base_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
  | sort \
  | sed "s|$base_dir/||" \
  | fzf --prompt="repo ($workspace) > " \
        --height=50% \
        --border=rounded \
        --color="bg+:#3c3836,fg+:#ebdbb2,hl+:#d79921,border:#504945,prompt:#458588,pointer:#d79921" \
        --no-info)

[ -z "$repo" ] && exit 0

session_name="${workspace}-${repo}"
cwd="${base_dir}/${repo}"

# Create or attach session
if tmux has-session -t "$session_name" 2>/dev/null; then
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
else
  "$LAYOUTS_DIR/${name}.sh" "$session_name" "$cwd"
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
fi
