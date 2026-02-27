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

# Get -run pattern from AST tool
pattern=$(~/.local/bin/hx-gotest "$file" "$line" "$mode" 2>/tmp/hx-gotest-err.log)
if [ $? -ne 0 ]; then
  msg=$(cat /tmp/hx-gotest-err.log)
  wezterm cli send-text --pane-id "$WEZTERM_PANE" --no-paste \
    ":echo 'hx-gotest: $msg'\r"
  exit 1
fi

pkg_dir=$(dirname "$file")

# Reuse or create a bottom pane for output
pane_id=$(wezterm cli get-pane-direction down)
if [ -z "$pane_id" ]; then
  pane_id=$(wezterm cli split-pane --bottom --percent 35)
fi

wezterm cli activate-pane --pane-id "$pane_id"

# Run tests, stream output into the pane
cmd="cd $(printf '%q' "$pkg_dir") && go test -run $(printf '%q' "$pattern") -v . 2>&1; echo '--- done ---'"
printf "%s\r" "$cmd" | wezterm cli send-text --pane-id "$pane_id" --no-paste
