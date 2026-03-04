#!/bin/sh
# lazygit.sh — open lazygit at a given path via mise exec
# Usage: lazygit.sh <path>
mise_bin="$HOME/.local/share/mise/bin/mise"
"$mise_bin" exec -- lazygit -p "${1:-$HOME}"
