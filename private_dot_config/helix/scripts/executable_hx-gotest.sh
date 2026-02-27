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

pkg_dir=$(dirname "$file")

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

if [ -z "$output_pane" ]; then
  # New pane: run command directly at spawn time — no send-text timing issues
  run_cmd="echo '» go test -run ${pattern} -v .'; echo; cd $(printf '%q' "$pkg_dir") && go test -run $(printf '%q' "$pattern") -v . 2>&1; echo; echo '--- done ---'; exec zsh"
  output_pane=$(wezterm cli split-pane --pane-id "$WEZTERM_PANE" --bottom --percent 35 \
    -- zsh -c "$run_cmd")
  echo "$output_pane" > "$pane_id_file"
  wezterm cli activate-pane --pane-id "$output_pane"
else
  # Existing pane: clear then run
  cmd="clear; echo '» go test -run ${pattern} -v .'; echo; cd $(printf '%q' "$pkg_dir") && go test -run $(printf '%q' "$pattern") -v . 2>&1; echo; echo '--- done ---'"
  printf "%s\r" "$cmd" | wezterm cli send-text --pane-id "$output_pane" --no-paste
  wezterm cli activate-pane --pane-id "$output_pane"
fi
