# Dotfiles Management

This home directory is managed with [chezmoi](https://chezmoi.io).
Source repo: `github.com:NilCor3/dotfiles` (at `~/.local/share/chezmoi/`)

---

## Philosophy

> **The best tools are ones you can configure, compose, and own.**

This setup is built around that principle. Every tool was chosen because it exposes its internals through plain text config, can be scripted and connected to other tools, and doesn't lock you into a GUI or a vendor.

**Configure** — Prefer tools with plain-text, version-controllable config (TOML, Lua, YAML, KDNL) over GUI-only preferences. If a setting can't be expressed as a file in this repo, it's a second-class citizen. macOS system preferences are captured in `run_once_after_macos-defaults.sh` for the same reason.

**Compose** — Tools should work together through scripts, not monolithic plugins. The Helix integration (file explorer, lazygit, test runner) is a set of small shell scripts that wire WezTerm panes together. `hx-gotest` is a small Go binary that understands Go AST — it does one thing and feeds output back through the shell. Each piece is replaceable.

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
- **Terminal > GUI** — if a terminal-native option exists for a task, prefer it (lazygit over a Git GUI, yazi over Finder, helix over VS Code). WezTerm replaces both terminal emulator and multiplexer — use its pane/tab API in scripts rather than adding tmux or zellij.
- **Merge conflicts** — mergiraf fires automatically as a git merge driver for Go, Rust, Java, TypeScript, JSON, YAML etc. Do not suggest separate merge tools. For remaining conflicts: lazygit (`e` on conflicted file).
- **When adding secrets**, encrypt with age (`chezmoi encrypt`) — never commit plaintext credentials

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
- Terminal + multiplexer: `.config/wezterm/` (WezTerm handles both — panes, tabs, splits)
- Git: `.gitconfig`, `.gitignore`, `.gitattributes`, `.config/git/personal.gitconfig`
- Tools: `.config/mise/config.toml`, `.config/lazygit/config.yml`, `.config/pgcli/config`
- Misc: `.finicky.js`, `.ideavimrc`, `.yarnrc`, `README.md`
- Scripts: `diff-macos-defaults.sh`, `hx/`
- Per-folder agent instructions: `dev/AGENTS.md`, `source/AGENTS.md`
- Navi cheats: `.local/share/navi/cheats/personal.cheat`
- GitHub Copilot CLI: `.copilot/config.json`, `.copilot/mcp-config.json`, `.copilot/agents/`
- Legacy (not actively used): `.config/ghostty/`, `.tmux.conf`, `.config/zellij/`

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

## WezTerm keybinding conventions

LEADER key is `CTRL+SHIFT+Space` (timeout 1s). All pane/window management goes through LEADER.

Key patterns to know when modifying WezTerm config:
- **Pane zoom**: `LEADER z` → `TogglePaneZoomState` (current pane)
- **Pane collapse**: `LEADER a` → collapses pane to 1 row/col by growing a neighbor; navigate back and press again to restore. State stored in `wezterm.GLOBAL["ach_<id>"]` / `wezterm.GLOBAL["acr_<id>"]`. Logic inline in `keybinds.lua`.
- **Pane resize**: `ALT + h/j/k/l` → `AdjustPaneSize`
- **Passive scroll** (no mode): `CTRL+SHIFT+j/k` (line), `CTRL+SHIFT+d/u` (half-page)
- **Copy mode**: `LEADER c` — modal.wezterm provides vim-like copy with `x` for line select, `t` fixed to jump-forward
- **Scroll mode**: `LEADER y`

Config files:
- `~/.config/wezterm/wezterm.lua` — main config, plugin setup, `patch_copy_mode()` fix
- `~/.config/wezterm/keybinds.lua` — all keybindings (returned as table, loaded by wezterm.lua)

`CTRL+h/j/k/l` are intentionally **not** bound in WezTerm — they pass through to Helix/shell (e.g. `CTRL+h` = backspace in Helix insert mode).
