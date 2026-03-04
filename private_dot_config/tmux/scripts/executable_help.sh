#!/bin/sh
# help.sh — show tmux keybinds (prefix: Ctrl+Space)
cat << 'EOF' | less -r
 ╭─────────────────────────────────────────────────────╮
 │           tmux keybinds  (prefix: Ctrl+Space)       │
 ╰─────────────────────────────────────────────────────╯

 PANES
   h / j / k / l     navigate panes
   w                  next pane
   v                  vertical split
   s                  horizontal split
   q                  close pane
   z                  zoom / unzoom pane
   F                  open 80×80% float shell
   r                  enter resize mode (hjkl = fine, HJKL = coarse)
                        = even layout  │  Esc / r to exit

 WINDOWS
   n                  new window
   x                  close window
   [  /  ]            previous / next window
   1 – 9              go to window N
   b                  break pane into new window

 RENAME
   R                  rename window
   P                  rename pane (shown in pane border)

 SESSIONS
   p                  project picker (fzf → new/switch session)
   g                  lazygit at project root
   d                  detach

 COPY
   e                  enter copy mode  (vi keys)
                        v = select  │  C-v = block  │  y = yank

 OTHER
   ?                  this help  (q to close)
   Alt+r              reload config

EOF
