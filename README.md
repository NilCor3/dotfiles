# NilCor3's Mac Setup

> A terminal-first, keyboard-driven macOS development environment.
> Everything is version-controlled, reproducible, and fast.

This repo contains my personal dotfiles and machine setup — managed with [chezmoi](https://chezmoi.io),
secrets encrypted with [age](https://age-encryption.org), and built around the philosophy that
the best tools are ones you can configure, compose, and own.

> [!NOTE]
> These dotfiles are maintained with the help of [GitHub Copilot](https://github.com/features/copilot) as an AI pair programmer. Scripts, configs, and documentation in this repo may have been authored or refined through AI-assisted sessions.

---

## Documentation

Each area has its own doc with full reference and workflow scenarios:

| Doc | What's inside |
|-----|---------------|
| [Editors](docs/editors.md) | Helix (custom fork + LSP) · Neovim (lazy.nvim, native LSP) · keybindings · hx-gotest |
| [Terminal & Shell](docs/terminal.md) | Zsh + Zinit · WezTerm · tmux keybindings & layouts |
| [Git](docs/git.md) | Config · aliases · forgit (fzf) · merge conflict workflow |
| [Dev Tools](docs/dev-tools.md) | Go (air, gotestsum, dlv) · Rust (bacon, nextest) · TypeScript · JSON/YAML |
| [HTTP, DB & Kafka](docs/http-and-data.md) | xh · httpyac · hurl · prism · pgcli · kcat · kaskade |
| [Notes & Todos](docs/notes-and-todos.md) | Plain markdown notes · tn CLI (`t`/`n`) · MCP server · auto-sync |
| [AI Tools](docs/ai.md) | Copilot CLI (agents, skills, MCP) · Claude Code |
| [macOS](docs/macos.md) | AeroSpace · apps · backup/restore · system utilities |

---

## Features

- 🖥️ **[WezTerm](https://wezfurlong.org/wezterm/)** — GPU-accelerated terminal (fonts, window, clipboard)
- ✏️ **[Helix](https://helix-editor.com/)** — modal editor with full LSP support; custom fork with inline completion
- ⌨️ **[Neovim](https://neovim.io/)** — lean nvim 0.12 setup with lazy.nvim; native LSP, blink.cmp, Copilot
- 🗂️ **[tmux](docs/terminal.md)** — multiplexer with vi copy mode, sessions, and Helix-mirrored keybinds
- 🔍 **[Helix integration](docs/editors.md#helix-integration)** — blame, lazygit, markdown preview, test runner via tmux
- 🧪 **[hx-gotest](docs/editors.md#hx-gotest--hx-rusttest)** — custom Go AST tool to run exact test under cursor
- 🔐 **Age-encrypted secrets** — key stored at `~/.config/age/chezmoi-key.txt`
- 📦 **[mise](https://mise.jdx.dev)** — polyglot runtime manager (Go, Node, Java, Python, Rust tools)
- 🐚 **Zsh + Zinit** with curated plugins, aliases, and `navi` cheatsheet
- 📝 **[tn](docs/notes-and-todos.md)** — Go CLI for notes & todos with MCP server and auto-sync
- 🤖 **[AI tools](docs/ai.md)** — Copilot CLI (10 agents, 3 skills), Claude Code
- 🍎 **macOS defaults** applied via reproducible shell script with drift detection

---

## Philosophy

**Configure, compose, own** — every tool exposes its internals as plain text, can be scripted, and doesn't lock you in.

**AI as a peer, not a replacement.** Context over magic — `AGENTS.md` files give agents explicit knowledge. AI works inside the tools (Copilot LSP in Helix, CLI in WezTerm). Own your prompts — agent configs are version-controlled dotfiles.

---

## Setup

```sh
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Bootstrap mise and chezmoi
brew install mise
mise use -g chezmoi age

# 3. Restore your age key before applying dotfiles
mkdir -p ~/.config/age
nano ~/.config/age/chezmoi-key.txt   # paste key contents

# 4. Create the chezmoi config file (not tracked by chezmoi itself)
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
encryption = "age"
[age]
  identity = "~/.config/age/chezmoi-key.txt"
  recipient = "age1lxxj3maqtemdtlgg0emp6xt4jp2kcljdgyr8w2fsw64exzl4mdes6slu75"

[git]
  autoCommit = true
  autoPush = true
EOF

# 5. Apply dotfiles
chezmoi init --apply git@github.com:NilCor3/dotfiles.git

# 6. Install all runtimes and dev tools
mise install

# 7. Install brew packages (see below)

# 8. Set up Copilot CLI (see docs/ai.md)
```

### Secrets

Secrets are encrypted with [age](https://age-encryption.org). Key at `~/.config/age/chezmoi-key.txt` — **never commit this**.

---

## Installation

### Brew Formulas

```sh
brew install \
  git-filter-repo \
  git-crypt \
  jdtls \
  lua-language-server \
  mise \
  neovim \
  mkcert \
  navi \
  rsync \
  tig \
  wget \
  markdown-oxide \
  usage \
  pgcli \
  postgres-language-server \
  slides \
  zoxide \
  forgit \
  procs \
  sd \
  massren \
  kcat \
  kaskade
```

> Most dev tools (go, node, java, python, etc.) are managed via **mise**, not brew.

### Brew Casks

```sh
brew install --cask \
  wezterm \
  raycast \
  hyperkey \
  nikitabobko/tap/aerospace \
  zen \
  bitwarden \
  bettermouse \
  docker-desktop \
  dbeaver-community \
  insomnia \
  pearcleaner \
  stats \
  utm \
  font-fira-mono-nerd-font \
  copilot-cli@prerelease

brew install \
  FelixKratz/formulae/borders
```

**App Store** (install manually):
- [TimeyMeet](https://apps.apple.com/app/timelyMeet/id1611090219) — meeting join buttons in menu bar
- [Keyboard Pilot](https://apps.apple.com/app/keyboard-pilot/id1496719023) — per-app keyboard shortcut routing

### Mise — Runtime Version Manager

All runtimes and dev tools are managed via [mise](https://mise.jdx.dev).
Global config: `~/.config/mise/config.toml`

---

## Dotfiles

Managed with [chezmoi](https://chezmoi.io). Source: `git@github.com:NilCor3/dotfiles.git` at `~/.local/share/chezmoi/`.

### Key files

| Path | Purpose |
|------|---------|
| `~/.zshrc` | Zsh config, plugins via Zinit, aliases |
| `~/.zshenv` | Environment variables for all shells |
| `~/.gitconfig` | Git config, delta pager, rebase defaults |
| `~/.config/mise/config.toml` | Global mise tools and environment |
| `~/.config/wezterm/wezterm.lua` | WezTerm config (GPU/fonts/window only) |
| `~/.config/tmux/tmux.conf` | tmux multiplexer config |
| `~/.config/helix/` | Helix editor config and LSP setup |
| `~/.config/nvim/` | Neovim config (lazy.nvim) |
| `~/.config/tn/config.toml` | Notes & todos CLI config |
| `~/.copilot/agents/` | 10 Copilot CLI agents |
| `~/.copilot/skills/` | 3 Copilot CLI skills |
| `~/.copilot/mcp-config.json` | MCP server configs |
| `~/.claude/commands/` | 4 Claude Code slash commands |

### Key commands

```sh
chezmoi add <file>          # start tracking a new file
chezmoi re-add <file>       # update source after editing directly
chezmoi edit <file>         # edit a tracked file via chezmoi (preferred)
chezmoi apply               # apply source state to home directory
chezmoi diff                # show pending changes
```

Auto-commit + auto-push are enabled — `chezmoi add` and `chezmoi re-add` automatically commit and push.

### What to NEVER add

- `~/.ssh/`, `~/.config/age/`, `~/.gnupg/` — private keys
- `~/.kube/` — cluster configs (may contain tokens)
- `~/.local/bin/` — compiled binaries (rebuild from source)
- Cache dirs: `~/.cache/`, `~/.zsh_history`, `.DS_Store`

### Directory conventions

- `~/dev/` — personal projects (git: jocke82karlsson@gmail.com)
- `~/source/` — work projects (git: joakim.karlsson@fortnox.se)
- `~/.local/bin/` — personal compiled binaries (e.g. `hx-gotest`, built from `~/dev/hx-gotest/`)
