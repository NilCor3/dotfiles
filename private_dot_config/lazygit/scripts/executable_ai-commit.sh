#!/bin/sh
# Generate a git commit message from staged changes using mods.
# Usage: ai-commit.sh
# Outputs the commit message to stdout.

DIFF=$(git diff --staged)

if [ -z "$DIFF" ]; then
  echo "No staged changes." >&2
  exit 1
fi

printf '%s' "$DIFF" | mods --no-cache \
  "Write a git commit message for these staged changes. \
Use conventional commits format: type(scope): summary. \
Types: feat, fix, refactor, docs, style, test, chore. \
Keep the first line under 72 characters, imperative mood, no trailing period. \
Output only the commit message, nothing else."
