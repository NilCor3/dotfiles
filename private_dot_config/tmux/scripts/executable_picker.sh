#!/bin/sh
# picker.sh — fzf project/session picker for tmux using fd

PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin${PATH:+:$PATH}"
export PATH

LAYOUTS_DIR="$HOME/.config/tmux/layouts"
DEV_DIR="$HOME/dev"
SOURCE_DIR="$HOME/source"

FZF_OPTS='--height=50% --border=rounded --color=bg+:#3c3836,fg+:#ebdbb2,hl+:#d79921,border:#504945,prompt:#458588,pointer:#d79921 --no-info'

# ── server check ──────────────────────────────────────────────────────────────
# Start the tmux server up front so session queries/layout creation work from a
# fresh WezTerm window without creating a dummy session.
tmux start-server 2>/dev/null || true

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
    # Ensure the layout script exists before running
    if [ -f "$LAYOUTS_DIR/${layout}.sh" ]; then
      "$LAYOUTS_DIR/${layout}.sh" "$session_name" "$cwd"
    else
      tmux new-session -d -s "$session_name" -c "$cwd"
    fi
    switch_or_attach "$session_name"
  fi
}

# ── build option list ─────────────────────────────────────────────────────────
options=$(
  tmux list-sessions -F "session: #S" 2>/dev/null | sort
  for f in "$LAYOUTS_DIR"/*.sh; do
    [ -f "$f" ] && echo "layout:  $(basename "$f" .sh)"
  done
)

[ -z "$options" ] && options="layout:  dev"

# ── first pick ────────────────────────────────────────────────────────────────
choice=$(printf '%s\n' "$options" | fzf $FZF_OPTS --prompt="tmux > ") || exit 130
[ -z "$choice" ] && exit 130

ctype=$(echo "$choice" | cut -d: -f1 | tr -d ' ')
cname=$(echo "$choice" | sed 's/^[^:]*: *//')

if [ "$ctype" = "session" ]; then
  switch_or_attach "$cname"
  exit 0
fi

layout="$cname"

# ── layout logic ──────────────────────────────────────────────────────────────
case "$layout" in
  notes)
    create_and_switch "notes" "$HOME/notes" "notes"
    ;;
  shell)
    next=$(tmux list-sessions -F "#S" | grep -c "^shell-" || echo 0)
    next=$((next + 1))
    printf "Session name [shell-%s]: " "$next" >/dev/tty
    IFS= read -r input </dev/tty || exit 130
    create_and_switch "${input:-shell-$next}" "$HOME" "shell"
    ;;
  ai)
    # Using fd: --type d (directories), --max-depth 3, --strip-cwd-prefix for cleaner output
    folder=$(fd --type d --max-depth 3 --strip-cwd-prefix . "$HOME" | fzf $FZF_OPTS --prompt="folder (ai) > ") || exit 130
    [ -z "$folder" ] && exit 130
    create_and_switch "ai-$(basename "$folder")" "$HOME/$folder" "ai"
    ;;
  *)
    # Default Project Picker (dev/source)
    workspace=$(printf "dev\nsource" | fzf $FZF_OPTS --prompt="workspace > ") || exit 130
    [ -z "$workspace" ] && exit 130
    
    base_dir="$([ "$workspace" = "dev" ] && echo "$DEV_DIR" || echo "$SOURCE_DIR")"
    
    # Using fd to list immediate subdirectories in the workspace
    repo=$(fd --type d --max-depth 1 --base-directory "$base_dir" | fzf $FZF_OPTS --prompt="repo ($workspace) > ") || exit 130
    [ -z "$repo" ] && exit 130
    
    create_and_switch "${workspace}-${repo%/}" "${base_dir}/${repo%/}" "$layout"
    ;;
esac
