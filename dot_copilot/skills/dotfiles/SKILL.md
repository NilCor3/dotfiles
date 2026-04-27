---
name: dotfiles
description: Manage home directory dotfiles tracked with chezmoi. Source repo at ~/.local/share/chezmoi/
---

You are helping manage a home directory tracked with [chezmoi](https://chezmoi.io).
Source repo: `github.com:NilCor3/dotfiles` (at `~/.local/share/chezmoi/`)

---

## Philosophy

**Configure** — Prefer plain-text, version-controllable config (TOML, Lua, YAML). macOS preferences captured in `run_once_after_macos-defaults.sh`.

**Compose** — Tools work together through small scripts, not monolithic plugins.

**Own** — No magic. chezmoi is transparent: source is a plain git repo, templates are readable.

### Practical implications

- **Prefer editing config files** over GUI extensions
- **Write small, single-purpose scripts** over large scripts
- **Avoid adding new tool dependencies** without asking — mise manages runtimes
- **New tool config belongs in chezmoi** — `chezmoi add` its config file
- **When you teach a useful command**, add it as a navi cheat to `~/.local/share/navi/cheats/personal.cheat` and `chezmoi re-add` it
- **Scripts live in** `~/.config/helix/scripts/` (Helix), `~/.config/nvim/bin/` (nvim), or `~/hx/` (general); compiled binaries in `~/.local/bin/`
- **Terminal > GUI** — WezTerm + tmux. Use `tmux display-popup` or `tmux split-window` in scripts
- **When adding secrets**, encrypt with age (`chezmoi encrypt`) — never commit plaintext credentials

---

## How chezmoi works here

- **Auto-commit + auto-push** are enabled — `chezmoi add` and `chezmoi re-add` automatically commit and push
- **Encryption**: secrets encrypted with [age](https://age-encryption.org). Key at `~/.config/age/chezmoi-key.txt`
- **Templates**: `.tmpl` files use chezmoi template syntax for machine-specific values

## Common commands

```sh
chezmoi add <file>          # Start tracking a new file
chezmoi re-add <file>       # Update after editing directly
chezmoi edit <file>         # Edit a tracked file (preferred)
chezmoi apply               # Apply source state to home
chezmoi diff                # Show pending changes
chezmoi execute-template < dot_foo/bar.tmpl  # Render a template manually
```

## What to NEVER add

- `~/.ssh/`, `~/.config/age/`, `~/.gnupg/` — keys
- `~/.kube/` — may contain tokens
- `~/.local/bin/` — compiled binaries (rebuild from source)
- Any file with hardcoded credentials

## ⚠️ Secret hygiene

```sh
grep -rni 'api.key\s*[:=]\|token\s*[:=]\|password\s*[:=]' <file>
grep -rn '://[^@\s]\+:[^@\s]\+@' <file>
```

## Directory layout

| Path | Content |
|------|---------|
| `~/.local/share/chezmoi/` | chezmoi source root |
| `dot_*` | maps to `~/.*` |
| `private_*` | chmod 600 files |
| `run_once_*` | scripts run once |
| `run_onchange_*` | scripts run when content changes |
| `*.tmpl` | chezmoi template files |

## Key configs

- Shell: `.zshrc`, `.zshenv`, `.zprofile`, `.zsh_plugins.txt`, `.p10k.zsh`
- Editors: `.config/helix/`, `.config/nvim/`
- Terminal: `.config/wezterm/`, `.config/tmux/`
- Window manager: `.config/aerospace/aerospace.toml`
- Git: `.gitconfig`, `.gitignore`, `.config/git/personal.gitconfig`
- Tools: `.config/mise/config.toml`, `.config/lazygit/config.yml`
- Copilot CLI: `.copilot/config.json`, `.copilot/agents/`, `.copilot/skills/`, `.copilot/mcp-config.json`
- Claude: `.claude/settings.json`, `.claude/commands/`
