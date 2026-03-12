#!/bin/sh
# hx-yazi.sh — The "No-Typing" Buffer Version

BUFFER="$1"
MISE="/opt/homebrew/bin/mise"
CHOOSER="$HOME/.yazi-chooser.txt"
HELIX_PANE=$(tmux display-message -p '#{pane_id}')

[ -f "$BUFFER" ] && DIR=$(dirname "$BUFFER") || DIR=$(pwd)

# 1. Open Yazi
YAZI_PANE=$(tmux split-window -h -p 80 -c "$DIR" -P -F "#{pane_id}" "$MISE exec -- yazi --chooser-file='$CHOOSER'")

# 2. Wait for Yazi to exit
while tmux has-session -t "$YAZI_PANE" 2>/dev/null; do
  sleep 0.05
done

# 3. Focus Helix and "Reset" the editor state
tmux select-pane -t "$HELIX_PANE"
# We send Escape and wait a tiny bit to ensure Helix exits Insert Mode
tmux send-keys -t "$HELIX_PANE" Escape Escape
sleep 0.05

# 4. Process the selection
if [ -s "$CHOOSER" ]; then
  while IFS= read -r file || [ -n "$file" ]; do
    [ -z "$file" ] && continue
    
    # Put ONLY the path in the buffer
    tmux set-buffer "${file}"
    
    # ── THE COMMAND SEQUENCE ──
    # 1. Send ":" to enter command mode
    # 2. Send "open " string
    # 3. Paste the buffer (the path)
    # 4. Send "Enter"
    tmux send-keys -t "$HELIX_PANE" ":" "open "
    tmux paste-buffer -p -t "$HELIX_PANE"
    tmux send-keys -t "$HELIX_PANE" Enter
  done < "$CHOOSER"
fi
