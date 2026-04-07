#!/usr/bin/env bash
# Exports all tracked app plists to this directory.
# Run after changing app settings, then: chezmoi re-add ~/.config/backups/plists/

set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

plists=(
  com.stonerl.Thaw
  com.lwouis.alt-tab-macos
  com.knollsoft.Hyperkey
)

for domain in "${plists[@]}"; do
  defaults export "$domain" "$DIR/$domain.plist"
  echo "✓ $domain"
done

echo "Done. Run: chezmoi re-add ~/.config/backups/plists/"
