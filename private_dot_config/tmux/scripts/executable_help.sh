#!/bin/sh
# help.sh — show tmux keybinds (prefix: Ctrl+Space)
cat << 'EOF' | less -r
 ╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
 │                                          tmux  —  prefix: Ctrl+Space                                                        │
 ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

 LEADER KEYBINDS                                         │  RESIZE MODE  (prefix + r)
 ───────────────────────────────────────────────────     │  ─────────────────────────────────────────────────────────────────
 PANES                         WINDOWS                   │    h / j / k / l    resize fine     (3 cells)
   h / j / k / l  navigate       n    new window         │    H / J / K / L    resize coarse  (10 cells)
   w              next pane       x    close window       │    =                even layout
   v              split right     [ ]  prev / next        │    Esc  /  r        exit resize mode
   s              split down      1-9  go to window N
   q              close pane      b    break to window    │  COPY MODE  (prefix + e)
   z              zoom toggle     R    rename window      │  ─────────────────────────────────────────────────────────────────
   F              float shell     P    rename pane        │    v                begin selection
                                                          │    C-v              rectangle (block) toggle
 PANE MOVEMENT                  SESSIONS                  │    y                yank selection + exit
   { / }          swap prev/next  p    project picker     │    / or ?           search forward / backward
   C-h/j/k/l      swap in dir     W    session tree       │    n / N            next / prev search match
   o              rotate panes    g    lazygit             │    arrow keys       scroll
   Space          cycle layout    d    detach              │    q  /  Esc        exit copy mode
   J              move (fzf)      ?    this help
                                  Alt+r  reload config    │  SESSION TREE  (prefix + W)
                                                          │  ─────────────────────────────────────────────────────────────────
                                                          │    Enter            switch to session / window / pane
                                                          │    x                kill selected item
                                                          │    r                rename selected item
                                                          │    s / w            collapse / expand node
                                                          │    q  /  Esc        exit session tree
                                                          │
                                                          │  PROJECT PICKER  (prefix + p)
                                                          │  ─────────────────────────────────────────────────────────────────
                                                          │    dev    ->  workspace -> repo -> dev-<repo>
                                                          │    shell  ->  prompt name (default: shell-N)
                                                          │    ai     ->  folder picker -> ai-<folder> + copilot

EOF
