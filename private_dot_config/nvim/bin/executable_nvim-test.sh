#!/usr/bin/env bash
# nvim-test.sh <file> <line> <mode>
# mode: cursor | func | file | all
# Sends the appropriate test command to tmux pane .1
set -euo pipefail

FILE="${1:-}"
LINE="${2:-1}"
MODE="${3:-all}"
PANE="${TMUX_PANE%.*}.1"

send() { tmux send-keys -t "$PANE" "$1" Enter; }

ext="${FILE##*.}"

case "$ext" in
  go)
    case "$MODE" in
      all)
        send "go test ./..." ;;
      file)
        PKG="./$(realpath --relative-to="$(pwd)" "$(dirname "$FILE")")"
        send "go test -count=1 -v $PKG" ;;
      cursor|func)
        PATTERN="$(~/.local/bin/hx-gotest "$FILE" "$LINE" 2>/dev/null || true)"
        if [[ -z "$PATTERN" ]]; then send "go test ./..."; exit 0; fi
        [[ "$MODE" == "func" ]] && PATTERN="${PATTERN%%/*}"
        send "go test -run '$PATTERN' -v ./..." ;;
    esac ;;
  rs)
    case "$MODE" in
      all|file|func)
        send "cargo nextest run" ;;
      cursor)
        NAME=$(awk "NR<=$LINE" "$FILE" | grep -oP '(?<=fn )(test_\w+)' | tail -1 || true)
        [[ -n "$NAME" ]] && send "cargo nextest run $NAME" || send "cargo nextest run" ;;
    esac ;;
  java)
    send "mvn test" ;;
  ts|tsx|js|jsx)
    send "npx vitest run" ;;
  *)
    tmux display-message "nvim-test: no runner for .$ext" ;;
esac
