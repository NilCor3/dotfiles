# Dotfiles Management

This home directory is managed with [chezmoi](https://chezmoi.io).
Source repo: `github.com:NilCor3/dotfiles` (at `~/.local/share/chezmoi/`)

---

## Philosophy

> **The best tools are ones you can configure, compose, and own.**

This setup is built around that principle. Every tool was chosen because it exposes its internals through plain text config, can be scripted and connected to other tools, and doesn't lock you into a GUI or a vendor.

**Configure** — Prefer tools with plain-text, version-controllable config (TOML, Lua, YAML, KDNL) over GUI-only preferences. If a setting can't be expressed as a file in this repo, it's a second-class citizen. macOS system preferences are captured in `run_once_after_macos-defaults.sh` for the same reason.

**Compose** — Tools should work together through scripts, not monolithic plugins. The Helix integration (lazygit, test runner, blame) is a set of small shell scripts that wire Zellij panes together. `hx-gotest` is a small Go binary that understands Go AST — it does one thing and feeds output back through the shell. Each piece is replaceable.

**Own** — No magic. No framework that "manages" things on your behalf in ways you can't inspect. chezmoi is transparent: the source is a plain git repo, templates are readable, encryption keys are yours. If chezmoi disappeared tomorrow you'd still have all your configs.

### Practical implications for agents

When helping with this setup, apply the same principles:

- **Prefer editing config files** over installing GUI extensions or plugins with their own update mechanisms
- **Write small, single-purpose scripts** rather than one large script that does everything
- **Avoid adding new tool dependencies** without asking — mise manages runtimes, and adding a tool has real cost
- **New tool config belongs in chezmoi** — if you configure a new tool, `chezmoi add` its config file
- **When you teach the user a useful command**, add it as a navi cheat to `~/.local/share/navi/cheats/personal.cheat` and `chezmoi re-add` it. Cheats are grouped by `% topic, subtopic` headers; each entry is a `# Description` comment followed by the command on the next line. Use `<placeholder>` for variable parts.
- **Scripts live in `~/.config/helix/scripts/`** (for editor integration) or `~/hx/` (for general helpers), compiled binaries in `~/.local/bin/`
- **Don't reach for a framework** when a shell script will do — composability over abstraction
- **Terminal > GUI** — if a terminal-native option exists for a task, prefer it (lazygit over a Git GUI, helix over VS Code). WezTerm is the GPU terminal emulator; tmux handles all pane/window/session management — use `tmux display-popup` or `tmux split-window` in scripts rather than WezTerm Lua APIs.
- **Merge conflicts** — standard git 3-way merge with `zdiff3` conflict style. Resolve with lazygit (`e` on conflicted file → Helix for manual edits). Do not suggest separate merge driver tools.
- **When adding secrets**, encrypt with age (`chezmoi encrypt`) — never commit plaintext credentials

---

## Todo system

Todos live in `~/notes/todos/` as plain GFM markdown. Files: `inbox.md`, `work.md`, `dev.md`, `personal.md`, `someday.md`.

Format: `- [ ] Task text #tag project:name`

Shell functions (defined in `.zshrc`, use `$TODOS_DIR`):
- `ta [text]` — append to inbox; no args opens inbox in Helix
- `tl` — fzf list of open todos → opens in Helix pane (detects `notes:todos` session)
- `td` — mark done via fzf (comments out the line)
- `tp [file]` — open a todo file
- `tg <tag>` — filter by tag

Helix keybind `Alt+t` (normal + insert mode): inserts `- [ ] ` on new line below cursor in `.md` files only. Script: `~/.config/helix/scripts/hx-todo-insert.sh`.

tmux `notes` layout: 2-window session. `todos` window = Helix + tl pane + shell. `tl` sends `:open file:line` to `notes:todos.1` (helix pane).

---

## How chezmoi works here

- **Auto-commit + auto-push** are enabled — `chezmoi add` and `chezmoi re-add` automatically commit and push to GitHub
- **Encryption**: secrets are encrypted with [age](https://age-encryption.org). The age key lives at `~/.config/age/chezmoi-key.txt` (backed up in Bitwarden)
- **Templates**: `.tmpl` files in the source use chezmoi template syntax for machine-specific values

## Common commands

```sh
chezmoi add <file>          # Start tracking a new file
chezmoi re-add <file>       # Update chezmoi source after editing the file directly
chezmoi edit <file>         # Edit a tracked file via chezmoi (preferred)
chezmoi apply               # Apply source state to home directory
chezmoi diff                # Show pending changes
chezmoi status              # Show which files differ
chezmoi unmanaged           # Show files in home not tracked by chezmoi
chezmoi encrypt <file>      # Encrypt a file with age before adding
```

## Adding a new file

```sh
chezmoi add ~/.config/something/config
# Commits and pushes automatically
```

For secret files:
```sh
chezmoi encrypt ~/.config/something/secret > ~/.local/share/chezmoi/private_dot_config/something/encrypted_secret.age
chezmoi add ~/.config/something/secret   # or manually place the .age file in source
```

## What is managed

Key configs tracked in chezmoi:
- Shell: `.zshrc`, `.zshenv`, `.zprofile`, `.zsh_plugins.txt`, `.p10k.zsh`
  - Shell aliases (git, go, cargo, etc.) are defined directly in `.zshrc`
- Editor: `.config/helix/` (config, languages, scripts)
- Terminal + multiplexer: `.config/wezterm/` (GPU terminal, fonts, window only) and `.config/tmux/` (panes, windows, sessions, layouts, picker)
- Git: `.gitconfig`, `.gitignore`, `.gitattributes`, `.config/git/personal.gitconfig`
- Tools: `.config/mise/config.toml`, `.config/lazygit/config.yml`, `.config/pgcli/config`
- Misc: `.finicky.js`, `.ideavimrc`, `.yarnrc`, `README.md`
- Scripts: `diff-macos-defaults.sh`, `hx/`
- Per-folder agent instructions: `dev/AGENTS.md`, `source/AGENTS.md`
- Navi cheats: `.local/share/navi/cheats/personal.cheat`
- GitHub Copilot CLI: `.copilot/config.json`, `.copilot/mcp-config.json`, `.copilot/agents/`
- Legacy (not actively used): `.config/ghostty/`, `.config/zellij/`

## What to NEVER add

- `~/.ssh/` — private keys
- `~/.config/age/` — the age encryption key itself
- `~/.gnupg/` — GPG keys
- `~/.kube/` — cluster configs (may contain tokens)
- `~/.netrc`, `~/.env.secrets` — credentials
- `~/.local/bin/` — compiled binaries (rebuild from source)
- Cache/runtime dirs: `~/.cache/`, `~/.local/share/` (most), `~/.zsh_history`, `.DS_Store`

## Folder layout conventions

- `~/dev/` — personal projects (git uses `jocke82karlsson@gmail.com`)
- `~/source/` — work projects (git uses `joakim.karlsson@fortnox.se`)
- `~/.local/bin/` — personal compiled binaries (e.g. `hx-gotest`, built from `~/dev/hx-gotest/`)

---

## Helix AI inline completion (`ollama-lsp`)

The inline completion (ghost text) feature in Helix is handled by a custom Rust
LSP server at `~/dev/ollama-lsp/`. Key facts:

- Binary: `~/.local/bin/ollama-ls` (build with `make install` in the project dir)
- Config: `~/.config/helix/languages.toml` — uses **absolute path** for `command`
  because Helix does not inherit the shell's PATH
- The server uses `raw: true` in the ollama API call to bypass the chat template
  and pass FIM tokens directly to the model
- `only-features = ["inline-completion"]` is required in each language's
  `language-servers` list so Helix sends `didOpen`/`didChange` to the server
- **Toggle** between ollama and Copilot via navi ("Toggle inline AI") — requires
  a full `hx` restart (`:lsp-restart` alone is not enough)
- Logs go to stderr; Helix captures them in `~/.cache/helix/helix.log`
- Model: `qwen2.5-coder:7b` (default, override with `OLLAMA_MODEL` env var)

When modifying the LSP server:
1. Edit `~/dev/ollama-lsp/src/`
2. Run `cargo test` — 60+ unit and integration tests
3. `make install` to deploy
4. Restart `hx` to pick up the new binary

---

## tmux keybinding conventions

Leader key is `Ctrl+Space`. All bindings require the prefix first.

Key patterns to know when modifying tmux config:
- **Pane nav**: `h/j/k/l` → select-pane direction
- **Splits**: `v` (right), `s` (down), `q` (close)
- **Move/resize**: `H/J/K/L` in resize mode (entered with `r`, exit with Esc)
- **Zoom**: `z` → resize-pane -Z
- **Float**: `F` → display-popup 80%×80%
- **Windows**: `n` (new), `x` (close), `[`/`]` (prev/next), `1-9` (direct), `b` (break pane)
- **Resize mode** (sticky): `r` → h/j/k/l fine, H/J/K/L coarse, Esc to exit
- **Copy mode**: `e` → vi copy (v select, C-v block, y yank)
- **Session/picker**: `g` → lazygit popup (project root), `p` → fzf session/layout picker
- **AI commit**: `G` → tmux popup: generates commit message from staged diff via ollama, offers commit/edit/cancel
- **Rename**: `R` window, `P` pane (shown in pane border top)
- **Detach**: `d`
- **Help**: `?` → popup with all bindings

In Helix integration scripts, detect `$TMUX` (set by tmux) for the tmux branch:
- Floats: `tmux display-popup -E -w 80% -h 80% -b rounded -s "fg=#d79921" <cmd>`
- Persistent split: `tmux split-window -v -p 35` with `select-pane -T <name>` for reuse

Config files:
- `~/.config/tmux/tmux.conf` — all keybindings and settings
- `~/.config/tmux/layouts/dev.sh` — helix 70% top, 2 named shells 30% bottom
- `~/.config/tmux/scripts/picker.sh` — fzf session/project picker
- `~/.config/tmux/scripts/help.sh` — keybind help popup content

WezTerm is now terminal-only (GPU/fonts/window). Its keybinds:
- `Ctrl+-/+` font size, `CMD+c/v` clipboard, `Shift+Up/Down` scroll-to-prompt

Config files:
- `~/.config/wezterm/wezterm.lua` — main config (no plugins, no leader)
- `~/.config/wezterm/keybinds.lua` — 6 bare-minimum bindings
