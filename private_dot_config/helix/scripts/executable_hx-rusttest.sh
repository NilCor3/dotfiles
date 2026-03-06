#!/bin/sh
# Runs Rust tests from Helix via cargo nextest.
# Usage: hx-rusttest.sh <file> <line> <mode>
#   mode: cursor | func | file
#
# Keybindings (via hx-test.sh dispatcher) in ~/.config/helix/config.toml:
#   t = cursor mode (test function at cursor)
#   T = func mode  (whole test function)
#   F = file mode  (all tests in package)

file="$1"
line="$2"
mode="${3:-cursor}"

# Get test pattern from Python parser
pattern=$(python3 ~/.config/helix/scripts/hx-rusttest.py "$file" "$line" "$mode" 2>/tmp/hx-rusttest-err.log)
if [ $? -ne 0 ]; then
  msg=$(cat /tmp/hx-rusttest-err.log)
  if [ -n "$TMUX" ]; then
    tmux display-message "hx-rusttest: $msg"
  fi
  exit 1
fi

# Find the cargo workspace/package root (walk up looking for Cargo.toml)
pkg_dir=$(cd "$(dirname "$file")" && pwd)
while [ "$pkg_dir" != "/" ] && [ ! -f "$pkg_dir/Cargo.toml" ]; do
  pkg_dir=$(dirname "$pkg_dir")
done
if [ ! -f "$pkg_dir/Cargo.toml" ]; then
  if [ -n "$TMUX" ]; then
    tmux display-message "hx-rusttest: no Cargo.toml found"
  fi
  exit 1
fi

# Build the cargo nextest command
if [ "$pattern" = "__ALL__" ]; then
  run_cmd="echo '» cargo nextest run'; echo; cd $(printf '%q' "$pkg_dir") && cargo nextest run 2>&1; echo; echo '--- done ---'; exec zsh"
else
  run_cmd="echo '» cargo nextest run ${pattern}'; echo; cd $(printf '%q' "$pkg_dir") && cargo nextest run $(printf '%q' "$pattern") 2>&1; echo; echo '--- done ---'; exec zsh"
fi

if [ -n "$TMUX" ]; then
  # Reuse named pane "tests" in current window, or create a new split
  existing=$(tmux list-panes -F "#{pane_id} #{pane_title}" 2>/dev/null | awk '/^[^ ]+ tests$/{print $1}' | head -1)
  if [ -n "$existing" ]; then
    tmux send-keys -t "$existing" "clear; $run_cmd" Enter
    tmux select-pane -t "$existing"
  else
    tmux split-window -v -l 35% -c "$pkg_dir" "zsh -c $(printf '%q' "$run_cmd")"
    tmux select-pane -T "tests"
  fi
fi
