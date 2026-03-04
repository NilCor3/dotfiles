#!/bin/sh
# picker.sh — fzf project/session picker for tmux
# Each layout has its own post-selection flow.

LAYOUTS_DIR="$HOME/.config/tmux/layouts"
DEV_DIR="$HOME/dev"
SOURCE_DIR="$HOME/source"

FZF_OPTS='--height=50% --border=rounded --color=bg+:#3c3836,fg+:#ebdbb2,hl+:#d79921,border:#504945,prompt:#458588,pointer:#d79921 --no-info'

# ── helpers ───────────────────────────────────────────────────────────────────
switch_or_attach() {
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$1"
  else
    tmux attach-session -t "$1"
  fi
}

create_and_switch() {
  session_name="$1"; cwd="$2"; layout="$3"
  if tmux has-session -t "$session_name" 2>/dev/null; then
    switch_or_attach "$session_name"
  else
    "$LAYOUTS_DIR/${layout}.sh" "$session_name" "$cwd"
    switch_or_attach "$session_name"
  fi
}

# ── build option list ─────────────────────────────────────────────────────────
options=""
while IFS= read -r s; do
  [ -n "$s" ] && options="${options}session: ${s}
"
done << EOF
$(tmux list-sessions -F "#S" 2>/dev/null | sort)
EOF

for f in "$LAYOUTS_DIR"/*.sh; do
  [ -f "$f" ] || continue
  lname=$(basename "$f" .sh)
  options="${options}layout:  ${lname}
"
done

options=$(printf '%s' "$options" | grep -v '^$')
[ -z "$options" ] && options="layout:  dev"

# ── first pick ────────────────────────────────────────────────────────────────
choice=$(printf '%s\n' "$options" | eval fzf $FZF_OPTS --prompt='"tmux > "')
[ -z "$choice" ] && exit 0

ctype=$(printf '%s' "$choice" | cut -d: -f1 | tr -d ' ')
cname=$(printf '%s' "$choice" | sed 's/^[^:]*: *//')

# ── existing session ──────────────────────────────────────────────────────────
if [ "$ctype" = "session" ]; then
  switch_or_attach "$cname"
  exit 0
fi

layout="$cname"

# ── layout: shell ─────────────────────────────────────────────────────────────
if [ "$layout" = "shell" ]; then
  next=1
  while tmux has-session -t "shell-$next" 2>/dev/null; do next=$((next + 1)); done
  printf "Session name [shell-%s]: " "$next"
  read -r input
  sname="${input:-shell-$next}"
  create_and_switch "$sname" "$HOME" "shell"
  exit 0
fi

# ── layout: ai ───────────────────────────────────────────────────────────────
if [ "$layout" = "ai" ]; then
  folder=$(find "$HOME" -mindepth 1 -maxdepth 3 -type d 2>/dev/null \
    | grep -v '/\.' \
    | sed "s|$HOME/||" \
    | sort \
    | eval fzf $FZF_OPTS --prompt='"folder (ai) > "')
  [ -z "$folder" ] && exit 0
  foldername=$(basename "$folder")
  session_name="ai-$foldername"
  create_and_switch "$session_name" "$HOME/$folder" "ai"
  exit 0
fi

# ── layout: dev (and any other project layout) ────────────────────────────────
workspace=$(printf 'dev\nsource' | eval fzf $FZF_OPTS --prompt='"workspace > "')
[ -z "$workspace" ] && exit 0

case "$workspace" in
  dev)    base_dir="$DEV_DIR" ;;
  source) base_dir="$SOURCE_DIR" ;;
  *)      base_dir="$HOME/$workspace" ;;
esac

repo=$(find "$base_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
  | sort \
  | sed "s|$base_dir/||" \
  | eval fzf $FZF_OPTS --prompt='"repo ($workspace) > "')
[ -z "$repo" ] && exit 0

create_and_switch "${workspace}-${repo}" "${base_dir}/${repo}" "$layout"
