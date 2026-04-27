# macOS

## System Utilities

### bottom

**[bottom](https://clementtsang.github.io/bottom/)** (`btm`, mise) — TUI process/system monitor.

```sh
btm        # open TUI monitor
btm -b     # basic mode (no graphs)
```

`dd` kill · `/` filter · `Tab` switch widget · `q` quit.

### procs

**[procs](https://github.com/dalance/procs)** (brew) — modern replacement for `ps` with color and better formatting.

```sh
procs              # list all processes
procs <name>       # filter by name
procs --tree       # process tree
```

### slides

**[slides](https://github.com/maaslalani/slides)** (brew) — render markdown as a terminal slideshow. Uses `---` as slide separator.

```sh
slides presentation.md
```

Arrow keys to navigate, `q` to quit.

### SSH

SSH agent provided by **Bitwarden desktop app**.

```sh
export SSH_AUTH_SOCK=~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
```

Set in `~/.zshrc`. Enable: Bitwarden → Settings → SSH Agent.

---

## macOS Apps

| App | Purpose | Config |
|-----|---------|--------|
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | i3-style tiling WM | `~/.config/aerospace/aerospace.toml` in chezmoi |
| [JankyBorders](https://github.com/FelixKratz/JankyBorders) | Focused window border highlight | launched by AeroSpace |
| [Raycast](https://raycast.com) | Launcher, replaces Spotlight | iCloud sync |
| [HyperKey](https://hyperkey.app) | Caps Lock → Hyper (⌃⌥⇧⌘) | plist backup |
| [Finicky](https://github.com/johnste/finicky) | Browser router | `~/.finicky.js` in chezmoi |
| [Zen](https://zen-browser.app) | Default browser (Firefox-based) | Firefox account sync |
| [Bitwarden](https://bitwarden.com) | Password manager + SSH agent | Cloud-synced vault |
| [BetterMouse](https://better-mouse.com) | Mouse customization | Export/Import |
| [Keyboard Pilot](https://apps.apple.com/app/keyboard-pilot/id1496719023) | Per-app keyboard routing | GUI only |
| [TimeyMeet](https://apps.apple.com/app/timelyMeet/id1611090219) | Meeting join buttons in menu bar | No config |
| [Docker Desktop](https://docker.com/products/docker-desktop) | Container runtime | Sensible defaults |
| [Stats](https://github.com/exelban/stats) | System stats in menu bar | GUI only |
| [PearCleaner](https://itsalin.com/appInfo/?id=pearcleaner) | App uninstaller | No config |
| [UTM](https://mac.getutm.app) | Virtual machines | No config |

---

## Backup & Restore

| App | Method | Location |
|-----|--------|----------|
| AeroSpace | chezmoi | `~/.config/aerospace/aerospace.toml` |
| Finicky | chezmoi | `~/.finicky.js` |
| Raycast | Export/Import | `~/.config/backups/raycast-settings.rayconfig` |
| BetterMouse | Export/Import | `~/.config/backups/bettermouse-settings.bms` |
| Bitwarden | Cloud-synced | Log in → enable SSH Agent |
| Zen | Firefox account | Sign in → reinstall extensions |
| HyperKey | plist script | `~/.config/backups/plists/com.knollsoft.Hyperkey.plist` |
| Docker Desktop | No backup | Reconfigure defaults |
| TimeyMeet | No config | Grant Calendar access |
| Keyboard Pilot | No export | Reconfigure per-app rules manually |

Plist backup/restore:
```sh
~/.config/backups/plists/backup-plists.sh   # export → chezmoi re-add ~/.config/backups/plists/
~/.config/backups/plists/restore-plists.sh  # import (fresh install)
```

---

## AeroSpace

i3-style tiling WM. Config in `~/.config/aerospace/aerospace.toml`.

First launch: Accessibility permission required. Run `aerospace list-monitors` and `aerospace list-apps` to verify monitor/bundle IDs match the config.

**Modifier (Hyper):** Caps Lock via HyperKey → `⌃⌥⇧⌘`

| Action | Shortcut |
|--------|----------|
| Focus window | Hyper + H/J/K/L |
| Move window | Cmd+Ctrl+Alt + H/J/K/L |
| Switch workspace | Hyper + 1–9 |
| Move to workspace | Cmd+Ctrl+Alt + 1–9 |
| macOS native fullscreen | Hyper + F |
| Toggle float/tile | Hyper + Space |
| Resize mode | Hyper + R |
| Reload config | Hyper + C |

**Workspaces:** 1=dev · 2=test · 3=ide · 4=extra · 5=misc (main monitor) | 6=browser · 7=extra · 8=misc (left monitor) | 9=laptop

**App assignments:** WezTerm→1, Chrome/Firefox/Safari→2, IntelliJ→3, Zen→6, Slack/WA/Discord/Spotify→9, unassigned→misc workspace for current monitor

---

## Finicky

Rules: default browser = Zen · http → https redirect · `localhost*`, `*curseforge.com`, `*overwolf.com` → Chrome (Profile 1).

First launch: grant permission to set itself as default browser.

---

## macOS Defaults

Settings are stored as `defaults write` commands in:

```sh
~/.local/share/chezmoi/run_once_after_macos-defaults.sh
```

Edit and run `chezmoi apply` — changing the file content triggers chezmoi to re-run it.

---

## Workflows

### Fresh Machine Restore

1. Install Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. `brew install mise` → `mise use -g chezmoi age`
3. Restore age key: paste into `~/.config/age/chezmoi-key.txt`
4. Create chezmoi config: `~/.config/chezmoi/chezmoi.toml` with age settings
5. `chezmoi init --apply git@github.com:NilCor3/dotfiles.git`
6. `mise install` → all runtimes
7. Install brew packages (formulas + casks from Installation section)
8. Grant permissions: AeroSpace (Accessibility), Finicky (default browser)
9. `aerospace list-monitors` → verify workspace-to-monitor mapping
10. Sign in: Bitwarden (SSH agent), Zen (Firefox account), Raycast (iCloud)

### AeroSpace Workspace Management

1. Hyper key = Caps Lock (via HyperKey app)
2. `Hyper+1` → dev workspace (WezTerm), `Hyper+6` → browser (Zen), `Hyper+9` → laptop (Slack/Spotify)
3. Move window: `Cmd+Ctrl+Alt+3` → send to IDE workspace
4. `Hyper+h/j/k/l` → focus windows within workspace
5. `Hyper+f` → fullscreen, `Hyper+Space` → toggle float
6. `Hyper+r` → resize mode, then h/j/k/l to resize

### Check System Health

1. `btm` → full TUI monitor (CPU, memory, disk, network, processes)
2. `procs java` → find all Java processes quickly
3. `procs --tree` → see process hierarchy
4. `btm -b` → basic mode for quick glance
