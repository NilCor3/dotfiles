#!/usr/bin/env bash
# Imports all tracked app plists from this directory.
# Run on a fresh install after chezmoi apply.

set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

plists=(
  com.stonerl.Thaw
  com.lwouis.alt-tab-macos
  com.knollsoft.Hyperkey
)

for domain in "${plists[@]}"; do
  file="$DIR/$domain.plist"
  if [[ -f "$file" ]]; then
    defaults import "$domain" "$file"
    echo "✓ $domain"
  else
    echo "⚠ $domain.plist not found, skipping"
  fi
done

echo "Done. Restart affected apps to pick up changes."
