#!/bin/sh
# Emits a todo checkbox prefix — only for .md files.
# Used by Helix :insert-output after open_below creates the new line.
case "$1" in
  *.md) printf '%s' '- [ ] ' ;;
esac
