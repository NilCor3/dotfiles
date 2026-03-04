#!/bin/sh
# move-pane.sh — fzf picker to move current pane to another window or break to new
# Usage: called from tmux bind J

FZF_OPTS='--height=50% --border=rounded --color=bg+:#3c3836,fg+:#ebdbb2,hl+:#d79921,border:#504945,prompt:#458588,pointer:#d79921 --no-info'

# Build list: existing windows across all sessions + "new window" option
options="new window"
while IFS= read -r line; do
  options="$options
$line"
done << EOF
$(tmux list-windows -a -F "#S:#I  #W" 2>/dev/null | sort)
EOF

choice=$(printf '%s\n' "$options" | eval fzf $FZF_OPTS --prompt='"move pane to > "')
[ -z "$choice" ] && exit 0

if [ "$choice" = "new window" ]; then
  tmux break-pane
else
  target=$(printf '%s' "$choice" | awk '{print $1}')
  tmux join-pane -t "$target"
fi
