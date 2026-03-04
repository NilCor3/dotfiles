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
   F                  open 80x80% float shell

 PANE MOVEMENT
   { / }              swap pane with prev / next
   o                  rotate panes in window
   Space              cycle layout (horiz <> vert <> tiled ...)
   J                  move pane to another window (fzf picker)
   b                  break pane to new window
   r                  resize mode: hjkl = fine, HJKL = coarse
                        = even layout  |  Esc / r to exit

 WINDOWS
   n                  new window
   x                  close window
   [  /  ]            previous / next window
   1 - 9              go to window N

 RENAME
   R                  rename window
   P                  rename pane (shown in pane border)

 SESSIONS
   p                  project picker
                        dev    -> workspace -> repo -> dev-<repo>
                        shell  -> prompt name (default: shell-N)
                        ai     -> folder picker -> ai-<folder> + copilot
   W                  session tree (switch / kill / rename)
   g                  lazygit at session root
   d                  detach

 COPY
   e                  enter copy mode  (vi keys)
                        v = select  |  C-v = block  |  y = yank  |  q = exit

 OTHER
   ?                  this help  (q to close)
   Alt+r              reload config

EOF
