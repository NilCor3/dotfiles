#!/bin/sh
# Finds the WezTerm pane running Helix (hx).
# Prints the pane_id to stdout.
# Usage: pane_id=$(wezterm-find-hx.sh)
# Optional: pass --same-tab to restrict to the current tab only.

same_tab=0
[ "$1" = "--same-tab" ] && same_tab=1

json=$(wezterm cli list --format json 2>/dev/null)

python3 -c "
import json, os, subprocess

panes = json.loads('''$json''')
current = int(os.environ.get('WEZTERM_PANE', -1))
same_tab = $same_tab

current_tab = next((p['tab_id'] for p in panes if p['pane_id'] == current), None)

candidates = []
for p in panes:
    if same_tab and p['tab_id'] != current_tab:
        continue
    if p['pane_id'] == current:
        continue

    title = p.get('title', '')
    tty = p.get('tty_name', '')

    # Primary: title is 'hx' (set by helix itself)
    if title == 'hx':
        candidates.append((0, p['pane_id']))
        continue

    # Fallback: check foreground process on the tty
    if tty:
        try:
            result = subprocess.run(
                ['ps', '-t', tty.replace('/dev/', ''), '-o', 'comm='],
                capture_output=True, text=True
            )
            procs = result.stdout.strip().splitlines()
            if any(proc.strip() in ('hx', 'helix') for proc in procs):
                candidates.append((1, p['pane_id']))
        except Exception:
            pass

if candidates:
    candidates.sort()
    print(candidates[0][1])
"
