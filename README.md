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
- [Setup](#setup)
- [Installation](#installation)
- [Shell](#shell)
- [Terminal & Multiplexer](#terminal--multiplexer)
- [Editor](#editor)
  - [Helix](#helix)
  - [Neovim](#neovim)
- [Git](#git)
- [File Management](#file-management)
- [HTTP & APIs](#http--apis)
- [Database](#database)
- [Kafka](#kafka)
- [Go](#go)
- [Rust](#rust)
- [TypeScript](#typescript)
- [JSON & YAML](#json--yaml)
- [Notes & Todos](#notes--todos)
- [AI](#ai)
- [System & Utilities](#system--utilities)
- [macOS](#macos)
- [Dotfiles](#dotfiles)

---

## Features

- 🖥️ **[WezTerm](https://wezfurlong.org/wezterm/)** — GPU-accelerated terminal (fonts, window, clipboard)
- ✏️ **[Helix](https://helix-editor.com/)** — modal editor with full LSP support (Go, Java, Rust); custom fork with inline completion
- ⌨️ **[Neovim](https://neovim.io/)** — lean nvim 0.12 setup with lazy.nvim; native LSP (no Mason), blink.cmp, Copilot, snacks picker
- 🗂️ **[tmux](#terminal--multiplexer)** — multiplexer with vi copy mode, sessions, and editor-mirrored keybinds (`Ctrl+Space` leader)
- 🔍 **[Helix integration](#helix-integration)** — blame, lazygit, markdown preview, and test runner via tmux panes
- 🧪 **[hx-gotest](#hx-gotest--hx-rusttest)** — custom Go AST tool to run the exact test under cursor (subtests, table-driven tests)
- 🔐 **Age-encrypted secrets** in dotfiles — key stored at `~/.config/age/chezmoi-key.txt`
- 📦 **[mise](https://mise.jdx.dev)** — polyglot runtime manager (Go, Node, Java, Python, Rust tools)
- 🐚 **Zsh + Zinit** with curated plugins, aliases, and `navi` cheatsheet
- 🍎 **macOS defaults** applied via reproducible shell script with drift detection
- 🗂️ **[yazi](https://yazi-rs.github.io/)** file explorer and **[tig](https://jonas.github.io/tig/)** blame — both integrated into Helix
- 🌐 **[xh](https://github.com/ducaale/xh)** — fast, friendly HTTP client for the terminal (httpie compatible)
- 📂 **[eza](https://eza.rocks)** — modern `ls` with icons, git status, and tree view
- 🐘 **[pgcli](https://www.pgcli.com)** — postgres CLI with autocomplete, syntax highlighting and named queries
- 🎭 **[prism](https://stoplight.io/open-source/prism)** — mock REST APIs from OpenAPI spec
- 🔄 **[air](https://github.com/air-verse/air)** — live reload for Go servers on file save
- 🧪 **[gotestsum](https://github.com/gotestyourself/gotestsum)** — prettier Go test output with watch mode
- 🌈 **[richgo](https://github.com/kyoh86/richgo)** — colored `go test` output; used by Helix test runner and `got`/`gota` aliases
- 🐛 **[dlv](https://github.com/go-delve/delve)** — Go debugger with DAP support for editor integration
- 🔭 **[gdlv](https://github.com/aarzilli/gdlv)** — GUI companion for dlv; use `dlvg` to run both together
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
- 🤖 **[GitHub Copilot CLI](https://github.com/github/gh-copilot)** — AI assistant wired into the terminal with AGENTS.md context
- 🐦 **[kcat](https://github.com/edenhill/kcat)** — netcat for Kafka; produce and consume messages from any broker
- 🖥️ **[kaskade](https://github.com/sauljabin/kaskade)** — TUI Kafka browser with filtering and JSON preview

---

## Philosophy

**Configure, compose, own** — every tool in this setup was chosen because it exposes its internals as plain text, can be scripted to work with other tools, and doesn't lock you into a vendor.

**AI as a peer in the toolchain, not a replacement for it.** The goal is to keep humans in full control of the environment while letting AI handle the tedious parts. A few principles that guide how AI is incorporated here:

- **Context over magic** — `AGENTS.md` files at `~/`, `~/dev/`, and `~/source/` give AI agents explicit knowledge of the setup: what's managed by chezmoi, where aliases live, how commits are formatted, what the philosophy is. An agent that understands the environment makes better decisions than one guessing from scratch.
- **AI works inside the tools, not around them** — Copilot LSP runs inside Helix. The CLI runs inside WezTerm. They fit into the existing keyboard-driven workflow rather than requiring a separate chat window or IDE.
- **Own your prompts and instructions** — `AGENTS.md` files are version-controlled dotfiles. Custom agents live in `~/.copilot/agents/`. Instructions evolve with the setup.
- **Small tools compose better with AI** — `hx-gotest` does one thing (find the right Go test pattern from the AST). That focus makes it easy for AI to understand, extend, and reason about. The same applies to every script in `~/.config/helix/scripts/`.
- **AI should never be the path of least resistance to bypassing understanding** — use AI to go faster on things you understand, not to skip understanding things that matter.

---

## Setup

### Quick Start

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

# 7. Install brew packages (see Installation section below)

# 8. Set up GitHub Copilot CLI (see AI section)
```

### Secrets

Secrets are encrypted with [age](https://age-encryption.org).

- Age key lives at `~/.config/age/chezmoi-key.txt` — **never commit this**
- chezmoi config at `~/.config/chezmoi/chezmoi.toml` references the key

---

## Installation

### Brew Formulas

Core tools installed via Homebrew:

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
  mods \
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

### Mise — Runtime Version Manager

All runtimes and dev tools are managed via [mise](https://mise.jdx.dev).
Global config: `~/.config/mise/config.toml`

---

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

## Editor

### Helix

Built from source (custom fork with inline completion support), binary at `~/hx/builds/current/bin/hx`.
Config: `~/.config/helix/`

**Fork:** `github.com/NilCor3/helix` on branch `feature/inline-completion` — rebased onto upstream master, with [devmanuelli's inline completion PR](https://github.com/devmanuelli/helix) merged in for Copilot inline suggestions.

**After a fresh machine restore:**

```sh
git clone git@github.com:NilCor3/helix.git ~/hx/source
cd ~/hx/source
git remote add upstream https://github.com/helix-editor/helix
git remote add devmanuelli https://github.com/devmanuelli/helix.git
git checkout feature/inline-completion
cargo build --release
cd ~/hx && bash setup_build.sh
python3 ~/hx/copilot_auth.py   # authenticate Copilot (first time only)
```

`mise` config adds `~/hx/builds/current/bin` to PATH and sets `HELIX_RUNTIME` automatically.

**Keeping Helix up to date:**

```sh
cd ~/hx/source
git fetch upstream
git rebase upstream/master
cargo build --release
cd ~/hx && bash setup_build.sh
```

LSP setup:

- **Java** — jdtls (Homebrew) + Lombok + Fortnox code style
- **Go** — gopls with staticcheck, gofumpt, full inlay hints
- **Rust** — rust-analyzer with Clippy on save, proc macros, inlay hints
- **SQL** — postgres-language-server (brew)
- **All languages** — Copilot LSP for inline completion (`A-i` to trigger)

#### Keybindings

| Key | Action |
|-----|--------|
| `C-s` | Save current buffer (normal + insert mode) |
| `C-S-s` | Save all buffers |
| `C-g` | Open lazygit in a new buffer |
| `esc` | Collapse selection, keep primary |
| `A-t` | Insert `- [ ] ` todo checkbox below cursor (`.md` files only) |

### Helix Integration

All keybindings under `Space , ` in normal mode. Scripts at `~/.config/helix/scripts/`.

| Key | Action | Script |
|-----|--------|--------|
| `C-e` | File explorer at current buffer's directory | built-in |
| `Space , b` | Git blame at cursor line (tig popup) | `hx-blame.sh` |
| `Space , g` | Lazygit in floating pane | `hx-lazygit.sh` |
| `Space , t` | Run test under cursor (Go or Rust) | `hx-test.sh` |
| `Space , T` | Run whole test function | `hx-test.sh` |
| `Space , F` | Run all tests in file | `hx-test.sh` |
| `Space , m` | Markdown preview (glow) | `hx-markdown.sh` |
| `Space , y` | Open yazi at current buffer's dir | `hx-yazi.sh` |

### hx-gotest + hx-rusttest

**Go:** `~/dev/hx-gotest/` — a small Go CLI using `go/ast` to determine the exact
`go test -run` pattern for the cursor position. Test output is piped through **richgo** for colored output.

**Rust:** `~/.config/helix/scripts/hx-rusttest.py` — Python parser that finds `#[test]`/`#[tokio::test]` functions at the cursor, including the enclosing `mod` name. Runs via `cargo nextest run`.

Both dispatched by `hx-test.sh` based on file extension.

| Mode | What runs | Example pattern |
|------|-----------|-----------------|
| `cursor` | Subtest at cursor (or whole func if none) | `^TestFoo$/^bar_case$` |
| `func` | Whole test func, all subtests | `^TestFoo$` |
| `file` | All Test* funcs in the file | `^(TestFoo\|TestBar)$` |

Smart detection: `t.Run("name", ...)` exact match · table-driven by first string field or named `name`/`desc` field · nested subtests → `^TestA$/^SubB$`.

To rebuild after changes:
```sh
cd ~/dev/hx-gotest && go build -o ~/.local/bin/hx-gotest .
```

---

### Neovim

Installed via Homebrew (`brew install neovim`, v0.12.0). Config: `~/.config/nvim/`.

**Design goal:** Helix-lean feel inside nvim. No Mason, no DAP UI, no neotest framework. LSP via nvim 0.12's native `vim.lsp.config`/`vim.lsp.enable` API. Plugins are single-purpose and composable.

**Plugin manager:** lazy.nvim — `nvim --headless "+Lazy restore" +qa` to reproduce from lockfile.

#### Key plugins

| Plugin | Purpose |
|--------|---------|
| `snacks.nvim` | Picker (files, grep, LSP, git log, diagnostics), dashboard, notifier |
| `blink.cmp` | Completion (pure Lua, no binary downloads) |
| `copilot.lua` + `CopilotChat.nvim` | Ghost text (`<M-a>`), on-demand popup (`<C-a>`), AI chat (`<leader>aa`) |
| `flash.nvim` | Jump with `s`, treesitter select with `S` |
| `oil.nvim` | File browser at `-` |
| `diagflow.nvim` | Diagnostics rendered top-right (no inline virtual text) |
| `mini.nvim` | textobjects, surround (`ys`/`ds`/`cs`), statusline, icons, comment |
| `gitsigns.nvim` | Hunk nav `]h`/`[h`, stage/reset/preview, blame |
| `conform.nvim` | Async format-on-save: stylua, rustfmt, prettierd, shfmt, sql-formatter, php-cs-fixer |
| `nvim-lint` | golangcilint (Go), shellcheck (shell), hadolint (Docker), markdownlint (md) |
| `nvim-jdtls` | Java LSP via `ftplugin/java.lua` |
| `nvim-ts-autotag` | Auto-close and auto-rename paired JSX/HTML tags |
| `vim-sleuth` | Detects indent style (tabs/spaces/width) from file content |

#### Treesitter (branch: `main`)

Uses `nvim-treesitter` main branch (required for nvim 0.12). Parser management is explicit:
parsers are installed via `require('nvim-treesitter').install(list)` on startup (idempotent).
Requires `tree-sitter-cli` (brew) for grammar compilation.

**Indentation** — three-layer system:
1. `vim-sleuth` — detects tabs/spaces/width from file content
2. editorconfig (nvim built-in) — `.editorconfig` takes priority
3. Treesitter `indentexpr` — AST-aware new-line indent (`o`/Enter inside blocks)

**Installed parsers:** bash, c, css, dockerfile, go, graphql, html, java, javascript, json,
lua, markdown, php, rust, sql, toml, tsx, typescript, xml, yaml, and more.

#### LSP (native, no Mason)

| Server | Language | Installed via |
|--------|----------|---------------|
| `gopls` | Go | mise |
| `rust_analyzer` | Rust | rustup |
| `lua_ls` | Lua | brew |
| `vtsls`, `eslint` | TypeScript/JS/React | mise npm |
| `cssls`, `cssmodules_ls` | CSS/CSS Modules | mise npm |
| `jsonls` | JSON (with SchemaStore) | mise npm |
| `bashls` | Shell | mise npm |
| `dockerls` | Dockerfile | mise npm |
| `intelephense` | PHP | mise npm |
| `marksman` | Markdown | mise |
| `sqlls` | SQL | mise npm |

Java (jdtls) is separate: JARs at `~/.local/share/nvim-java/`, provisioned by `run_once_setup-java-lsp.sh`.

**eslint settings note:** `nodePath`, `experimental`, and `problems` must be explicitly set to
avoid TypeError crashes in the vscode-eslint-language-server JS code (undefined ≠ null).

#### Key keymaps (leader = `<Space>`)

| Key | Action |
|-----|--------|
| `<leader><space>` | Smart file picker |
| `<leader>/` | Grep |
| `<leader>ff/fg/fr` | Find files / git files / recent |
| `<leader>fd/fD` | Workspace / buffer diagnostics |
| `<leader>fk` | Keymaps |
| `<leader>gd/gr/gI/gy` | LSP: definition / references / impl / type |
| `<leader>ca/cr` | Code action / rename |
| `<leader>gB` | Git blame line |
| `<leader>gl` | Git log (current file) |
| `]h` / `[h` | Next / prev hunk |
| `<leader>ghs/ghr/ghp` | Stage / reset / preview hunk |
| `<leader>tr` | Build/run in tmux pane |
| `<leader>ts/tf/tF/ta` | Test: cursor / func / file / all |
| `<leader>uw` | Toggle line wrap |
| `<leader>ul` | Toggle whitespace display (off → minimal → full) |
| `<leader>ud` | Toggle diagnostic virtual text |
| `<leader>uc` | Toggle colorcolumn (80/120) |
| `<leader>uG` | Toggle Copilot ghost text |
| `s` / `S` | Flash jump / treesitter select |
| `-` | Oil (parent dir) |

#### Scripts

- `~/.config/nvim/bin/nvim-test.sh` — sends test commands to tmux pane; uses `hx-gotest` for Go, `cargo nextest` for Rust
- `~/.config/nvim/bin/tmux-runner.sh` — build/run commands to tmux pane `.1` by filetype

---

## Git

### Configuration

- **Pager**: [delta](https://dandavison.github.io/delta/) with `gruvmax-fang` theme — syntax-highlighted diffs. Installed via mise.
- **Merge style**: `zdiff3` (shows base in conflicts)
- **Pull**: rebase by default
- **SSH agent**: Bitwarden SSH agent (`com.bitwarden.desktop`)

Config: `~/.gitconfig`

### Shortcuts

#### Static aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git shorthand |
| `gs` | `git status` | Status |
| `gaa` | `git add --all` | Stage all |
| `gc` | `git commit` | Commit |
| `gcm` | `git commit -m` | Commit with message |
| `gca` | `git commit --amend --no-edit` | Amend last commit |
| `gp` | `git push` | Push |
| `gpf` | `git push --force-with-lease` | Force push (safe) |
| `gpl` | `git pull --rebase` | Pull with rebase |
| `gb` | `git branch` | List branches |
| `gds` | `git diff --staged` | Diff staged |
| `gl` | `git log --oneline --graph --decorate` | Pretty log |
| `gst` | `git stash` | Stash |
| `gstp` | `git stash pop` | Stash pop |
| `gf` | `git fetch --all --prune` | Fetch + prune |
| `gcl` | `git clone` | Clone |
| `lg` | `lazygit` | Open lazygit TUI |

#### forgit — interactive fzf commands

[forgit](https://github.com/wfxr/forgit) replaces common git operations with fzf-powered interactive selectors.

| Command | Description |
|---------|-------------|
| `ga` | Interactive `git add` with diff preview |
| `gd` | Interactive `git diff` viewer |
| `glo` | Interactive `git log` viewer |
| `gcb` | Interactive `git checkout <branch>` |
| `gcf` | Interactive `git checkout <file>` |
| `gco` | Interactive `git checkout <commit>` |
| `gsw` | Interactive `git switch <branch>` |
| `gbd` | Interactive `git branch -D` |
| `gss` | Interactive stash viewer |
| `gcp` | Interactive `git cherry-pick` |
| `grb` | Interactive `git rebase -i` |
| `gbl` | Interactive `git blame` |
| `gfu` | Interactive fixup + autosquash |
| `gclean` | Interactive `git clean` |
| `grl` | Interactive `git reflog` |

### Merge Conflicts

Standard git 3-way merge with `conflictStyle = zdiff3` (shows the common ancestor in conflict markers for better context). lazygit handles interactive resolution.

- **`zdiff3`** — conflict markers include the ancestor block, making it clear what both sides changed from
- **lazygit** — `e` on a conflicted file → 3-panel view, pick ours/theirs/base per hunk; open in Helix for manual edits

```sh
git diff --name-only --diff-filter=U   # list all conflicted files
```

---

## File Management

### eza

**[eza](https://eza.rocks)** replaces `ls` with icons, colour coding, git status per file, and tree view. Installed via mise.

```sh
ll      # eza -lah --icons --git   — detailed list with git status
la      # eza -a --icons           — all files including hidden
lt      # eza --tree --icons -L 2  — tree view, 2 levels
llt     # eza -lah --tree -L 2     — detailed tree
```

The `--git` flag shows per-file status inline (`N` new, `M` modified, `I` ignored).

Requires a Nerd Font — `font-fira-mono-nerd-font` is installed via brew cask.

### yazi

**[yazi](https://yazi-rs.github.io/)** (mise) — blazing-fast terminal file manager with image preview, bulk rename, and Helix integration. Shell wrapper `y` changes the working directory on exit.

```sh
y                    # open yazi; cd to selected dir on exit
```

Key bindings: `hjkl` navigate · `Enter` open · `Space` select · `y` yank · `p` paste · `d` cut · `q` quit.

Integrated into Helix via `Space , y` (`hx-yazi.sh`).

---

## HTTP & APIs

### xh — HTTP client

**[xh](https://github.com/ducaale/xh)** is a fast, friendly HTTP client (httpie-compatible syntax, written in Rust).

```sh
http=xh          # alias
https='xh --https'

xh httpbin.org/get
xh POST api.example.com/users name=Alice age:=30   # = string, := raw/number
xh api.example.com Authorization:"Bearer $TOKEN"
xh --print=b api.example.com/data                  # body only (pipe-friendly)
xh --download https://example.com/file.zip
xh --session=myapp POST api.example.com/login username=me password=secret
xh --session=myapp api.example.com/profile         # reuses session
xh --offline POST api.example.com key=value        # preview without sending
xh --follow https://example.com
```

Pairs well with: `| jq`, `| fx`, `| bat -l json`. Sessions stored in `~/.config/xh/sessions/`.

### httpyac — .http file runner

**[httpyac](https://httpyac.github.io/)** (mise npm) — run `.http` files with environments, variables, and assertions.

```sh
henv <file> <env>     # set httpyac environment file and name
hrun [file]           # run .http file (or current if no arg)
```

Supports `@name` request names, `### separator` between requests, and environment files for staging/prod.

### hurl — HTTP integration tests

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

### Mock REST — prism

**[prism](https://stoplight.io/open-source/prism)** mocks from an OpenAPI/Swagger spec. Can also act as a validating proxy to a real API.

```sh
prism mock openapi.yaml                          # mock from local spec
prism mock https://api.example.com/openapi.yaml  # mock from remote spec
prism proxy openapi.yaml https://real-api.com    # validating proxy
```

Compose with xh: `prism mock openapi.yaml &` then `xh :3000/users` — full local request/response flow. Prism validates requests and responses against the spec.

---

## Database

### pgcli

**[pgcli](https://www.pgcli.com)** enhances `psql` with autocomplete, syntax highlighting, and named query shortcuts.

```sh
pgc <database>                                    # alias for pgcli
pgcli -h <host> -U <user> <database>
pgcli postgresql://user:pass@host/db
```

Config at `~/.config/pgcli/config`. Open quickly with **tmux `Ctrl+Space Q`** — spawns a popup from anywhere.

#### Key meta-commands

| Command | Description |
|---------|-------------|
| `\dt` | List all tables |
| `\d <table>` | Describe table |
| `\l` | List databases |
| `\ns <name> <query>` | Save named query |
| `\n <name>` | Run named query |
| `\copy (...) TO 'file.csv'` | Export to CSV |
| `\e` | Open query in `$EDITOR` (Helix) |

Named queries (`\ns`) stored in `~/.config/pgcli/named_queries.cfg`.

### Postgres Language Server

**[postgres-language-server](https://github.com/supabase-community/postgres-language-server)** (brew) provides LSP support for `.sql` files in Helix: syntax diagnostics, formatting, autocomplete (with DB connection), migration linting.

For autocomplete/type checking, create a per-project config:
```sh
postgres-language-server init
# edit generated file to set DB credentials
# add postgres-language-server.jsonc to .gitignore
```

### lazysql + DBeaver

- **[lazysql](https://github.com/jorgerojas26/lazysql)** (mise) — TUI SQL client; Postgres, MySQL, SQLite
- **DBeaver Community** (cask) — GUI client for schema exploration

---

## Kafka

Client-only tools — no local broker needed. Connect directly to remote clusters.

### kcat

**[kcat](https://github.com/edenhill/kcat)** (brew) — netcat for Kafka. C binary, no JVM required.

```sh
# Consume
kcat -C -b broker:9092 -t my-topic
kcat -C -b broker:9092 -t my-topic -o -10 -e   # last 10 messages then exit

# Produce
echo "hello" | kcat -P -b broker:9092 -t my-topic
kcat -P -b broker:9092 -t my-topic < messages.txt

# Inspect
kcat -L -b broker:9092                          # list topics, partitions, brokers
kcat -C -b broker:9092 -t my-topic -f '%k %o %s\n'  # show key + offset + value

# SASL/SSL auth
kcat -C -b broker:9092 -t my-topic \
  -X security.protocol=SASL_SSL \
  -X sasl.mechanisms=PLAIN \
  -X sasl.username=user \
  -X sasl.password=pass
```

### kaskade

**[kaskade](https://github.com/sauljabin/kaskade)** (brew) — interactive TUI for Kafka. Browse topics, consume messages with real-time filtering by key/value/header/partition. Supports JSON, Avro, Protobuf deserialization.

```sh
kaskade consumer -b my-kafka:9092 -t my-topic
```

---

## Go

All installed via mise.

### air — live reload

**[air](https://github.com/air-verse/air)** watches your project and rebuilds/restarts on file save.

```sh
air init    # scaffold .air.toml in project root
air         # start live reload
```

### gotestsum + richgo — prettier tests

**[gotestsum](https://github.com/gotestyourself/gotestsum)**:

```sh
gw             # gotestsum — run all tests with pretty output
gwa            # gotestsum --watch — rerun on file save
gwf            # gotestsum --format testname — show individual test names
```

**[richgo](https://github.com/kyoh86/richgo)** — color-coded pass/fail output. Used by `hx-gotest.sh` and `got`/`gota` aliases:

```sh
got            # richgo test ./... — run all tests with color
gota           # richgo test ./... -v — verbose with color
```

### dlv — Go debugger

**[dlv](https://github.com/go-delve/delve)** — standard Go debugger with DAP support.

```sh
dlvr                      # dlv debug . (debug current package)
dlvt [TestName]           # dlv test . -- -run TestName
dlv attach <pid>          # attach to running process
dlv dap --listen=:2345    # DAP server for Helix integration
```

### gdlv — GUI companion for dlv

**[gdlv](https://github.com/aarzilli/gdlv)** — native GUI frontend for dlv:

```sh
dlvg debug ./...          # headless dlv + gdlv GUI + dlv CLI connected together
dlvg test ./pkg/...
dlvg attach <pid>
```

`dlvg` starts `dlv --headless --listen=:2345 --accept-multiclient`, opens gdlv, then connects a CLI dlv client — all in one command.

### Workflow

- Run `air` in one pane, `gwa` in another — instant feedback loop
- `dlvr` to debug binary, `dlvt TestName` to debug a specific test
- `dlv dap --listen=:2345` → connect from Helix for breakpoint debugging via DAP

---

## Rust

All installed via mise (`cargo:` prefix).

### bacon — background watcher

**[bacon](https://dystroy.org/bacon/)** reruns on every file save:

```sh
bac           # bacon — default watch
bacon clippy  # watch clippy
```

### cargo-nextest — faster tests

**[cargo-nextest](https://nexte.st)** — drop-in for `cargo test` with better output and parallelism:

```sh
nt            # cargo nextest run
nta           # cargo nextest run --all
```

### cargo-audit — security audit

```sh
audit         # cargo audit
cargo audit fix
```

### cargo-expand — macro expansion

**[cargo-expand](https://github.com/dtolnay/cargo-expand)** — see fully expanded source after macro substitution:

```sh
expand <module>   # cargo expand <module>
expand            # expand entire crate
```

### Workflow

- `bacon clippy` in a split while coding — instant feedback
- `nt` everywhere — faster than `cargo test`, cleaner output
- `rdb` — debug binary; `rdt [filter]` — debug a specific test (both use `rust-lldb`)

---

## TypeScript

**[biome](https://biomejs.dev)** (mise) — fast all-in-one formatter + linter. Replaces ESLint + Prettier.

**[tsx](https://github.com/privatenumber/tsx)** (mise) — run TypeScript directly, no compile step.

**[knip](https://knip.dev)** (mise) — finds unused exports, dependencies, and files.

```sh
bio='biome'
biof='biome format --write'   # biof: format + fix
bioc='biome check --apply'    # bioc: check only

tsx file.ts     # run TypeScript directly
knip            # find dead code and unused deps
```

---

## JSON & YAML

### JSON — jq, jnv, fx

- **jq** — system-installed; standard for scripting and one-liners
- **[jnv](https://github.com/ynqa/jnv)** (mise) — interactive filter builder with live preview
- **[fx](https://fx.wtf)** (mise) — interactive explorer and JS-powered processor

```sh
xh api.example.com/data | jnv                    # build filter interactively
fx file.json                                     # explore interactively
fx file.json '.users.filter(u => u.active)'      # JS expression
xh api.example.com/data | jq -r '.items[].name'  # one-liner scripting
jq '[.[] | {name: .name, id: .id}]' file.json    # reshape
```

Workflow: **jnv** to discover the filter → **jq** to script it → **fx** for large nested structures.

### YAML — yq

**[yq](https://mikefarah.gitbook.io/yq/)** (mise) — jq-like processor for YAML, JSON, TOML, XML.

```sh
yq '.key.nested' file.yaml
yq -i '.version = "2.0"' file.yaml       # edit in-place
cat file.yaml | yq -o json               # convert YAML → JSON
yq e 'select(.kind == "Service")' k8s.yaml
```

---

## Notes & Todos

### Notes

Plain markdown files in `~/notes/` with frontmatter conventions. No app, no sync — just files, ripgrep, fzf, and Helix.

**Structure:**
```
~/notes/
├── journal/      # daily notes (type: daily)
├── work/         # meetings, issues, system docs (type: meeting|issue|system)
├── dev/          # tech reference (type: ref)
├── projects/     # personal projects, learning
└── scratch.md    # quick capture inbox
```

**Frontmatter:**
```yaml
---
type: meeting
tags: [blink, api]
date: 2026-02-27
---
```

#### Shell functions

```sh
n              # open ~/notes in Helix
ns             # open scratch.md
nj             # create/open today's journal (journal/YYYY-MM-DD.md)
nmeet <title>  # new meeting note with template
nissue <id>    # new issue note (work/issue-NOV-123.md)
nn <path>      # new note at relative path (creates frontmatter)
nf [query]     # fuzzy find by filename → open in Helix
nft <type>     # filter by frontmatter type
ntag <tag>     # filter by frontmatter tag
ng <pattern>   # ripgrep → fzf with match preview
ngs            # live interactive content search (opens at exact line)
ngl            # browse with glow TUI
nsync          # commit all changes and push
```

#### Tools

- **[marksman](https://github.com/artempyanykh/marksman)** (mise) — Helix LSP: `[[wiki link]]` completion, go-to-definition, find-references
- **[glow](https://github.com/charmbracelet/glow)** (mise) — TUI markdown browser; `ngl` opens the whole vault

#### Git sync

Auto-push on every commit via post-commit hook. Run `nsync` to commit + push.

Pre-commit validation blocks commits if `type:` or `date:` frontmatter is missing.

#### Workflow

- `ns` → quick capture → sort later
- `nj` → today's journal ready with date
- `nmeet blink-planning` → structured meeting template
- `ngs` → live search, opens at exact line
- `ngl` → TUI browsing, `glow file.md` → render before sharing

### Todos

Plain GFM checkboxes in `~/notes/todos/`.

```
~/notes/todos/
├── inbox.md    # quick capture
├── work.md
├── dev.md
├── personal.md
└── someday.md
```

Format: `- [ ] Task text #tag project:name`

#### Shell functions

```sh
ta [text]       # append to inbox.md (no args → open inbox in Helix)
tl              # fzf list → open in Helix at exact line
td              # mark done via fzf picker
tp [project]    # open a todo file
tg <tag>        # filter by #tag
```

`Alt+t` in Helix (normal or insert, `.md` files only) — inserts `- [ ] ` below cursor.

tmux `notes` layout: todos window (Helix 42.5% + tl 42.5% + shell 15%) + notes window (Helix 80% + shell 20%). `tl` opens files directly in the Helix pane when in the `notes:todos` session.

---

## AI

### GitHub Copilot CLI

Runs in WezTerm, reads `~/AGENTS.md` and folder-level `AGENTS.md` files for context.

```sh
brew install gh
gh auth login
gh extension install github/gh-copilot
gh copilot
```

The `~/.copilot/` directory:
- `agents/` — custom sub-agents (agent-writer, security-reviewer, tech-tutor, notes)
- `mcp-config.json` — MCP server configs
- `config.json` — UI preferences

Tracked in chezmoi. After a fresh apply, run `gh auth login` to re-authenticate.

### Claude Code

Claude Code CLI with custom slash commands in `~/.claude/commands/`. Invoke `/dotfiles` from any session to load the full dotfiles context.

### ollama + mods

**[ollama](https://ollama.com)** (mise) — local LLMs on Apple Silicon via Metal. Runs as a launchd background service.

```sh
launchctl load ~/Library/LaunchAgents/com.ollama.serve.plist    # start
launchctl unload ~/Library/LaunchAgents/com.ollama.serve.plist  # stop
curl -s http://localhost:11434                                    # check
ollama pull gemma3:4b           # ~2.5GB, general purpose
ollama pull qwen2.5-coder:7b    # ~4.5GB, code tasks
```

**[mods](https://github.com/charmbracelet/mods)** (brew) — pipe anything through an LLM:

```sh
ai='mods -a ollama -m gemma3:4b'          # local general
aic='mods -a ollama -m qwen2.5-coder:7b'  # local coder
m='mods'                                   # shorthand (default API)

cat file.go | ai "explain this code"
git diff | ai "write a concise commit message"
cat file.go | aic "review this for bugs"
cat file.md | m "summarize in 3 bullet points"
```

Use `ai`/`aic` for offline/private work; `m` for cloud models when you need higher quality. Pairs with `nreview <path>` for AI-assisted note review.

---

## System & Utilities

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

## macOS

### Utilities

| App | Purpose | Config |
|-----|---------|--------|
| [Amethyst](https://ianyh.com/amethyst/) | Tiling window manager | `~/.config/amethyst/amethyst.yml` in chezmoi |
| [Raycast](https://raycast.com) | Launcher, replaces Spotlight | iCloud sync |
| [AltTab](https://alt-tab-macos.netlify.app) | Windows-style app switcher | plist backup |
| [HyperKey](https://hyperkey.app) | Caps Lock → Hyper (⌃⌥⇧⌘) | plist backup |
| [Ice](https://icemenubar.app) | Menu bar manager | plist backup |
| [Finicky](https://github.com/johnste/finicky) | Browser router | `~/.finicky.js` in chezmoi |
| [Zen](https://zen-browser.app) | Default browser (Firefox-based) | Firefox account sync |
| [Bitwarden](https://bitwarden.com) | Password manager + SSH agent | Cloud-synced vault |
| [BetterMouse](https://better-mouse.com) | Mouse customization | Export/Import |
| [Keyboard Pilot](https://apps.apple.com/app/keyboard-pilot/id1496719023) | Per-app keyboard routing | GUI only |
| [TimeyMeet](https://apps.apple.com/app/timelyMeet/id1611090219) | Meeting join buttons in menu bar | No config |
| [Docker Desktop](https://docker.com/products/docker-desktop) | Container runtime | Sensible defaults |
| [Stats](https://github.com/exelban/stats) | System stats in menu bar | GUI only |
| [Marta](https://marta.sh) | Dual-pane file manager | chezmoi tracked |
| [PearCleaner](https://itsalin.com/appInfo/?id=pearcleaner) | App uninstaller | No config |
| [UTM](https://mac.getutm.app) | Virtual machines | No config |

### Backup & Restore

| App | Method | Location |
|-----|--------|----------|
| Amethyst | chezmoi | `~/.config/amethyst/amethyst.yml` |
| Finicky | chezmoi | `~/.finicky.js` |
| Marta | chezmoi | `~/Library/Application Support/org.yanex.marta/conf.marco` |
| Raycast | Export/Import | `~/.config/backups/raycast-settings.rayconfig` |
| Ice | plist script | `~/.config/backups/plists/com.jordanbaird.Ice.plist` |
| BetterMouse | Export/Import | `~/.config/backups/bettermouse-settings.bms` |
| Bitwarden | Cloud-synced | Log in → enable SSH Agent |
| Zen | Firefox account | Sign in → reinstall extensions |
| HyperKey | plist script | `~/.config/backups/plists/com.knollsoft.Hyperkey.plist` |
| AltTab | plist script | `~/.config/backups/plists/com.lwouis.alt-tab-macos.plist` |
| Docker Desktop | No backup | Reconfigure defaults |
| TimeyMeet | No config | Grant Calendar access |
| Keyboard Pilot | No export | Reconfigure per-app rules manually |

Plist backup/restore:
```sh
~/.config/backups/plists/backup-plists.sh   # export → chezmoi re-add ~/.config/backups/plists/
~/.config/backups/plists/restore-plists.sh  # import (fresh install)
```

#### Amethyst

Config tracked in chezmoi. First launch: Accessibility permission required.

Tiled apps (all others float): WezTerm, Zen, Chrome, VS Code, Slack, Discord, WhatsApp, Spotify, Docker Desktop, Bitwarden, Seashore.

Key shortcuts: `⌥⇧ J/K` focus prev/next · `⌥⇧ W/E/R` focus screen · `⌃⌥⇧ W/E/R` throw to screen · `⌥⇧ Space` cycle layout · `⌥⇧ D` fullscreen · `⌥⇧ T` toggle float.

#### Finicky

Rules: default browser = Zen · http → https redirect · `localhost*`, `*curseforge.com`, `*overwolf.com` → Chrome (Profile 1).

First launch: grant permission to set itself as default browser.

### Updating macOS Defaults

Settings are stored as `defaults write` commands in:

```sh
~/.local/share/chezmoi/run_once_after_macos-defaults.sh
```

Edit and run `chezmoi apply` — changing the file content triggers chezmoi to re-run it.

---

## Dotfiles

Managed with [chezmoi](https://chezmoi.io). Source repo: `git@github.com:NilCor3/dotfiles.git` at `~/.local/share/chezmoi/`.

| File | Purpose |
|------|---------|
| `~/.zshrc` | Zsh config, plugins via Zinit |
| `~/.zshenv` | Environment variables for all shells |
| `~/.gitconfig` | Git config, delta pager, rebase defaults |
| `~/.gitignore` | Global gitignore |
| `~/.config/mise/config.toml` | Global mise tools and environment |
| `~/.config/wezterm/wezterm.lua` | WezTerm config (GPU/fonts/window only) |
| `~/.config/tmux/tmux.conf` | tmux multiplexer config |
| `~/.config/tmux/layouts/` | Session layout scripts |
| `~/.config/tmux/scripts/` | picker, ai-commit, lazygit, help |
| `~/.config/helix/` | Helix editor config and LSP setup |
| `~/.claude/commands/dotfiles.md` | `/dotfiles` Claude Code skill |

### Key commands

```sh
chezmoi add <file>          # start tracking a new file
chezmoi re-add <file>       # update source after editing directly
chezmoi edit <file>         # edit a tracked file via chezmoi (preferred)
chezmoi apply               # apply source state to home directory
chezmoi diff                # show pending changes
chezmoi status              # show which files differ
chezmoi unmanaged           # show files in home not tracked
chezmoi encrypt <file>      # encrypt with age before adding
```

Auto-commit + auto-push are enabled — `chezmoi add` and `chezmoi re-add` automatically commit and push.

### What to NEVER add

- `~/.ssh/` — private keys
- `~/.config/age/` — the age encryption key itself
- `~/.gnupg/` — GPG keys
- `~/.kube/` — cluster configs (may contain tokens)
- `~/.local/bin/` — compiled binaries (rebuild from source)
- Cache dirs: `~/.cache/`, `~/.zsh_history`, `.DS_Store`

### Directory conventions

- `~/dev/` — personal projects (git: jocke82karlsson@gmail.com)
- `~/source/` — work projects (git: joakim.karlsson@fortnox.se)
- `~/.local/bin/` — personal compiled binaries (e.g. `hx-gotest`, built from `~/dev/hx-gotest/`)
