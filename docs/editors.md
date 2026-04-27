# Editors

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

- `~/.config/nvim/bin/nvim-test.py` — Python test runner; plugin-per-language in `nvim-test.d/` (vitest, playwright, go, rust, java, php); auto-discovers `tests` tmux pane or creates one; pytest test suite in `nvim-test-tests/`
- `~/.config/nvim/bin/tmux-runner.sh` — build/run commands to tmux pane `.1` by filetype

---

## Workflows

### Debug a Go Test from Helix

1. Open the test file: `hx pkg/store/store_test.go`
2. Navigate to the failing test function
3. `Space , t` → runs `hx-gotest` for the test under cursor, output appears in tmux split
4. Read the failure output → fix the code → `Ctrl+s` to save
5. `Space , t` again to re-run — iterate until green
6. `Space , T` to run the whole test function, `Space , F` for all tests in the file

### Navigate Unfamiliar Code in Neovim

1. `nvim .` → dashboard shows recent files and grep
2. `<leader><space>` → fuzzy file picker to find entry point
3. On a symbol: `<leader>gd` → go to definition, `<leader>gr` → find all references
4. `<leader>/` → grep for a string across the project
5. `<leader>fd` → workspace diagnostics to find issues
6. `s` → Flash jump to any visible location by typing 2 chars
7. `-` → Oil file browser to explore directory structure
