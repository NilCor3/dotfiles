#!/usr/bin/env bash
# Send a build/run command for the given filetype to tmux pane .1

FILETYPE="${1:-}"
PANE="${TMUX_PANE%.*}.1"

case "$FILETYPE" in
  go)                       CMD="go run ." ;;
  rust)                     CMD="cargo run" ;;
  java)                     CMD="mvn compile" ;;
  javascript|typescript|typescriptreact) CMD="node ." ;;
  python)                   CMD="python ." ;;
  sh|bash|zsh)              CMD="bash ${TMUX_PANE_CURRENT_PATH}" ;;
  *)                        CMD="echo 'No runner configured for: $FILETYPE'" ;;
esac

tmux send-keys -t "$PANE" "$CMD" Enter
