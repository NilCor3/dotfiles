#!/bin/sh
# Open tig blame in a Zellij floating pane
zellij action new-pane --floating --close-on-exit \
  --width "80%" --height "80%" --x "10%" --y "10%" \
  -- tig blame "$1" +"$2"
