# Git

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

## Workflows

### Interactive Rebase to Clean Up Commits

1. `gl` → review commit history (pretty one-line log)
2. `grb` → forgit interactive rebase — fzf picker shows commits
3. Select the commit to rebase from → editor opens with rebase plan
4. Reorder, squash, fixup, or edit commits
5. Save and close → git applies the rebase
6. If conflicts: `gs` → see status, `lg` → lazygit for visual resolution
7. `gpf` → force push with lease (safe)

### Resolve a Merge Conflict

1. `gpl` → pull with rebase triggers a conflict
2. `gs` → see conflicted files
3. `lg` → lazygit TUI
4. Navigate to conflicted file → `e` to open in Helix
5. zdiff3 markers show ours / base / theirs — edit to resolve
6. Save → back in lazygit → stage the resolved file
7. Continue rebase from lazygit

### Quick Fixup for a Previous Commit

1. Make your fix, `gaa` to stage all
2. `gfu` → forgit fixup — fzf shows recent commits
3. Select the commit this fix belongs to
4. Git creates a fixup commit and auto-squashes it
