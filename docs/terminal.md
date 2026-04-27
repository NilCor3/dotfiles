# Terminal & Shell

## Shell

### Zsh + Zinit

Plugin manager: [Zinit](https://github.com/zdharma-continuum/zinit)

Key plugins: `fzf-tab`, `fast-syntax-highlighting`, `zsh-autosuggestions`, `zsh-vi-mode`, `atuin` (history), `navi` (cheatsheets), `zoxide`, `powerlevel10k` (prompt).

### bat

**[bat](https://github.com/sharkdp/bat)** (mise) — `cat` with syntax highlighting and line numbers. Used automatically in all fzf previews (`nf`, `nft`, `fhx`, etc.).

```sh
bat file.rs                        # syntax-highlighted file view
bat -l json file.json              # explicit language
xh api.example.com | bat -l json   # pipe with language hint
```

---

## Terminal & Multiplexer

### WezTerm

Config at `~/.config/wezterm/wezterm.lua`. GPU-accelerated terminal emulator only — fonts, window, clipboard. Pane/tab management handled by tmux.

#### Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+-` / `Ctrl++` | Decrease / increase font size |
| `CMD+c` / `CMD+v` | Copy / paste |
| `Shift+Up/Down` | Scroll to previous / next shell prompt |
| `Ctrl+Shift+j/k` | Scroll WezTerm viewport down/up 1 line |
| `Ctrl+Shift+d/u` | Scroll WezTerm viewport down/up half page |

No plugins, no leader key, no pane management — that's all tmux.

### tmux

tmux runs **inside** WezTerm (auto-started from `.zshrc` when inside a WezTerm pane via `~/.config/tmux/scripts/picker.sh`). Handles all panes, windows, sessions.

Config: `~/.config/tmux/tmux.conf`

#### Design: zero conflicts with Helix

**Leader: `Ctrl+Space`** — all keybinds are triggered after the prefix, so no conflicts with Helix or shell.

Sub-keys **mirror Helix's `Ctrl+w` window mode** exactly:

| Key | Action |
|-----|--------|
| `Ctrl+Space h/j/k/l` | Navigate panes |
| `Ctrl+Space w` | Focus next pane |
| `Ctrl+Space v` | Vertical split |
| `Ctrl+Space s` | Horizontal split |
| `Ctrl+Space q` | Close pane |
| `Ctrl+Space z` | Zoom / fullscreen toggle |
| `Ctrl+Space F` | New 80%×80% floating shell (display-popup) |
| `Ctrl+Space n / x` | New window / close window |
| `Ctrl+Space [ / ]` | Previous / next window |
| `Ctrl+Space b` | Break pane → new window |
| `Ctrl+Space 1-9` | Go to window N |
| `Ctrl+Space r` | Sticky resize mode (h/j/k/l = fine, H/J/K/L = coarse, Esc to exit) |
| `Ctrl+Space R` | Rename window |
| `Ctrl+Space P` | Rename pane (shown in pane border) |
| `Ctrl+Space e` | vi copy mode (v=select, C-v=block, y=yank) |
| `Ctrl+Space p` | Project picker (fzf: layout → workspace → repo → session) |
| `Ctrl+Space g` | Lazygit popup |
| `Ctrl+Space G` | AI commit (staged diff → ollama → commit/edit/cancel) |
| `Ctrl+Space Q` | pgcli popup |
| `Ctrl+Space d` | Detach |
| `Ctrl+Space ?` | Show keybind help popup |

#### Session naming

Sessions are named `<workspace>-<repo>` — e.g. `dev-hx-gotest`, `source-blink`.

#### Layouts

Layouts live in `~/.config/tmux/layouts/`. Selected via the `p` picker:

| Layout | Description |
|--------|-------------|
| `dev` | Helix 70% top, two shells side-by-side in 30% bottom |
| `shell` | Single named shell session |
| `ai` | GitHub Copilot CLI session |
| `dotfiles` | Copilot CLI at chezmoi source dir |
| `notes` | 2-window notes workspace (see [Notes & Todos](#notes--todos)) |

---

## Workflows

### Start a New Project Session

1. Open WezTerm (auto-starts tmux via `.zshrc`)
2. `Ctrl+Space p` → project picker appears
3. Select `dev` layout → enter project path (e.g. `~/dev/tn`)
4. Layout creates: Helix 70% top, two shells side-by-side 30% bottom
5. Session is named `dev-tn` automatically
6. Next time: `Ctrl+Space p` → select existing session to reattach

### Test-Driven Development Pane Setup

1. In your project session: `Ctrl+Space v` → vertical split
2. Left pane: `hx .` to edit code
3. Right pane: run your test watcher (`gwa` for Go, `bac` for Rust)
4. `Ctrl+Space s` in right pane → horizontal split for a shell
5. Navigate: `Ctrl+Space h/j/k/l` between panes
6. Need more space: `Ctrl+Space z` to zoom current pane, again to unzoom
7. Quick lazygit: `Ctrl+Space g` → popup, doesn't disrupt layout
