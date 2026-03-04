#!/bin/sh
# lazygit.sh — open lazygit at session root via mise exec
/opt/homebrew/bin/mise exec -- lazygit -p "${SESSION_PATH:-$HOME}"
