#!/bin/sh
# Diffs the defaults write values in run_once_after_macos-defaults.sh
# against the actual current macOS defaults.
# Usage: ./diff-macos-defaults.sh

SCRIPT="$(dirname "$0")/run_once_after_macos-defaults.sh"

if [ ! -f "$SCRIPT" ]; then
  echo "Error: $SCRIPT not found"
  exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

drift=0

# Parse every "defaults write <domain> <key> <type> <value>" line
while IFS= read -r line; do
  # Strip leading whitespace and skip comments/empty lines
  stripped=$(echo "$line" | sed 's/^[[:space:]]*//')
  case "$stripped" in
    defaults\ write\ *);;
    *) continue;;
  esac

  # Extract: domain key type value
  domain=$(echo "$stripped" | awk '{print $3}')
  key=$(echo "$stripped"    | awk '{print $4}')
  type=$(echo "$stripped"   | awk '{print $5}')
  value=$(echo "$stripped"  | awk '{print $6}')

  # Read current value from macOS
  current=$(defaults read "$domain" "$key" 2>/dev/null)

  if [ $? -ne 0 ]; then
    printf "${YELLOW}MISSING${RESET}  %-45s %-40s (not set, script wants: %s)\n" "$domain" "$key" "$value"
    drift=$((drift + 1))
    continue
  fi

  # Normalize bools: script uses true/false, defaults read returns 1/0
  # Some apps store bools as literal "true"/"false" strings — handle both
  normalized_value="$value"
  if [ "$type" = "-bool" ]; then
    case "$value" in
      true)  normalized_value=1;;
      false) normalized_value=0;;
    esac
  fi

  # Strip surrounding quotes from string values (defaults read doesn't include them)
  normalized_value=$(echo "$normalized_value" | sed 's/^"\(.*\)"$/\1/')

  # Also normalize current value bools stored as literal strings
  case "$current" in
    true)  current=1;;
    false) current=0;;
  esac

  if [ "$current" = "$normalized_value" ]; then
    printf "${GREEN}OK${RESET}       %-45s %-40s = %s\n" "$domain" "$key" "$current"
  else
    printf "${RED}DRIFT${RESET}    %-45s %-40s script=%s current=%s\n" "$domain" "$key" "$value" "$current"
    drift=$((drift + 1))
  fi

done < "$SCRIPT"

echo ""
if [ "$drift" -eq 0 ]; then
  printf "${GREEN}All defaults match.${RESET}\n"
else
  printf "${RED}%d setting(s) have drifted. Run chezmoi apply to re-apply.${RESET}\n" "$drift"
fi
