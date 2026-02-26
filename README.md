# NilCor3's Mac Setup

Personal development machine setup for macOS. Dotfiles managed with [chezmoi](https://chezmoi.io).

## Quick Start

```sh
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Bootstrap mise and chezmoi
brew install mise
mise use -g chezmoi age

# 3. Restore age key from Bitwarden before applying dotfiles
#    Log in to Bitwarden, retrieve the secure note "chezmoi-age-key"
#    and save it to ~/.config/age/chezmoi-key.txt
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
```

---

## Dotfiles (chezmoi)

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
- Age key is backed up as a secure note in Bitwarden (`chezmoi-age-key`)
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

---

## Git

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

## SSH

SSH agent provided by **Bitwarden desktop app**.

```sh
export SSH_AUTH_SOCK=~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
```

Set in `~/.zshrc`. Make sure Bitwarden SSH agent is enabled in Bitwarden →
Settings → SSH Agent.
