# Dotfiles Management

This home directory is managed with [chezmoi](https://chezmoi.io).
Source repo: `github.com:NilCor3/dotfiles` (at `~/.local/share/chezmoi/`)

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
- Editor: `.config/helix/` (config, languages, scripts)
- Terminal: `.config/wezterm/`, `.config/ghostty/`
- Git: `.gitconfig`, `.gitignore`, `.config/git/personal.gitconfig`
- Tools: `.config/mise/config.toml`, `.config/lazygit/config.yml`
- Multiplexer: `.tmux.conf`, `.config/zellij/`
- Misc: `.finicky.js`, `.ideavimrc`, `.yarnrc`, `README.md`
- Scripts: `diff-macos-defaults.sh`, `hx/`
- Per-folder agent instructions: `dev/AGENTS.md`, `source/AGENTS.md`

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
