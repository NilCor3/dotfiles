#!/bin/sh
# help.sh — show tmux keybinds (prefix: Ctrl+Space)
cat << 'EOF' | less -r
 ╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
 │                                                   tmux  —  prefix: Ctrl+Space                                                │
 ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

 LEADER KEYBINDS                                                  │  RESIZE MODE  (prefix + r)
 ──────────────────────────────         ─────────────────────     │  ───────────────────────────────────────────────────────
 PANES                                  WINDOWS                   │    h / j / k / l    resize fine     (3 cells)
   h / j / k / l  navigate                n    new window         │    H / J / K / L    resize coarse  (10 cells)
   C-h/j/k/l      navigate (ctrl alias)   x    close window       │    =                even layout
   w              next pane               [ ]  prev / next        │    Esc  /  r        exit resize mode
   v              split right             1-9  go to window N     │
   V              split full right                                │
   s              split down              b    break to window    │  MOVE MODE  (prefix + M)
   S              split full below        R    rename window      │  ───────────────────────────────────────────────────────
   q              close pane              P    rename pane        │    h / j / k / l    swap pane in direction
   z              zoom toggle                                     │    Esc  /  M        exit move mode
   e              copy mode               SESSIONS                │
   F              float shell             p    project picker     │  COPY MODE  (prefix + e)
                                          W    session tree       │  ───────────────────────────────────────────────────────
 PANE MOVEMENT                           g    lazygit             │    v                begin selection
   { / }          swap prev/next          G    AI commit          │    C-v              rectangle (block) toggle
   M → h/j/k/l   swap in dir (move mode) Q    pgcli               │    y                yank selection + exit
   o              rotate panes            d    detach             │    / or ?           search forward / backward
   Space          cycle layout            ?    this help          │    n / N            next / prev search match
   J              move (fzf)              Alt+r  reload config    │    arrow keys       scroll
   m              mark pane                                       │    q  /  Esc        exit copy mode
   M-j / M-k      join marked full-width↓↑                        │
                                                                  │  SESSION TREE  (prefix + W)
                                                                  │  ───────────────────────────────────────────────────────
                                                                  │    Enter            switch to session / window / pane
                                                                  │    x / X            kill selected / kill tagged
                                                                  │    + / -            expand / collapse
                                                                  │    M-+ / M--        expand all / collapse all
                                                                  │    S-Up / S-Down    swap window up / down
                                                                  │    O / r            change sort field / reverse sort
                                                                  │    v                toggle preview
                                                                  │    C-s / n / N      search / next / prev
                                                                  │    t / C-t          tag item / tag all
                                                                  │    q                exit
                                                                  │
                                                                  │  : commands (press : on selected/tagged item)
                                                                  │    rename-session <name>
                                                                  │    rename-window <name>
                                                                  │    move-window -t <session>:
                                                                  │
                                                                  │  PROJECT PICKER  (prefix + p)
                                                                  │  ───────────────────────────────────────────────────────
                                                                  │    dev    ->  workspace -> repo -> dev-<repo>
                                                                  │    shell  ->  prompt name (default: shell-N)
                                                                  │    ai     ->  folder picker -> ai-<folder> + copilot
EOF
