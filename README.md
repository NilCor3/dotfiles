# NilCor3's Mac Setup

> A terminal-first, keyboard-driven macOS development environment.
> Everything is version-controlled, reproducible, and fast.

This repo contains my personal dotfiles and machine setup — managed with [chezmoi](https://chezmoi.io),
secrets encrypted with [age](https://age-encryption.org), and built around the philosophy that
the best tools are ones you can configure, compose, and own.

## Features

- 🖥️ **[WezTerm](https://wezfurlong.org/wezterm/)** — GPU-accelerated terminal with Lua config
- ✏️ **[Helix](https://helix-editor.com/)** — modal editor with full LSP support (Go, Java, Rust)
- 🔍 **[Helix × WezTerm integration](##helix-wezterm-integration)** — blame, explorer, lazygit, and test runner via pane scripts
- 🧪 **[hx-gotest](#hx-gotest)** — custom Go AST tool to run the exact test under cursor (subtests, table-driven tests)
- 🔐 **Age-encrypted secrets** in dotfiles — key stored at `~/.config/age/chezmoi-key.txt`
- 📦 **[mise](https://mise.jdx.dev)** — polyglot runtime manager (Go, Node, Java, Python, Rust tools)
- 🐚 **Zsh + Zinit** with curated plugins, aliases, and `navi` cheatsheet
- 🍎 **macOS defaults** applied via reproducible shell script with drift detection
- 🗂️ **[yazi](https://yazi-rs.github.io/)** file explorer and **[tig](https://jonas.github.io/tig/)** blame — both integrated into Helix
- 🤖 **GitHub Copilot CLI** — AI assistant wired into the terminal with AGENTS.md context at every level

---

## Philosophy

**Configure, compose, own** — every tool in this setup was chosen because it exposes its internals as plain text, can be scripted to work with other tools, and doesn't lock you into a vendor.

**AI as a peer in the toolchain, not a replacement for it.** The goal is to keep humans in full control of the environment while letting AI handle the tedious parts. A few principles that guide how AI is incorporated here:

- **Context over magic** — `AGENTS.md` files at `~/`, `~/dev/`, and `~/source/` give AI agents explicit knowledge of the setup: what's managed by chezmoi, where aliases live, how commits are formatted, what the philosophy is. An agent that understands the environment makes better decisions than one guessing from scratch.
- **AI works inside the tools, not around them** — Copilot LSP runs inside Helix. The CLI runs inside WezTerm. They fit into the existing keyboard-driven workflow rather than requiring a separate chat window or IDE.
- **Own your prompts and instructions** — `AGENTS.md` files are version-controlled dotfiles. Custom agents live in `~/.copilot/agents/`. Instructions evolve with the setup.
- **Small tools compose better with AI** — `hx-gotest` does one thing (find the right Go test pattern from the AST). That focus makes it easy for AI to understand, extend, and reason about. The same applies to every script in `~/.config/helix/scripts/`.
- **AI should never be the path of least resistance to bypassing understanding** — use AI to go faster on things you understand, not to skip understanding things that matter.

## Quick Start

```sh
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Bootstrap mise and chezmoi
brew install mise
mise use -g chezmoi age

# 3. Restore your age key before applying dotfiles
#    Save your age key to ~/.config/age/chezmoi-key.txt
mkdir -p ~/.config/age
# paste key contents:
nano ~/.config/age/chezmoi-key.txt

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

# 5. Apply dotfiles — decrypts secrets using the age key,
#    writes all configs to their correct locations
chezmoi init --apply git@github.com:NilCor3/dotfiles.git

# 6. Install all runtimes and dev tools (go, node, java, lazygit, etc.)
mise install

# 7. Install brew packages (see sections below)

# 8. Set up GitHub Copilot CLI (see section below)
```

---

## GitHub Copilot CLI

The terminal AI assistant used in this setup. Runs in WezTerm, reads `~/AGENTS.md` and folder-level `AGENTS.md` files for context.

### Setup

```sh
# Install GitHub CLI
brew install gh

# Authenticate (opens browser)
gh auth login

# Install the Copilot CLI extension
gh extension install github/gh-copilot

# Launch the interactive CLI
gh copilot
```

The `~/.copilot/` directory contains:
- `agents/` — custom sub-agents (agent-writer, security-reviewer, tech-tutor, notes)
- `mcp-config.json` — MCP server configs (e.g. postgres via docker)
- `config.json` — UI preferences (theme, allowed URLs, trusted folders)

These are tracked in chezmoi. After a fresh `chezmoi apply`, run `gh auth login` to re-authenticate (auth token is not stored in dotfiles).



Repo: `git@github.com:jokaro/dotfiles.git`

| File | Purpose |
|------|---------|
| `~/.zshrc` | Zsh config, plugins via Zinit |
| `~/.zshenv` | Environment variables loaded for all shells |
| `~/.gitconfig` | Git config, delta pager, rebase defaults |
| `~/.gitignore` | Global gitignore |
| `~/.mise.toml` | Project-level env vars and shell aliases |
| `~/.config/mise/config.toml` | Global mise tools and environment |
| `~/.config/wezterm/wezterm.lua` | WezTerm terminal config |
| `~/.config/helix/` | Helix editor config and LSP setup |

### Updating dotfiles

```sh
# Pull latest changes from your home dir back into chezmoi source
chezmoi re-add

# Review, commit and push
chezmoi git -- diff
chezmoi git -- add -A
chezmoi git -- commit -m "Update dotfiles"
chezmoi git -- push
```

---

## Secrets

Secrets in `~/.mise.toml` are encrypted with [age](https://age-encryption.org).

- Age key lives at `~/.config/age/chezmoi-key.txt` — **never commit this**
- chezmoi config at `~/.config/chezmoi/chezmoi.toml` references the key

---

## Brew Formulas

Core tools installed via Homebrew:

```sh
brew install \
  git-filter-repo \
  git-crypt \
  jdtls \
  mise \
  mkcert \
  navi \
  rsync \
  wget \
  markdown-oxide \
  marksman \
  usage
```

> Most dev tools (go, node, java, python, etc.) are managed via **mise**, not brew.

## Brew Casks

```sh
brew install --cask \
  wezterm \
  raycast \
  alt-tab \
  hyperkey \
  jordanbaird-ice \
  finicky \
  dbeaver-community \
  insomnia \
  marta \
  pearcleaner \
  stats \
  utm \
  font-fira-mono-nerd-font \
  copilot-cli@prerelease
```

---

## Mise — Runtime Version Manager

All runtimes and dev tools are managed via [mise](https://mise.jdx.dev).
Global config: `~/.config/mise/config.toml`

---

## Shell — Zsh + Zinit

Plugin manager: [Zinit](https://github.com/zdharma-continuum/zinit)

---

## Terminal — WezTerm

Config at `~/.config/wezterm/wezterm.lua`.

---

## Editors

### Helix

Built from source, binary at `~/hx/builds/current/bin/hx`.
Config: `~/.config/helix/`

LSP setup:

- **Java** — jdtls (Homebrew) + Lombok + Fortnox code style
- **Go** — gopls with staticcheck, gofumpt, full inlay hints
- **Rust** — rust-analyzer with Clippy on save, proc macros, inlay hints
- **All languages** — Copilot LSP

### Helix WezTerm Integration

All keybindings live under `Space , ` (Space comma) in normal mode.
Scripts at `~/.config/helix/scripts/`.

| Key | Action | Script |
|-----|--------|--------|
| `Space , b` | Git blame at cursor line (tig) | `hx-blame.sh` |
| `Space , e` | File explorer — open in current window (yazi) | `hx-explorer.sh` |
| `Space , v` | File explorer — open in vertical split | `hx-explorer.sh` |
| `Space , s` | File explorer — open in horizontal split | `hx-explorer.sh` |
| `Space , g` | Lazygit in zoomed overlay pane | `hx-lazygit.sh` |
| `Space , t` | Run Go test under cursor | `hx-gotest.sh` |
| `Space , T` | Run whole Go test func | `hx-gotest.sh` |
| `Space , F` | Run all Go tests in file | `hx-gotest.sh` |

Each script reuses or creates a WezTerm pane, runs the tool, then returns focus to Helix.
`wezterm-find-hx.sh` is a helper that finds the Helix pane by title when focus needs to return.

### hx-gotest

Source: `~/source/hx-gotest/` — a small Go CLI using `go/ast` to determine the exact
`go test -run` pattern for the cursor position.

```sh
hx-gotest <file> <line> [cursor|func|file]
```

**Modes:**

| Mode | What runs | Example pattern |
|------|-----------|-----------------|
| `cursor` | Subtest at cursor (or whole func if none) | `^TestFoo$/^bar_case$` |
| `func` | Whole test func, all subtests | `^TestFoo$` |
| `file` | All Test* funcs in the file | `^(TestFoo\|TestBar)$` |

**Smart detection:**
- `t.Run("name", ...)` → exact subtest match
- Table-driven `{"my test", ...}` → matches by first string field
- Table-driven `{name: "my test", ...}` → matches by named field (`name`, `desc`, `description`, `scenario`, etc.)
- Variable `t.Run(name, ...)` → uses `.*` wildcard
- Nested subtests → `^TestA$/^SubB$/^SubC$`

To rebuild after changes:
```sh
cd ~/source/hx-gotest && go build -o ~/.local/bin/hx-gotest .
```

---



- **Pager**: [delta](https://dandavison.github.io/delta/) with `gruvmax-fang` theme
- **Merge style**: `zdiff3` (shows base in conflicts)
- **Pull**: rebase by default
- **SSH agent**: Bitwarden SSH agent (`com.bitwarden.desktop`)

---

## macOS Utilities

| App | Purpose |
|-----|---------|
| Raycast | Launcher, replaces Spotlight |
| AltTab | Windows-style app switcher |
| HyperKey | Caps Lock → Hyper key modifier |
| Ice | Menu bar manager |
| Stats | System stats in menu bar |
| Finicky | Browser router (default: Zen, localhost → Chrome) |
| Marta | Dual-pane file manager |
| PearCleaner | App uninstaller |
| UTM | Virtual machines |

---

## Manual Backup & Restore

Some apps don't support config files or `defaults write` and must be backed up
and restored manually.

### Raycast

Raycast syncs settings via iCloud automatically — no manual action needed.
If iCloud is unavailable: Settings → Advanced → Export/Import.

### Ice

Ice stores complex menu bar layout data that doesn't map to plain
`defaults write` calls.

**Backup:** Ice → Settings → General → Export Settings → save to a safe location
(e.g. Bitwarden attachment or iCloud).

**Restore:** Ice → Settings → General → Import Settings.

### Bitwarden

The Bitwarden vault is cloud-synced. Just log in after a fresh install.
SSH agent must be enabled manually: Settings → SSH Agent → enable.

### Marta

File manager config is tracked in chezmoi at `~/Library/Application Support/org.yanex.marta/conf.marco`.
To add it:

```sh
chezmoi add ~/Library/Application\ Support/org.yanex.marta/conf.marco
```

---

## Updating macOS Defaults

App settings (AltTab, HyperKey, Stats, Dock, Finder, etc.) are stored as
`defaults write` commands in:

```sh
~/.local/share/chezmoi/run_once_after_macos-defaults.sh
```

### To update a setting

Edit the script directly:

```sh
hx ~/.local/share/chezmoi/run_once_after_macos-defaults.sh
```

Since `autoCommit` and `autoPush` are enabled in chezmoi, saving the file and
running `chezmoi apply` will commit, push, and re-apply all defaults in one step
— because changing the file content changes its hash, which triggers chezmoi to
re-run it.

```sh
chezmoi apply
```

To update the repo **without** re-running the script on the current machine
(e.g. you already applied the setting manually), just edit and let chezmoi
auto-commit without applying.

---

## Database tools

- **DBeaver Community** — GUI client
- **lazysql** — TUI SQL client (via mise)

---

## Git — Merge Conflicts

Mergiraf + lazygit covers the full conflict resolution workflow:

- **[mergiraf](https://mergiraf.org)** — syntax-aware merge driver; fires automatically on `git merge`/`git rebase` for supported files (Go, Rust, Java, TypeScript, JSON, YAML, TOML, etc.). Pre-resolves structural conflicts (e.g. two branches adding different functions in the same file) so you never see them.
- **lazygit** — handles remaining conflicts interactively. `e` on a conflicted file → 3-panel view, pick ours/theirs/base per hunk.

Configured globally via `~/.gitconfig` (merge driver) and `~/.gitattributes` (file type routing).

```sh
mgsolve <file>     # alias: mergiraf solve — clean up remaining markers in a file
mergiraf review <file>  # compare mergiraf resolution vs line-based
```

---

## SSH

SSH agent provided by **Bitwarden desktop app**.

```sh
export SSH_AUTH_SOCK=~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
```

Set in `~/.zshrc`. Make sure Bitwarden SSH agent is enabled in Bitwarden →
Settings → SSH Agent.
