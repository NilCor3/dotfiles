# NilCor3's Mac Setup

> A terminal-first, keyboard-driven macOS development environment.
> Everything is version-controlled, reproducible, and fast.

This repo contains my personal dotfiles and machine setup — managed with [chezmoi](https://chezmoi.io),
secrets encrypted with [age](https://age-encryption.org), and built around the philosophy that
the best tools are ones you can configure, compose, and own.

---

## Table of Contents

- [Features](#features)
- [Philosophy](#philosophy)
- [Quick Start](#quick-start)
- [GitHub Copilot CLI](#github-copilot-cli)
- [Secrets](#secrets)
- [Brew Formulas](#brew-formulas)
- [Brew Casks](#brew-casks)
- [Mise — Runtime Version Manager](#mise--runtime-version-manager)
- [Shell — Zsh + Zinit](#shell--zsh--zinit)
- [Terminal — WezTerm](#terminal--wezterm)
- [tmux — Multiplexer](#tmux--multiplexer)
- [Editors](#editors)
  - [Helix](#helix)
  - [Helix Integration](#helix-integration)
  - [hx-gotest](#hx-gotest)
- [macOS Utilities](#macos-utilities)
- [Manual Backup & Restore](#manual-backup--restore)
  - [Amethyst](#amethyst)
  - [Raycast](#raycast)
  - [Ice](#ice)
  - [Bitwarden](#bitwarden)
  - [Finicky](#finicky)
  - [Zen](#zen)
  - [HyperKey](#hyperkey)
  - [AltTab](#alttab)
  - [BetterMouse](#bettermouse)
  - [Docker Desktop](#docker-desktop)
  - [TimeyMeet](#timeymeet)
  - [Keyboard Pilot](#keyboard-pilot)
  - [Marta](#marta)
- [Updating macOS Defaults](#updating-macos-defaults)
- [Database tools](#database-tools)
- [Postgres CLI — pgcli](#postgres-cli--pgcli)
- [Git — Merge Conflicts](#git--merge-conflicts)
- [File Listing — eza](#file-listing--eza)
- [HTTP Client — xh](#http-client--xh)
- [Mock REST — prism + json-server](#mock-rest--prism--json-server)
- [Local AI — ollama + mods](#local-ai--ollama--mods)
- [Notes — marksman + glow](#notes--marksman--glow)
- [Todos](#todos)
- [JSON — jq, jnv, fx](#json--jq-jnv-fx)
- [Rust Tools](#rust-tools--bacon-cargo-nextest-cargo-audit-cargo-expand)
- [Go Tools](#go-tools--air-sqlc-gotestsum-dlv-oapi-codegen)
- [TypeScript Tools — biome, tsx, knip](#typescript-tools--biome-tsx-knip)
- [Slides — terminal presentations](#slides--terminal-presentations)
- [SSH](#ssh)

---


## Features

- 🖥️ **[WezTerm](https://wezfurlong.org/wezterm/)** — GPU-accelerated terminal (fonts, window, clipboard)
- ✏️ **[Helix](https://helix-editor.com/)** — modal editor with full LSP support (Go, Java, Rust)
- 🗂️ **[tmux](#tmux--multiplexer)** — multiplexer with vi copy mode, sessions, and Helix-mirrored keybinds (`Ctrl+Space` leader)
- 🔍 **[Helix integration](#helix-integration)** — blame, lazygit, markdown preview, and test runner via tmux floating panes and splits
- 🧪 **[hx-gotest](#hx-gotest)** — custom Go AST tool to run the exact test under cursor (subtests, table-driven tests)
- 🔐 **Age-encrypted secrets** in dotfiles — key stored at `~/.config/age/chezmoi-key.txt`
- 📦 **[mise](https://mise.jdx.dev)** — polyglot runtime manager (Go, Node, Java, Python, Rust tools)
- 🐚 **Zsh + Zinit** with curated plugins, aliases, and `navi` cheatsheet
- 🍎 **macOS defaults** applied via reproducible shell script with drift detection
- 🗂️ **[yazi](https://yazi-rs.github.io/)** file explorer and **[tig](https://jonas.github.io/tig/)** blame — both integrated into Helix
- 🌐 **[xh](https://github.com/ducaale/xh)** — fast, friendly HTTP client for the terminal (httpie compatible)
- 📂 **[eza](https://eza.rocks)** — modern `ls` with icons, git status, and tree view
- 🐘 **[pgcli](https://www.pgcli.com)** — postgres CLI with autocomplete, syntax highlighting and named queries
- 🎭 **[prism](https://stoplight.io/open-source/prism)** + **[json-server](https://github.com/typicode/json-server)** — mock REST APIs from OpenAPI spec or plain JSON
- 🔄 **[air](https://github.com/air-verse/air)** — live reload for Go servers on file save
- 🗄️ **[sqlc](https://sqlc.dev)** — generate type-safe Go from SQL queries
- 🧪 **[gotestsum](https://github.com/gotestyourself/gotestsum)** — prettier Go test output with watch mode
- 🌈 **[richgo](https://github.com/kyoh86/richgo)** — colored `go test` output; used by Helix test runner and `got`/`gota` aliases
- 🐛 **[dlv](https://github.com/go-delve/delve)** — Go debugger with DAP support for editor integration
- 🔭 **[gdlv](https://github.com/aarzilli/gdlv)** — GUI companion for dlv; use `dlvg` to run both together
- 📐 **[oapi-codegen](https://github.com/oapi-codegen/oapi-codegen)** — generate Go types and server stubs from OpenAPI specs
- 🥓 **[bacon](https://dystroy.org/bacon/)** — background Rust checker/tester that reruns on save
- ⚡ **[cargo-nextest](https://nexte.st)** — faster Rust test runner with better output
- 🔒 **[cargo-audit](https://rustsec.org)** — audit Cargo.lock for security vulnerabilities
- 🔬 **[cargo-expand](https://github.com/dtolnay/cargo-expand)** — expand Rust macros to see generated code
- 🔎 **[jnv](https://github.com/ynqa/jnv)** — interactive jq filter builder (live preview as you type)
- 🌿 **[fx](https://fx.wtf)** — interactive JSON explorer and processor (pipe or file)
- 📓 **[marksman](https://github.com/artempyanykh/marksman)** — markdown LSP with `[[wiki links]]`, backlinks, and cross-note navigation
- ✨ **[glow](https://github.com/charmbracelet/glow)** — terminal markdown reader and notes browser TUI
- 🦙 **[ollama](https://ollama.com)** — local LLM runtime, runs on Apple Silicon GPU via Metal (background service)
- 💬 **[mods](https://github.com/charmbracelet/mods)** — pipe anything through AI on the command line
- 🎨 **[biome](https://biomejs.dev)** — fast all-in-one JS/TS formatter + linter (replaces ESLint + Prettier)
- ⚡ **[tsx](https://github.com/privatenumber/tsx)** — run TypeScript files directly without compiling
- 🔍 **[knip](https://knip.dev)** — finds unused exports, dependencies, and files in TypeScript projects
- 📽️ **[slides](https://github.com/maaslalani/slides)** — render markdown as a terminal slideshow
- 🤖 **[GitHub Copilot CLI](https://github.com/github/gh-copilot)** — AI assistant wired into the terminal with AGENTS.md context at every level

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

The terminal AI assistant used in this setup. Runs in WezTerm, reads `~/AGENTS.md` and folder-level `AGENTS.md` files for context. See the [GitHub Copilot CLI docs](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line) and the [gh-copilot extension](https://github.com/github/gh-copilot).

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
| `~/.config/wezterm/wezterm.lua` | WezTerm terminal config (GPU/fonts/window only) |
| `~/.config/tmux/tmux.conf` | tmux multiplexer config |
| `~/.config/tmux/layouts/dev.sh` | dev layout (helix + 2 shells) |
| `~/.config/tmux/scripts/picker.sh` | fzf project/session picker |
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
  tig \
  wget \
  markdown-oxide \
  usage \
  mergiraf \
  mods \
  pgcli \
  slides
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
  amethyst \
  zen \
  bitwarden \
  bettermouse \
  docker-desktop \
  dbeaver-community \
  insomnia \
  marta \
  pearcleaner \
  stats \
  utm \
  font-fira-mono-nerd-font \
  copilot-cli@prerelease
```

**App Store** (install manually):
- [TimeyMeet](https://apps.apple.com/app/timelyMeet/id1611090219) — meeting join buttons in menu bar
- [Keyboard Pilot](https://apps.apple.com/app/keyboard-pilot/id1496719023) — per-app keyboard shortcut routing

---

## Mise — Runtime Version Manager

All runtimes and dev tools are managed via [mise](https://mise.jdx.dev).
Global config: `~/.config/mise/config.toml`

---

## Shell — Zsh + Zinit

Plugin manager: [Zinit](https://github.com/zdharma-continuum/zinit)

**[bat](https://github.com/sharkdp/bat)** (mise) — `cat` with syntax highlighting and line numbers. Used automatically in all fzf previews (`nf`, `nft`, `fhx`, etc.).

```sh
bat file.rs                    # syntax-highlighted file view
bat -l json file.json          # explicit language
xh api.example.com | bat -l json   # pipe with language hint
```

---

## Terminal — WezTerm

Config at `~/.config/wezterm/wezterm.lua`. GPU-accelerated terminal emulator only — fonts, window, clipboard. Pane/tab management handled by Zellij.

### Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+-` / `Ctrl++` | Decrease / increase font size |
| `CMD+c` / `CMD+v` | Copy / paste |
| `Shift+Up/Down` | Scroll to previous / next shell prompt |
| `Ctrl+Shift+j/k` | Scroll WezTerm viewport down/up 1 line |
| `Ctrl+Shift+d/u` | Scroll WezTerm viewport down/up half page |

No plugins, no leader key, no pane management — that's all tmux.



## tmux — Multiplexer

tmux runs **inside** WezTerm (auto-started from `.zshrc` when inside a WezTerm pane via `~/.config/tmux/scripts/picker.sh`). Handles all panes, windows, sessions.

Config: `~/.config/tmux/tmux.conf`

### Design: zero conflicts with Helix

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
| `Ctrl+Space g` | Project picker (fzf: layout → workspace → repo → session) |
| `Ctrl+Space d` | Detach |
| `Ctrl+Space ?` | Show keybind help popup |

### Session naming

Sessions are named `<workspace>-<repo>` — e.g. `dev-hx-gotest`, `fortnox-blink`.

### Layouts

Layouts live in `~/.config/tmux/layouts/`. Selected via the `g` picker:

| Layout | Description |
|--------|-------------|
| `dev` | Helix 70% top, two shells side-by-side in 30% bottom. Panes: `helix`, `shell-1`, `shell-2` |
| `shell` | Single named shell session |
| `ai` | GitHub Copilot CLI session |
| `notes` | 2-window notes workspace (see [Notes & Todos](#notes--todos)) |



## Editors

### Helix

Built from source (custom fork with inline completion support), binary at `~/hx/builds/current/bin/hx`.
Config: `~/.config/helix/`

**Fork:** `github.com/NilCor3/helix` on branch `feature/inline-completion` — rebased onto upstream master, with [devmanuelli's inline completion PR](https://github.com/devmanuelli/helix) merged in for Copilot inline suggestions.

**After a fresh machine restore:**

```sh
# Clone fork and set up remotes
git clone git@github.com:NilCor3/helix.git ~/hx/source
cd ~/hx/source
git remote add upstream https://github.com/helix-editor/helix
git remote add devmanuelli https://github.com/devmanuelli/helix.git
git checkout feature/inline-completion

# Build (requires Rust via mise)
cargo build --release

# Deploy — creates numbered build, copies binary + runtime, updates 'current' symlink
cd ~/hx && bash setup_build.sh

# Authenticate Copilot (first time only — device flow)
python3 ~/hx/copilot_auth.py
```

`mise` config adds `~/hx/builds/current/bin` to PATH and sets `HELIX_RUNTIME` automatically.

**Keeping Helix up to date:**

```sh
cd ~/hx/source
git fetch upstream
git rebase upstream/master        # rebase inline-completion onto latest upstream
# resolve any conflicts, then:
cargo build --release
cd ~/hx && bash setup_build.sh
```

LSP setup:

- **Java** — jdtls (Homebrew) + Lombok + Fortnox code style
- **Go** — gopls with staticcheck, gofumpt, full inlay hints
- **Rust** — rust-analyzer with Clippy on save, proc macros, inlay hints
- **All languages** — Copilot LSP (default) or ollama-ls (toggle with `Space , a`)

### Inline completion

The fork exposes `textDocument/inlineCompletion`. Two providers available:

| Provider | Source | Trigger |
|----------|--------|---------|
| `copilot` | GitHub Copilot cloud | `A-i` |
| `ollama-ls` | Local qwen2.5-coder:7b via ollama | `A-i` |

Toggle with **`Space , a`** (restarts LSP). State persists in `~/.config/helix/.ai-provider`.

`ollama-ls` is a ~150-line Python bridge (`~/.config/helix/scripts/ollama-ls.py`) — no daemon, no auth, connects directly to `localhost:11434`. Logs to `/tmp/ollama-ls.log`.

### Helix Keybindings

| Key | Action |
|-----|--------|
| `C-s` | Save current buffer (normal + insert mode) |
| `C-S-s` | Save all buffers (normal + insert mode) |
| `C-g` | Open lazygit in a new buffer (exits on quit) |
| `esc` | Collapse selection, keep primary |
| `A-t` | Insert `- [ ] ` todo checkbox below cursor (`.md` files only; works in normal + insert mode) |

### Helix Integration

All keybindings live under `Space , ` (Space comma) in normal mode.
Scripts at `~/.config/helix/scripts/`. All scripts detect `$TMUX` / `$ZELLIJ` / `$WEZTERM_PANE` at runtime — tmux uses `display-popup` for floats and `split-window` for test output.

| Key | Action | Action |
|-----|--------|--------|
| `C-e` | File explorer at current buffer's directory | built-in |
| `Space , b` | Git blame at cursor line (tig in floating pane) | `hx-blame.sh` |
| `Space , g` | Lazygit in floating pane | `hx-lazygit.sh` |
| `Space , t` | Run test under cursor (Go or Rust) | `hx-test.sh` |
| `Space , T` | Run whole test func (Go or Rust) | `hx-test.sh` |
| `Space , F` | Run all tests in file (Go or Rust) | `hx-test.sh` |
| `Space , m` | Markdown preview (glow) in floating pane | `hx-markdown.sh` |
| `Space , y` | Open yazi at current buffer's dir, send chosen files to Helix | `hx-yazi.sh` |
| `Space , a` | Toggle AI provider (Copilot ↔ ollama) | `hx-toggle-ai.sh` |

### hx-gotest + hx-rusttest

**Go:** `~/dev/hx-gotest/` — a small Go CLI using `go/ast` to determine the exact
`go test -run` pattern for the cursor position. Test output is piped through **richgo** for colored output.

**Rust:** `~/.config/helix/scripts/hx-rusttest.py` — Python parser that finds `#[test]`/`#[tokio::test]` functions at the cursor, including the enclosing `mod` name (e.g. `tests::test_split_at_start`). Runs via `cargo nextest run`.

Both are dispatched by `hx-test.sh` based on file extension.

```sh
hx-gotest <file> <line> [cursor|func|file]   # Go AST test finder
hx-rusttest.py <file> <line> [cursor|func|file]  # Rust test finder
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
cd ~/dev/hx-gotest && go build -o ~/.local/bin/hx-gotest .
```

---

## Git — Configuration

- **Pager**: [delta](https://dandavison.github.io/delta/) with `gruvmax-fang` theme — syntax-highlighted diffs in terminal. Installed via mise.
- **Merge style**: `zdiff3` (shows base in conflicts)
- **Pull**: rebase by default
- **SSH agent**: Bitwarden SSH agent (`com.bitwarden.desktop`)

Config: `~/.gitconfig`

---

## macOS Utilities

| App | Purpose | Config |
|-----|---------|--------|
| [Amethyst](https://ianyh.com/amethyst/) | Tiling window manager (xmonad-style) | `~/.config/amethyst/amethyst.yml` in chezmoi |
| [Raycast](https://raycast.com) | Launcher, replaces Spotlight | iCloud sync |
| [AltTab](https://alt-tab-macos.netlify.app) | Windows-style app switcher | `defaults write` |
| [HyperKey](https://hyperkey.app) | Caps Lock → Hyper key (⌃⌥⇧⌘) | `defaults write` |
| [Ice](https://icemenubar.app) | Menu bar manager | Export/Import |
| [Finicky](https://github.com/johnste/finicky) | Browser router (default: Zen, localhost → Chrome) | `~/.finicky.js` in chezmoi |
| [Zen](https://zen-browser.app) | Default browser (Firefox-based) | Firefox account sync |
| [Bitwarden](https://bitwarden.com) | Password manager + SSH agent | Cloud-synced vault |
| [BetterMouse](https://better-mouse.com) | Mouse scroll speed, pointer precision | Export/Import |
| [Keyboard Pilot](https://apps.apple.com/app/keyboard-pilot/id1496719023) | Per-app keyboard layout / shortcut routing | GUI only |
| [TimeyMeet](https://apps.apple.com/app/timelyMeet/id1611090219) | Meeting join buttons in menu bar | No config |
| [Docker Desktop](https://docker.com/products/docker-desktop) | Container runtime | Key settings documented below |
| [Stats](https://github.com/exelban/stats) | System stats in menu bar | GUI only |
| [Marta](https://marta.sh) | Dual-pane file manager | chezmoi tracked |
| [PearCleaner](https://itsalin.com/appInfo/?id=pearcleaner) | App uninstaller | No config |
| [UTM](https://mac.getutm.app) | Virtual machines | No config |

---

## Manual Backup & Restore

| App | Config method | Location / action |
|-----|--------------|-------------------|
| Amethyst | chezmoi | `~/.config/amethyst/amethyst.yml` |
| Finicky | chezmoi | `~/.finicky.js` |
| Marta | chezmoi | `~/Library/Application Support/org.yanex.marta/conf.marco` |
| Raycast | Export/Import | `~/.config/backups/raycast-settings.rayconfig` |
| Ice | Export/Import | `~/.config/backups/ice-settings.json` |
| BetterMouse | Export/Import | `~/.config/backups/bettermouse-settings.bms` |
| Bitwarden | Cloud-synced | Log in · enable SSH Agent manually |
| Zen | Firefox account | Sign in · reinstall extensions |
| HyperKey | `defaults write` | See section below |
| AltTab | `defaults export` | See section below |
| Docker Desktop | No backup | Sensible defaults on fresh install |
| TimeyMeet | No config | Grant Calendar access on install |
| Keyboard Pilot | No export | Reconfigure per-app rules manually |

### Amethyst

Config tracked in chezmoi — applied automatically on `chezmoi apply`:

```
~/.config/amethyst/amethyst.yml
```

**First launch:** System Settings → Privacy & Security → Accessibility → enable Amethyst.

Key shortcuts: `⌥⇧ J/K` focus prev/next · `⌥⇧ W/E/R` focus screen 1/2/3 · `⌃⌥⇧ W/E/R` throw to screen · `⌥⇧ Space` cycle layout · `⌥⇧ D` fullscreen layout · `⌥⇧ T` toggle float.

### Raycast

**Backup:** Raycast → Settings → Advanced → Export → save to `~/.config/backups/raycast-settings.rayconfig`, then:
```sh
chezmoi add ~/.config/backups/raycast-settings.rayconfig

# Restore: Raycast → Settings → Advanced → Import
```

### Ice

Ice stores complex menu bar layout data that doesn't map to plain
`defaults write` calls.

**Backup:** Ice → Settings → General → Export Settings → save to `~/.config/backups/ice-settings.json`, then `chezmoi add ~/.config/backups/ice-settings.json`.

**Restore:** Ice → Settings → General → Import Settings.

### Bitwarden

The Bitwarden vault is cloud-synced. Just log in after a fresh install.

**Post-install steps:**
1. Settings → SSH Agent → enable (required for git over SSH)
2. Install browser extension for Zen

### Finicky

Config tracked in chezmoi — applied automatically on `chezmoi apply`:

```
~/.finicky.js
```

Current rules: default browser = Zen · http → https redirect · `localhost*`, `*curseforge.com`, `*overwolf.com` → Chrome (Profile 1).

**First launch:** System Settings → Privacy & Security → grant Finicky permission to set itself as default browser.

### Zen

Firefox-based browser. Sign in with a Firefox account to sync bookmarks, history, and extensions.

Config not tracked in chezmoi (profile data is too large and browser-managed). Key extensions to reinstall: Bitwarden, uBlock Origin.

### HyperKey

**Key setting:** Caps Lock → Hyper (⌃⌥⇧⌘)

On first launch:
1. Enable "Launch at Login"
2. Set Caps Lock remapping to Hyper (⌃⌥⇧⌘)
3. Grant Accessibility permission when prompted

Settings stored as defaults — if needed:
```sh
defaults write com.knollsoft.Hyperkey capsLockRemapped -int 2
defaults write com.knollsoft.Hyperkey launchOnLogin -bool true
```

### AltTab

Windows-style app switcher. Key settings to configure:

- Appearance: match system
- Show windows from: all spaces
- Shortcut: `⌘Tab` (replaces macOS default)

Settings stored as defaults — export/restore:
```sh
# Backup
defaults export com.lwouis.alt-tab-macos ~/alt-tab-backup.plist

# Restore
defaults import com.lwouis.alt-tab-macos ~/alt-tab-backup.plist
```

### BetterMouse

Mouse scroll and pointer customization.

**Backup:** BetterMouse menu bar icon → Export Settings → save to `~/.config/backups/bettermouse-settings.bms`, then:
```sh
chezmoi add ~/.config/backups/bettermouse-settings.bms
```

**Restore:** BetterMouse menu bar icon → Import Settings → select the file.

### Docker Desktop

Install via `brew install --cask docker-desktop`. Key settings already at sensible defaults after install. Notable:

- `UseContainerdSnapshotter: true` — better image compatibility
- `OpenUIOnStartupDisabled: true` — don't open UI on login
- `EnableDockerAI: false`

No backup needed — settings regenerate; project `docker-compose.yml` files are version-controlled.

### TimeyMeet

App Store app. Adds meeting join buttons to the menu bar by reading your calendar.

**Post-install:** Grant Calendar access when prompted. No settings to back up.

### Keyboard Pilot

App Store app. Routes keyboard layouts and shortcuts per active app.

**Post-install:** Configure per-app rules via the menu bar icon. No file export available — reconfigure from scratch on a new machine. Document any critical routes here.

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
- **[lazysql](https://github.com/jorgerojas26/lazysql)** — TUI SQL client; connects to Postgres, MySQL, SQLite. Launch: `lazysql` (no alias — name is already short).
- **pgcli** — postgres CLI with autocomplete and named queries (brew)

---

## Postgres CLI — pgcli

**[pgcli](https://www.pgcli.com)** enhances the standard `psql` with autocomplete (tables, columns, keywords), syntax highlighting, and named query shortcuts.

```sh
pgc <database>                                    # alias for pgcli
pgcli -h <host> -U <user> <database>
pgcli postgresql://user:pass@host/db
```

Config at `~/.config/pgcli/config` (vi mode, monokai theme, 1000 row limit, uppercase keywords).

### Key meta-commands

| Command | Description |
|---------|-------------|
| `\dt` | List all tables |
| `\d <table>` | Describe table |
| `\l` | List databases |
| `\ns <name> <query>` | Save named query |
| `\n <name>` | Run named query |
| `\copy (...) TO 'file.csv'` | Export to CSV |
| `\e` | Open query in `$EDITOR` (Helix) |

### Workflow tips

- Set `EDITOR=hx` — `\e` opens the current query in Helix, save to execute
- Named queries (`\ns`) are great for frequently used reports — stored in `~/.config/pgcli/named_queries.cfg`
- Pairs with **DBeaver** for GUI exploration and **lazysql** for a TUI overview

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

## File Listing — eza

**[eza](https://eza.rocks)** replaces `ls` with icons, colour coding, git status per file, and tree view. Installed via mise.

```sh
ll      # eza -lah --icons --git   — detailed list with git status
la      # eza -a --icons           — all files including hidden
lt      # eza --tree --icons -L 2  — tree view, 2 levels
llt     # eza -lah --tree -L 2     — detailed tree
```

The `--git` flag shows per-file status inline (`N` new, `M` modified, `I` ignored) — useful for seeing what's dirty without running `git status`.

Requires a Nerd Font — `font-fira-mono-nerd-font` is installed via brew cask.

---

## HTTP Client — xh

**[xh](https://github.com/ducaale/xh)** is a fast, friendly HTTP client (httpie-compatible syntax, written in Rust).

```sh
# Aliases
http=xh
https='xh --https'
```

### Usage

```sh
# GET
xh httpbin.org/get

# POST JSON — string values use =, raw/number values use :=
xh POST api.example.com/users name=Alice age:=30

# Auth header
xh api.example.com Authorization:"Bearer $TOKEN"

# Print only response body (pipe-friendly)
xh --print=b api.example.com/data

# Download file
xh --download https://example.com/file.zip

# Persist session (cookies + headers) across requests
xh --session=myapp POST api.example.com/login username=me password=secret
xh --session=myapp api.example.com/profile   # reuses session

# Preview request without sending
xh --offline POST api.example.com key=value

# Follow redirects
xh --follow https://example.com
```

### Workflow integration

- **Pipe to jq**: `xh api.example.com/data | jq '.items[]'`
- **Pipe to fx**: `xh api.example.com/data | fx` — interactive JSON explorer
- **Pipe to bat**: `xh --print=b api.example.com | bat -l json` — syntax-highlighted output
- **In scripts**: drop-in replacement for `curl -s` + JSON parsing boilerplate
- **Sessions** are stored in `~/.config/xh/sessions/` — useful for multi-step API flows

---

## Mock REST — prism + json-server

Two complementary tools for mocking APIs without a running backend.

**[prism](https://stoplight.io/open-source/prism)** mocks from an OpenAPI/Swagger spec — start a realistic mock server in one command. Can also act as a validating proxy to a real API.

**[json-server](https://github.com/typicode/json-server)** creates a full CRUD REST API from a plain JSON file — ideal for quick prototyping when you don't have a spec yet.

Both installed via mise (npm).

```sh
# Aliases
mock='prism mock'
jsr='json-server'
```

### Usage

```sh
# Mock from local OpenAPI spec
prism mock openapi.yaml

# Mock from remote spec URL
prism mock https://api.example.com/openapi.yaml

# Validating proxy to real API
prism proxy openapi.yaml https://real-api.example.com

# Quick CRUD API from a JSON file — GET/POST/PUT/DELETE /users, /posts etc.
echo '{"users":[],"posts":[]}' > db.json
json-server db.json

# Custom port
json-server --port 3001 db.json
```

### Workflow tips

- **Compose with xh**: `prism mock openapi.yaml &` then `xh :3000/users` — full request/response flow locally
- **Prism validates** requests and responses against the spec — good for catching drift early
- **json-server routes file**: map clean URLs with a `routes.json` → `{ "/api/*": "/$1" }`
- **prism + blink**: point at the existing OpenAPI spec for frontend/integration testing without a running backend

---

## Local AI — ollama + mods

**[ollama](https://ollama.com)** runs LLMs locally on Apple Silicon via Metal GPU acceleration. **[mods](https://github.com/charmbracelet/mods)** (charmbracelet) is a CLI wrapper that pipes anything through an LLM — local or cloud.

ollama installed via mise. mods installed via brew. mods config at `~/Library/Application Support/mods/mods.yml`.

ollama runs as a **launchd background service** (`~/Library/LaunchAgents/com.ollama.serve.plist`) — starts automatically on login, always available at `localhost:11434`.

```sh
launchctl load ~/Library/LaunchAgents/com.ollama.serve.plist    # start service
launchctl unload ~/Library/LaunchAgents/com.ollama.serve.plist  # stop service
curl -s http://localhost:11434                                    # check running
tail -f /tmp/ollama.log                                          # view logs
```

### Models

```sh
ollama serve                    # start local inference server (localhost:11434)
ollama pull gemma3:4b           # ~2.5GB, fast general purpose
ollama pull qwen2.5-coder:7b    # ~4.5GB, best for code tasks
ollama list                     # list installed models
```

### Aliases

```sh
ai='mods -a ollama -m gemma3:4b'          # local general
aic='mods -a ollama -m qwen2.5-coder:7b'  # local coder
m='mods'                                   # shorthand (uses default API)
```

### Usage

```sh
# Explain code
cat file.go | ai "explain this code"

# Write commit message
git diff | ai "write a concise commit message"

# Review for bugs
cat file.go | aic "review this for bugs and improvements"

# Summarize
cat file.md | m "summarize in 3 bullet points"

# Ask a question
ai "what is the difference between a mutex and a semaphore"

# Use cloud model explicitly
cat file.go | mods -m gpt-4o "refactor this"
```

### Workflow

- ollama runs as a background service — always available, no manual start needed
- Use `ai` / `aic` for offline/private work (code, notes, internal docs)
- Use `m` (default API) for cloud models when you need higher quality
- Pairs with `nreview` for AI-assisted note review: `nreview` (current file) or `nreview <path>`

---

## Notes — marksman + glow

Plain markdown files in `~/notes/` with frontmatter conventions. No app, no sync service — just files, ripgrep, fzf, and Helix.

**Structure:**
```
~/notes/
├── journal/      # daily notes (type: daily)
├── work/         # meetings, issues, system docs (type: meeting|issue|system)
├── dev/          # tech reference (type: ref)
├── projects/     # personal projects, learning
└── scratch.md    # quick capture inbox
```

**Frontmatter convention:**
```yaml
---
type: meeting        # meeting | issue | system | ref | daily | scratch
tags: [blink, api]
date: 2026-02-27
---
```

### Shell functions

```sh
n              # open ~/notes in Helix
ns             # open scratch.md (quick capture)
nj             # create/open today's journal (journal/YYYY-MM-DD.md)
nmeet <title>  # new meeting note with template (won't overwrite existing)
nissue <id>    # new issue note (work/issue-NOV-123.md)
nn <path>      # new note at relative path (creates frontmatter)
nf [query]     # fuzzy find notes by filename → open in Helix
nft <type>     # filter by frontmatter type (rg + fzf)
ntag <tag>     # filter by frontmatter tag (rg + fzf)
ng <pattern>   # ripgrep search → fzf file picker with match preview
ngs            # live interactive content search (rg reloads as you type, opens at exact line)
ngl            # browse notes with glow TUI
nsync          # commit all changes and push
```

### Tools

- **[marksman](https://github.com/artempyanykh/marksman)** (mise) — Helix LSP: `[[wiki link]]` completion, go-to-definition, find-references across the vault. Also **markdown-oxide** and **rumdl** linter are configured.
- **[glow](https://github.com/charmbracelet/glow)** (mise) — charmbracelet TUI markdown browser. `ngl` opens the whole vault; `glow file.md` renders a single file beautifully.

### Git sync

Auto-push on every commit via post-commit hook. Run `nsync` to commit all changes and push.

**Pre-commit validation** (`.hooks/pre-commit`) — blocks commits if:
- `type:` field missing from frontmatter
- `date:` field missing from frontmatter
- rumdl warnings are shown (non-blocking)

### Workflow

- Capture fast: `ns` → type → save. Sort to proper folder later.
- Daily standup: `nj` → today's journal is ready with the date
- During a meeting: `nmeet blink-planning` → structured template opens instantly
- Find anything: `nf blink` (filename), `nft meeting` (by type), `ntag api` (by tag)
- Search content: `ng <word>` (static), `ngs` (live interactive, opens at exact line), `<space>/` in Helix
- Read/review: `ngl` for TUI browsing, `glow file.md` to render before sharing

---

## Todos

Plain GFM checkboxes in `~/notes/todos/`. No app — just markdown, ripgrep, fzf, and shell functions.

**Files:**
```
~/notes/todos/
├── inbox.md    # quick capture (default for ta)
├── work.md
├── dev.md
├── personal.md
└── someday.md
```

**Format:** standard GFM checkbox — `- [ ] Task text #tag project:name`

### Shell functions

```sh
ta [text]       # append to inbox.md (no args → open inbox in Helix)
tl              # list all open todos with fzf preview → open in Helix at exact line
td              # mark a todo done (fzf picker, comments out the line)
tp [project]    # open a todo file (fzf or direct)
tg <tag>        # filter todos by #tag (fzf → open in Helix)
```

### Helix keybind

`Alt+t` in normal or insert mode — inserts `- [ ] ` on a new line below cursor. Only active in `.md` files (no-op elsewhere). Script: `~/.config/helix/scripts/hx-todo-insert.sh`.

### tmux layout

`notes` layout (picker `g` → notes): 2 windows.
- **todos** window: Helix (42.5%) + todos list auto-running `tl` (42.5%) + shell (15%)
- **notes** window: Helix (80%) + shell (20%)

`tl` detects the `notes:todos` session/window and opens selected files directly in the Helix pane.

---

## JSON — jq, jnv, fx

Three tools that compose into a complete JSON workflow.

- **jq** — system-installed (1.7.1); the standard for scripting and one-liners
- **[jnv](https://github.com/ynqa/jnv)** — interactive filter builder; type a jq expression and see results live
- **[fx](https://fx.wtf)** — interactive explorer and JS-powered processor; installed via mise

```sh
# Explore an unknown API response
xh api.example.com/data | jnv

# Navigate a JSON file interactively (arrows, /, q)
fx file.json

# Filter with a JS expression
fx file.json '.users.filter(u => u.active)'

# One-liner scripting
xh api.example.com/data | jq -r '.items[].name'

# Extract + reshape
jq '[.[] | {name: .name, id: .id}]' file.json

# Raw string (no quotes), compact output
jq -rc '.[].field' file.json
```

### Workflow

1. **Discover** — pipe to `jnv` to build the filter interactively
2. **Script** — paste the filter into `jq` for use in scripts/pipelines
3. **Navigate** — use `fx` for large/nested structures where you want to collapse/expand nodes

---

## Rust Tools — bacon, cargo-nextest, cargo-audit, cargo-expand

All installed via mise (`cargo:` prefix).

### bacon — background watcher

**[bacon](https://dystroy.org/bacon/)** is a background Rust checker that reruns on every file save — like air for Rust.

```sh
bac           # alias: bacon — default watch (test)
bacon check   # watch cargo check
bacon clippy  # watch clippy (most useful default)
```

### cargo-nextest — faster tests

**[cargo-nextest](https://nexte.st)** is a drop-in replacement for `cargo test` with better output, parallelism, and retry support.

```sh
nt            # alias: cargo nextest run
nta           # alias: cargo nextest run --all
cargo nextest run <test_name>
```

### cargo-audit — security audit

**[cargo-audit](https://rustsec.org)** checks `Cargo.lock` against the RustSec advisory database.

```sh
audit         # alias: cargo audit
cargo audit fix   # attempt automatic remediation
```

### cargo-expand — macro expansion

**[cargo-expand](https://github.com/dtolnay/cargo-expand)** shows the fully expanded Rust source after macro substitution — invaluable for debugging proc macros.

```sh
expand <module>   # alias: cargo expand <module>
expand            # expand entire crate
```

### Workflow

- Run `bacon clippy` in a split while coding — instant feedback without leaving the editor
- `nt` instead of `cargo test` everywhere — faster, cleaner output, JUnit XML for CI
- `cargo audit` in pre-push hook or CI to catch vulnerabilities before they ship
- `rdb` — debug binary; `rdt [filter]` — debug a specific test (both use `rust-lldb`)

---

## Go Tools — air, sqlc, gotestsum, dlv, oapi-codegen

All installed via mise.

### air — live reload

**[air](https://github.com/air-verse/air)** watches your project and rebuilds/restarts on file save.

```sh
air init    # scaffold .air.toml in project root
air         # start live reload (runs in a dedicated WezTerm pane)
```

### sqlc — type-safe SQL

**[sqlc](https://sqlc.dev)** generates type-safe Go from raw SQL. Write `schema.sql` + `queries.sql`, run generate, get Go code. No ORM needed.

```sh
sqlc init      # create sqlc.yaml
sqlcg          # alias: sqlc generate — regenerate from schema + queries
sqlcv          # alias: sqlc vet — lint queries against schema
```

### gotestsum — prettier tests

**[gotestsum](https://github.com/gotestyourself/gotestsum)** is a drop-in for `go test` with better output and watch mode.

```sh
gw             # alias: gotestsum — run all tests with pretty output
gwa            # alias: gotestsum --watch — rerun on file save
gwf            # alias: gotestsum --format testname — show individual test names
```

### richgo — colored go test output

**[richgo](https://github.com/kyoh86/richgo)** is a drop-in for `go test` that adds color-coded pass/fail output. Used by `hx-gotest.sh` (Helix test runner) and the `got`/`gota` shell aliases.

```sh
got            # alias: richgo test ./... — run all tests with color
gota           # alias: richgo test ./... -v — verbose with color
richgo test -run ^TestFoo$ ./pkg/...
```

### dlv — Go debugger

**[dlv](https://github.com/go-delve/delve)** is the standard Go debugger, with DAP support for editor integration.

```sh
dlvr                         # alias: dlv debug . (debug current package binary)
dlvt [TestName]              # alias: dlv test . -- -run TestName
dlv attach <pid>             # attach to running process
dlv dap --listen=:2345       # start DAP server for Helix/editor integration
```

### gdlv — GUI companion for dlv

**[gdlv](https://github.com/aarzilli/gdlv)** is a native GUI frontend for dlv. Use it alongside `dlv` CLI via `dlv --accept-multiclient`:

```sh
# Both CLI and GUI connected to the same debug session:
dlvg debug ./...             # launch headless dlv + gdlv GUI + dlv CLI
dlvg test ./pkg/...          # debug tests with companion
dlvg attach <pid>            # attach to running process
```

`dlvg` is a shell function that:
1. Starts `dlv debug --headless --listen=:2345 --accept-multiclient`
2. Opens `gdlv connect :2345` (native macOS GUI window)
3. Connects `dlv connect :2345` in current terminal pane for CLI control

Use the CLI for breakpoints/stepping; gdlv shows goroutines, variables, and stack frames visually.

### oapi-codegen — OpenAPI → Go

**[oapi-codegen](https://github.com/oapi-codegen/oapi-codegen)** generates Go types and server/client stubs from an OpenAPI spec. Pairs with prism (same spec drives both mock server and generated code).

```sh
oapi-codegen -generate types,server -package api openapi.yaml > api/api.gen.go
oapi-codegen -generate types -package api openapi.yaml > api/types.gen.go
```

### Workflow

- Run `air` in one pane, `gwa` in another — instant feedback loop
- `oapi-codegen` + `prism`: spec-first workflow — generate Go stubs and mock server from the same OpenAPI file
- `dlvr` to debug the binary, `dlvt TestName` to debug a specific test; set breakpoints with `b funcname` then `continue`
- `dlv dap --listen=:2345` then connect from Helix for breakpoint debugging via DAP

---

## SSH

SSH agent provided by **Bitwarden desktop app**.

```sh
export SSH_AUTH_SOCK=~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
```

Set in `~/.zshrc`. Make sure Bitwarden SSH agent is enabled in Bitwarden →
Settings → SSH Agent.

---

## TypeScript Tools — biome, tsx, knip

**[biome](https://biomejs.dev)** (mise) — fast all-in-one formatter + linter for JS/TS/JSON. Replaces ESLint + Prettier with a single tool. No config needed for basic use.

**[tsx](https://github.com/privatenumber/tsx)** (mise) — run TypeScript files directly without compiling. Drop-in replacement for `ts-node`.

**[knip](https://knip.dev)** (mise) — finds unused exports, dependencies, and files in TypeScript projects.

```sh
bio check --apply   # biof alias: format + lint fix
bio check           # bioc alias: check only
tsx file.ts         # run TypeScript directly
knip                # find dead code and unused deps
```

### Aliases

```sh
bio='biome'
biof='biome format --write'
bioc='biome check --apply'
```

---

## Slides — terminal presentations

**[slides](https://github.com/maaslalani/slides)** (brew) — render markdown as a terminal slideshow. Uses `---` as slide separator.

```sh
slides presentation.md   # sl alias: start slideshow
```

Navigate with arrow keys, `q` to quit.

---

## File Manager — yazi

**[yazi](https://yazi-rs.github.io/)** (mise) — blazing-fast terminal file manager with image preview, bulk rename, and Helix integration. Shell wrapper `y` changes the working directory on exit.

```sh
y                    # open yazi; cd to selected dir on exit
```

Key bindings: `hjkl` to navigate, `Enter` to open, `Space` to select, `y` to yank, `p` paste, `d` cut, `q` quit.

Integrated into Helix via `Space , e` (`hx-explorer.sh`).

---

## HTTP Testing — hurl

**[hurl](https://hurl.dev)** (mise) — run HTTP requests defined in plain text `.hurl` files. Great for API integration tests you can commit alongside code.

```sh
hurl request.hurl                  # run a request file
hurl --test *.hurl                 # run all as tests, report pass/fail
hurl --variable host=localhost:8080 api.hurl
```

Example `.hurl` file:
```
GET http://localhost:8080/api/users
HTTP 200
[Asserts]
jsonpath "$.count" > 0
```

---

## System Monitor — bottom

**[bottom](https://clementtsang.github.io/bottom/)** (`btm`, mise) — cross-platform TUI process/system monitor. Better than `top`/`htop`.

```sh
btm        # open TUI monitor
btm -b     # basic mode (no graphs)
```

Key bindings: `dd` kill process, `/` filter, `Tab` switch widget, `q` quit.

---

## YAML Processor — yq

**[yq](https://mikefarah.gitbook.io/yq/)** (mise) — jq-like processor for YAML, JSON, TOML, XML. Same query syntax, reads/writes YAML natively.

```sh
yq '.key.nested' file.yaml         # extract a value
yq -i '.version = "2.0"' file.yaml # edit in-place
cat file.yaml | yq -o json          # convert YAML → JSON
yq e 'select(.kind == "Service")' k8s.yaml   # filter k8s manifests
```
