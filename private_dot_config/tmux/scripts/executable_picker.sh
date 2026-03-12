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
# Returns 1 if a session exists AND has a client attached (open in another window)
session_is_attached() {
  tmux list-sessions -F "#{session_name}:#{session_attached}" 2>/dev/null \
    | awk -F: -v s="$1" '$1==s && $2=="1" {found=1} END {exit !found}'
}

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

# ── build option list — hide attached sessions ────────────────────────────────
# Sessions already open in another WezTerm window (session_attached=1) are
# excluded so each window gets its own exclusive session.
options=$(
  tmux list-sessions -F "#{session_attached}:#{session_name}" 2>/dev/null \
    | awk -F: '$1=="0" {print "session:  "$2}' | sort
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
    # Count existing shell sessions to suggest next name
    next=$(tmux list-sessions -F "#S" 2>/dev/null | grep "^shell-" | wc -l | tr -d ' ')
    next=$((next + 1))

    # Build list of unattached shell-* sessions as selectable options
    idle_shells=$(tmux list-sessions -F "#{session_attached}:#{session_name}" 2>/dev/null \
      | awk -F: '$1=="0" && $2~/^shell-/ {print $2}' | sort)

    # fzf with --print-query: user types a name (pre-filled) or selects an idle session.
    # Output line 1 = typed query; line 2 = selected item (if any).
    # Exit 130 = Esc/Ctrl-C (cancel). Exit 1 = empty list, Enter pressed (still valid — query is captured).
    raw=$(printf '%s\n' $idle_shells \
      | fzf $FZF_OPTS --print-query --query "shell-$next" --prompt="shell name > ")
    fzf_status=$?
    [ "$fzf_status" = "130" ] && exit 130

    typed=$(printf '%s\n' "$raw" | sed -n '1p')
    selected=$(printf '%s\n' "$raw" | sed -n '2p')
    session_name="${selected:-$typed}"
    [ -z "$session_name" ] && exit 130

    # Block reattaching to a session that is currently open in another window
    if session_is_attached "$session_name"; then
      printf '\n  ✗ "%s" is already open in another window.\n\n' "$session_name" >/dev/tty
      sleep 2
      exit 0  # Exit 0 → wezterm-picker.sh re-shows the picker
    fi

    create_and_switch "$session_name" "$HOME" "shell"
    ;;
  ai)
    folder=$(fd --type d --max-depth 3 --base-directory "$HOME" | fzf $FZF_OPTS --prompt="folder (ai) > ") || exit 130
    [ -z "$folder" ] && exit 130
    create_and_switch "ai-$(basename "$folder")" "$HOME/$folder" "ai"
    ;;
  *)
    # Default Project Picker (dev/source)
    workspace=$(printf "dev\nsource" | fzf $FZF_OPTS --prompt="workspace > ") || exit 130
    [ -z "$workspace" ] && exit 130

    base_dir="$([ "$workspace" = "dev" ] && echo "$DEV_DIR" || echo "$SOURCE_DIR")"

    repo=$(fd --type d --max-depth 1 --base-directory "$base_dir" | fzf $FZF_OPTS --prompt="repo ($workspace) > ") || exit 130
    [ -z "$repo" ] && exit 130

    create_and_switch "${workspace}-${repo%/}" "${base_dir}/${repo%/}" "$layout"
    ;;
esac
