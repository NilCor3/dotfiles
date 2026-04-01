#!/usr/bin/env bash
# nvim-test.sh <file> <line> <mode>
# mode: cursor | func | file | all
# Sends the appropriate test command to the 'tests' tmux pane (creates it if needed)
set -euo pipefail

FILE="${1:-}"
LINE="${2:-1}"
MODE="${3:-all}"

# Find or create a pane titled 'tests' in the current window
WINDOW=$(tmux display-message -p '#{window_id}')
PANE=$(tmux list-panes -t "$WINDOW" -F '#{pane_title} #{pane_id}' \
  | awk '$1=="tests"{print $2; exit}')
if [[ -z "$PANE" ]]; then
  PANE=$(tmux split-window -h -P -F '#{pane_id}' -c "$(pwd)")
  tmux select-pane -t "$PANE" -T "tests"
  tmux select-pane -t "$TMUX_PANE"  # return focus to nvim
fi

send() { tmux send-keys -t "$PANE" "$1" Enter; }
relpath() { python3 -c "import os,sys; print(os.path.relpath(sys.argv[1],sys.argv[2]))" "$1" "$2"; }

# Extract nearest it/test name at or above LINE using Python (reliable on macOS)
js_test_name() {
  python3 - "$1" "$2" <<'PYEOF'
import re, sys
lines = open(sys.argv[1]).read().splitlines()[:int(sys.argv[2])]
for line in reversed(lines):
    m = re.search(r'''(?:it|test)\s*\(\s*['"`]([^'"`]+)''', line)
    if m:
        print(m.group(1))
        break
PYEOF
}

ext="${FILE##*.}"

case "$ext" in
  go)
    case "$MODE" in
      all)
        send "go test ./..." ;;
      file)
        PKG="./$(relpath "$(dirname "$FILE")" "$(pwd)")"
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
    # Detect playwright vs vitest by presence of playwright config
    if [[ -f "$(git rev-parse --show-toplevel 2>/dev/null)/playwright.config.ts" ]] || \
       [[ -f "$(git rev-parse --show-toplevel 2>/dev/null)/playwright.config.js" ]]; then
      case "$MODE" in
        all)
          send "npx playwright test" ;;
        file)
          send "npx playwright test $(relpath "$FILE" "$(pwd)")" ;;
        cursor|func)
          send "npx playwright test $(relpath "$FILE" "$(pwd)"):$LINE" ;;
      esac
    else
      REL="$(relpath "$FILE" "$(pwd)")"
      case "$MODE" in
        all)
          send "npx vitest run" ;;
        file)
          send "npx vitest run $REL" ;;
        cursor|func)
          NAME=$(js_test_name "$FILE" "$LINE")
          if [[ -n "$NAME" ]]; then
            send "npx vitest run $REL -t '$NAME'"
          else
            send "npx vitest run $REL"
          fi ;;
      esac
    fi ;;
  php)
    if [[ -f "vendor/bin/phpunit" ]]; then
      case "$MODE" in
        all)
          send "vendor/bin/phpunit" ;;
        file)
          send "vendor/bin/phpunit $FILE" ;;
        cursor|func)
          send "vendor/bin/phpunit --filter $(grep -oP '(?<=function )(test\w+)' "$FILE" | awk "NR<=$LINE" | tail -1 || echo '') $FILE" ;;
      esac
    else
      tmux display-message "nvim-test: phpunit not found (run: composer require --dev phpunit/phpunit)"
    fi ;;
  *)
    tmux display-message "nvim-test: no runner for .$ext" ;;
esac
