#!/bin/sh
# Install yazi flavors (external git repos, not tracked by chezmoi directly)
# Runs whenever this script changes (update the comment below to force a re-run)
# Version: 1

set -e

FLAVORS_DIR="$HOME/.config/yazi/flavors"
mkdir -p "$FLAVORS_DIR"

# gruvbox-dark flavor
GRUVBOX_DIR="$FLAVORS_DIR/gruvbox-dark.yazi"
if [ -d "$GRUVBOX_DIR" ]; then
    echo "yazi: gruvbox-dark.yazi already installed, updating..."
    git -C "$GRUVBOX_DIR" pull --quiet
else
    echo "yazi: installing gruvbox-dark.yazi..."
    git clone --quiet https://github.com/gmvar/gruvbox-dark.yazi "$GRUVBOX_DIR"
fi

echo "yazi: flavors OK"
