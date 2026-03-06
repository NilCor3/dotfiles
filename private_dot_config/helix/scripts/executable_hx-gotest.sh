#!/bin/sh
# Runs Go tests from Helix via hx-gotest AST tool.
# Usage: hx-gotest.sh <file> <line> <mode>
#   mode: cursor | func | file
#
# Keybindings in ~/.config/helix/config.toml:
#   t = cursor mode (subtest at cursor, fallback to whole func)
#   T = func mode  (whole test func + all subtests)
#   F = file mode  (all tests in file)

file="$1"
line="$2"
mode="${3:-cursor}"
pane_id_file="/tmp/hx-gotest-output-pane"

# Get -run pattern from AST tool
pattern=$(~/.local/bin/hx-gotest "$file" "$line" "$mode" 2>/tmp/hx-gotest-err.log)
if [ $? -ne 0 ]; then
  msg=$(cat /tmp/hx-gotest-err.log)
  printf ":echo 'hx-gotest: %s'\r" "$msg" \
    | wezterm cli send-text --pane-id "$WEZTERM_PANE" --no-paste
  exit 1
fi

pkg_dir=$(cd "$(dirname "$file")" && pwd)

# Find or create the dedicated output pane
output_pane=""
if [ -f "$pane_id_file" ]; then
  stored=$(cat "$pane_id_file")
  # Verify the pane still exists
  if wezterm cli list --format json 2>/dev/null \
      | python3 -c "import json,sys; ids=[p['pane_id'] for p in json.load(sys.stdin)]; exit(0 if $stored in ids else 1)" 2>/dev/null; then
    output_pane="$stored"
  fi
fi

run_cmd="echo '» richgo test -run ${pattern} -v .'; echo; cd $(printf '%q' "$pkg_dir") && richgo test -run $(printf '%q' "$pattern") -v . 2>&1; echo; echo '--- done ---'; exec zsh"

if [ -n "$ZELLIJ" ]; then
  # Zellij: floating pane (no pane-id targeting available)
  zellij action new-pane --floating --name "gotest" --cwd "$pkg_dir" \
    -- zsh -c "$run_cmd"
elif [ -n "$TMUX" ]; then
  # tmux: reuse named pane "tests" in current window, or create new split
  existing=$(tmux list-panes -F "#{pane_id} #{pane_title}" 2>/dev/null | awk '/^[^ ]+ tests$/{print $1}' | head -1)
  if [ -n "$existing" ]; then
    # Kill whatever is running (copy mode, tests, shell) and start fresh
    tmux respawn-pane -k -c "$pkg_dir" -t "$existing" zsh -c "$(printf '%s' "$run_cmd")"
    tmux select-pane -t "$existing" -T "tests"
    tmux select-pane -t "$existing"
  else
    tmux split-window -v -p 35 -c "$pkg_dir" "zsh -c $(printf '%q' "$run_cmd")"
    tmux select-pane -T "tests"
  fi
elif [ -z "$output_pane" ]; then
  # WezTerm: new pane
  output_pane=$(wezterm cli split-pane --pane-id "$WEZTERM_PANE" --bottom --percent 35 \
    -- zsh -c "$run_cmd")
  echo "$output_pane" > "$pane_id_file"
  wezterm cli activate-pane --pane-id "$output_pane"
else
  # WezTerm: existing pane — clear then run
  cmd="clear; echo '» richgo test -run ${pattern} -v .'; echo; cd $(printf '%q' "$pkg_dir") && richgo test -run $(printf '%q' "$pattern") -v . 2>&1; echo; echo '--- done ---'"
  printf "%s\r" "$cmd" | wezterm cli send-text --pane-id "$output_pane" --no-paste
  wezterm cli activate-pane --pane-id "$output_pane"
fi
