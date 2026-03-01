#!/bin/bash
# Toggle inline completion provider between copilot and ollama-ls in languages.toml
# Called via Space , a in Helix, followed by :lsp-restart

LANGUAGES_TOML="$HOME/.config/helix/languages.toml"
STATE_FILE="$HOME/.config/helix/.ai-provider"
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "copilot")

if [[ "$CURRENT" == "copilot" ]]; then
    sed -i '' 's/"copilot"/"ollama-ls"/g' "$LANGUAGES_TOML"
    echo "ollama" > "$STATE_FILE"
    echo "🦙 Switched to ollama-ls (qwen2.5-coder:7b)"
else
    sed -i '' 's/"ollama-ls"/"copilot"/g' "$LANGUAGES_TOML"
    echo "copilot" > "$STATE_FILE"
    echo "🤖 Switched to GitHub Copilot"
fi
