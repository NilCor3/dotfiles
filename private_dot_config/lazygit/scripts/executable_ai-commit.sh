#!/bin/sh
# Generate a git commit message from staged changes using ollama.
# Usage: ai-commit.sh
# Outputs the commit message to stdout.

DIFF=$(git diff --staged)

if [ -z "$DIFF" ]; then
  echo "No staged changes." >&2
  exit 1
fi

PROMPT="Write a git commit message for these staged changes.
Use conventional commits format: type(scope): summary.
Types: feat, fix, refactor, docs, style, test, chore.
Keep the first line under 72 characters, imperative mood, no trailing period.
Output only the commit message, nothing else.

$DIFF"

curl -s http://localhost:11434/api/generate \
  -H 'Content-Type: application/json' \
  -d "$(printf '%s' "$PROMPT" | python3 -c '
import sys, json
prompt = sys.stdin.read()
print(json.dumps({"model": "qwen2.5-coder:7b", "prompt": prompt, "stream": False}))
')" | python3 -c 'import sys, json; print(json.load(sys.stdin)["response"].strip())'
