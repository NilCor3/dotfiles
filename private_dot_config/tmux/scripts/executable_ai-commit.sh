#!/bin/zsh
# AI-powered commit message generator for tmux popup.
# Runs mods with spinner, shows result, prompts to commit/edit/cancel.

setopt NO_GLOBAL_RCS

DIFF=$(git diff --staged 2>/dev/null)

if [ -z "$DIFF" ]; then
  echo "No staged changes."
  echo ""
  echo "Stage files first (e.g. git add -p), then run again."
  read -r -s -k "?Press any key to close..."
  exit 1
fi

echo "Generating commit message with AI...\n"

MSG=$(printf '%s' "$DIFF" | mods --no-cache \
  --api ollama \
  --model qwen2.5-coder:7b \
  "Write a git commit message for these staged changes.
Use conventional commits format: type(scope): summary.
Types: feat, fix, refactor, docs, style, test, chore.
Keep the first line under 72 characters, imperative mood, no trailing period.
Output only the commit message, nothing else.")

if [ -z "$MSG" ]; then
  echo "Failed to generate message."
  read -r -s -k "?Press any key to close..."
  exit 1
fi

echo ""
print -P "%F{yellow}──────────────────────────────────────%f"
echo "$MSG"
print -P "%F{yellow}──────────────────────────────────────%f"
echo ""
print -P "%F{green}[c]%f commit  %F{blue}[e]%f edit in Helix  %F{red}[q]%f cancel"
read -r -k 1 choice
echo ""

case "$choice" in
  c|C)
    git commit -m "$MSG"
    echo ""
    read -r -s -k "?Press any key to close..."
    ;;
  e|E)
    TMPFILE=$(mktemp /tmp/ai-commit-XXXXXX.txt)
    printf '%s\n' "$MSG" > "$TMPFILE"
    $EDITOR "$TMPFILE"
    EDITED=$(cat "$TMPFILE")
    rm -f "$TMPFILE"
    if [ -n "$EDITED" ]; then
      git commit -m "$EDITED"
      echo ""
      read -r -s -k "?Press any key to close..."
    fi
    ;;
  *)
    echo "Cancelled."
    sleep 0.5
    ;;
esac
