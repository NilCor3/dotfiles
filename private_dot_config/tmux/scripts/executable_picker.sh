#!/bin/sh
# picker.sh — session picker: sesh for discovery, tmux for create/switch

PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin${PATH:+:$PATH}"
export PATH

LAYOUTS_DIR="$HOME/.config/tmux/layouts"
DEV_DIR="$HOME/dev"
SOURCE_DIR="$HOME/source"

FZF_OPTS='--height=50% --border=rounded --color=bg+:#3c3836,fg+:#ebdbb2,hl+:#d79921,border:#504945,prompt:#458588,pointer:#d79921 --no-info --tiebreak=index'

# ── server check ──────────────────────────────────────────────────────────────
tmux start-server 2>/dev/null || true

# ── helpers ───────────────────────────────────────────────────────────────────
switch_or_attach() {
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$1"
  else
    tmux attach-session -t "$1"
  fi
}

create_named_session() {
  name="$1"
  case "$name" in
    notes)    "$LAYOUTS_DIR/notes.sh"    "$name" "$HOME/notes" ;;
    dotfiles) "$LAYOUTS_DIR/dotfiles.sh" "$name" "$HOME/.local/share/chezmoi" ;;
    shell)    "$LAYOUTS_DIR/shell.sh"    "$name" "$HOME" ;;
    *)        tmux new-session -d -s "$name" -c "$HOME" ;;
  esac
}

# ── build option list ─────────────────────────────────────────────────────────
# Sessions: running tmux sessions + configured sessions (sesh.toml), deduplicated
# Projects: dirs under dev/ and source/ with workspace prefix
options=$(
  sesh list -c -t -d 2>/dev/null | awk '{print "session:  " $0}'
  fd --type d --max-depth 1 --base-directory "$DEV_DIR" 2>/dev/null \
    | sed 's|/$||' | sort | awk '{print "dev:  " $0}'
  fd --type d --max-depth 1 --base-directory "$SOURCE_DIR" 2>/dev/null \
    | sed 's|/$||' | sort | awk '{print "src:  " $0}'
)

[ -z "$options" ] && options="session:  shell"

# ── pick ──────────────────────────────────────────────────────────────────────
choice=$(printf '%s\n' "$options" | fzf $FZF_OPTS --prompt="tmux > ") || exit 130
[ -z "$choice" ] && exit 130

ctype=$(echo "$choice" | cut -d: -f1)
cname=$(echo "$choice" | sed 's/^[^:]*:  *//')

# ── connect ───────────────────────────────────────────────────────────────────
case "$ctype" in
  session)
    if ! tmux has-session -t "$cname" 2>/dev/null; then
      create_named_session "$cname"
    fi
    switch_or_attach "$cname"
    ;;
  dev)
    session_name="dev-$cname"
    if tmux has-session -t "$session_name" 2>/dev/null; then
      switch_or_attach "$session_name"
    else
      "$LAYOUTS_DIR/dev.sh" "$session_name" "$DEV_DIR/$cname"
      switch_or_attach "$session_name"
    fi
    ;;
  src)
    session_name="src-$cname"
    if tmux has-session -t "$session_name" 2>/dev/null; then
      switch_or_attach "$session_name"
    else
      "$LAYOUTS_DIR/dev.sh" "$session_name" "$SOURCE_DIR/$cname"
      switch_or_attach "$session_name"
    fi
    ;;
esac
