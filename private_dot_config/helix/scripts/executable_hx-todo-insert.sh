#!/bin/sh
# Emits a new todo checkbox line prefix — only for .md files.
# Used by Helix :insert-output so it inserts at cursor position.
case "$1" in
  *.md) printf '\n- [ ] ' ;;
esac
