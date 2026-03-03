#!/bin/sh
# Open tig blame in a floating pane
if [ -n "$TMUX" ]; then
  tmux display-popup -E -w 80% -h 80% -b rounded -s "fg=#d79921" tig blame "$1" +"$2"
else
  zellij action new-pane --floating --close-on-exit \
    --width "80%" --height "80%" --x "10%" --y "10%" \
    -- tig blame "$1" +"$2"
fi
