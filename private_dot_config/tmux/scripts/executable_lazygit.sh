#!/bin/sh
# lazygit.sh — open lazygit at a given path via mise exec
# Usage: lazygit.sh <path>
/opt/homebrew/bin/mise exec -- lazygit -p "${1:-$HOME}"
