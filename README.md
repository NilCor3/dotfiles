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
- [Editors](#editors)
  - [Helix](#helix)
  - [Helix WezTerm Integration](#helix-wezterm-integration)
  - [hx-gotest](#hx-gotest)
- [macOS Utilities](#macos-utilities)
- [Manual Backup & Restore](#manual-backup--restore)
- [Updating macOS Defaults](#updating-macos-defaults)
- [Database tools](#database-tools)
- [Postgres CLI — pgcli](#postgres-cli--pgcli)
- [Git — Merge Conflicts](#git--merge-conflicts)
- [File Listing — eza](#file-listing--eza)
- [HTTP Client — xh](#http-client--xh)
- [Mock REST — prism + json-server](#mock-rest--prism--json-server)
- [Local AI — ollama + mods](#local-ai--ollama--mods)
- [Notes — marksman + glow](#notes--marksman--glow)
- [JSON — jq, jnv, fx](#json--jq-jnv-fx)
- [Rust Tools](#rust-tools--bacon-cargo-nextest-cargo-audit-cargo-expand)
- [Go Tools](#go-tools--air-sqlc-gotestsum-dlv-oapi-codegen)
- [TypeScript Tools — biome, tsx, knip](#typescript-tools--biome-tsx-knip)
- [Slides — terminal presentations](#slides--terminal-presentations)
- [SSH](#ssh)

---


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
- 🌐 **[xh](https://github.com/ducaale/xh)** — fast, friendly HTTP client for the terminal (httpie compatible)
- 📂 **[eza](https://eza.rocks)** — modern `ls` with icons, git status, and tree view
- 🐘 **[pgcli](https://www.pgcli.com)** — postgres CLI with autocomplete, syntax highlighting and named queries
- 🎭 **[prism](https://stoplight.io/open-source/prism)** + **[json-server](https://github.com/typicode/json-server)** — mock REST APIs from OpenAPI spec or plain JSON
- 🔄 **[air](https://github.com/air-verse/air)** — live reload for Go servers on file save
- 🗄️ **[sqlc](https://sqlc.dev)** — generate type-safe Go from SQL queries
- 🧪 **[gotestsum](https://github.com/gotestyourself/gotestsum)** — prettier Go test output with watch mode
- 🐛 **[dlv](https://github.com/go-delve/delve)** — Go debugger with DAP support for editor integration
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

**[bat](https://github.com/sharkdp/bat)** (mise) — `cat` with syntax highlighting and line numbers. Used automatically in all fzf previews (`nf`, `nft`, `fhx`, etc.).

```sh
bat file.rs                    # syntax-highlighted file view
bat -l json file.json          # explicit language
xh api.example.com | bat -l json   # pipe with language hint
```

---

## Terminal — WezTerm

Config at `~/.config/wezterm/wezterm.lua`. Handles both terminal emulation and multiplexing (no tmux/zellij).

**LEADER key**: `CTRL+SHIFT+Space` (timeout 1s)

### Keybindings

| Key | Action |
|-----|--------|
| `LEADER s` | Split pane horizontal (30%) |
| `LEADER v` | Split pane vertical (40%) |
| `LEADER h/j/k/l` | Navigate panes (mirrors Helix `CTRL+w h/j/k/l`) |
| `ALT + h/j/k/l` | Resize pane |
| `LEADER z` | Zoom/unzoom current pane (toggle focus) |
| `LEADER Z` | Toggle auto-collapse on current pane (collapses to 1 line on nav away, restores on nav back) |
| `LEADER w` | Close current pane |
| `LEADER p` | Pick pane (visual selector) |
| `LEADER P` | Swap pane with active |
| `LEADER n` | Move pane to new tab |
| `LEADER N` | Move pane to new window |
| `LEADER t` | New tab |
| `LEADER o` | Last tab |
| `LEADER g` | Open lazygit in new tab |
| `LEADER c` | Enter copy mode (hjkl, v/V/x, w/e/b, f/t, y, /) |
| `LEADER y` | Enter scroll mode (j/k, d/u, g/G, v, /) |
| `CTRL+SHIFT+j/k` | Scroll view down/up 1 line (no mode needed) |
| `CTRL+SHIFT+d/u` | Scroll view down/up half page (no mode needed) |
| `ALT+1-9` | Switch to tab N |
| `LEADER Enter` | Toggle fullscreen |
| `LEADER r` | Restore session (fuzzy loader) |
| `LEADER b` | Restore session in current window |

**Plugins** (auto-updated on start):
- `modal.wezterm` — vim-like copy and scroll modes
- `resurrect.wezterm` — session save/restore (auto-saves every 15 min)
- `smart_workspace_switcher.wezterm` — fuzzy workspace switcher



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
| `Space , a` | Toggle AI provider (Copilot ↔ ollama) | `hx-toggle-ai.sh` |

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

## Git — Configuration

- **Pager**: [delta](https://dandavison.github.io/delta/) with `gruvmax-fang` theme — syntax-highlighted diffs in terminal. Installed via mise.
- **Merge style**: `zdiff3` (shows base in conflicts)
- **Pull**: rebase by default
- **SSH agent**: Bitwarden SSH agent (`com.bitwarden.desktop`)

Config: `~/.gitconfig`

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

- Run `bacon clippy` in a WezTerm split while coding — instant feedback without leaving the editor
- `nt` instead of `cargo test` everywhere — faster, cleaner output, JUnit XML for CI
- `cargo audit` in pre-push hook or CI to catch vulnerabilities before they ship

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

### dlv — Go debugger

**[dlv](https://github.com/go-delve/delve)** is the standard Go debugger, with DAP support for editor integration.

```sh
dlv debug                    # debug current package
dlv attach <pid>             # attach to running process
dlv dap --listen=:2345       # start DAP server for Helix/editor integration
```

### oapi-codegen — OpenAPI → Go

**[oapi-codegen](https://github.com/oapi-codegen/oapi-codegen)** generates Go types and server/client stubs from an OpenAPI spec. Pairs with prism (same spec drives both mock server and generated code).

```sh
oapi-codegen -generate types,server -package api openapi.yaml > api/api.gen.go
oapi-codegen -generate types -package api openapi.yaml > api/types.gen.go
```

### Workflow

- Run `air` in one WezTerm pane, `gwa` in another — instant feedback loop
- `oapi-codegen` + `prism`: spec-first workflow — generate Go stubs and mock server from the same OpenAPI file
- `dlv dap --listen=:2345` then connect from Helix for breakpoint debugging

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
