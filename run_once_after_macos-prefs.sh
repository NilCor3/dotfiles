#!/bin/sh
# Imports macOS app preferences from chezmoi-managed plist files.
# This script runs once automatically on each new machine after chezmoi apply.
# To re-run it (e.g. after updating plists), rename or touch the file to
# change its hash, or run: chezmoi state delete-bucket --bucket=scriptState

PREFS_DIR="$HOME/.config/macos-prefs"

echo "Importing macOS preferences..."

defaults import com.lwouis.alt-tab-macos "$PREFS_DIR/com.lwouis.alt-tab-macos.plist"
defaults import com.knollsoft.Hyperkey   "$PREFS_DIR/com.knollsoft.Hyperkey.plist"
defaults import com.jordanbaird.Ice      "$PREFS_DIR/com.jordanbaird.Ice.plist"
defaults import eu.exelban.Stats         "$PREFS_DIR/eu.exelban.Stats.plist"

echo "Done. You may need to restart affected apps for changes to take effect."
