# Notes & Todos

Plain markdown files in `~/notes/`, Git-synced, driven by Go CLI binaries (`t` and `n` at `~/.local/bin/`). No apps — just files, ripgrep, fzf, and Helix.

Source: [github.com/NilCor3/tn](https://github.com/NilCor3/tn)

## Notes

Plain markdown files with YAML frontmatter. No sync service — Git handles everything.

### Structure

```
~/notes/
├── journal/      # daily notes (type: daily)
├── work/         # meetings, issues, system docs (type: meeting|issue|system)
├── dev/          # tech reference (type: ref)
├── projects/     # personal projects, learning
└── scratch.md    # quick capture inbox
```

### Frontmatter

```yaml
---
type: meeting
tags: [blink, api]
date: 2026-02-27
---
```

### Shell functions

```sh
n              # open ~/notes in Helix
ns             # open scratch.md
nj             # create/open today's journal (journal/YYYY-MM-DD.md)
nmeet <title>  # new meeting note with template (work/meet-YYYY-MM-DD-<title>.md)
nissue <id>    # new issue note (work/issue-NOV-123.md)
nn <path>      # new note at relative path (creates frontmatter)
nf [query]     # fuzzy find by filename → open in Helix
nft <type>     # filter by frontmatter type
ntag <tag>     # filter by frontmatter tag
ng <pattern>   # ripgrep → fzf with match preview
ngs            # live interactive content search (opens at exact line)
ngl            # browse with glow TUI
```

`n` with no args opens `~/notes/` in Helix. With args it delegates to `~/.local/bin/n`.

### Tools

- **[marksman](https://github.com/artempyanykh/marksman)** (mise) — Helix LSP: `[[wiki link]]` completion, go-to-definition, find-references
- **[glow](https://github.com/charmbracelet/glow)** (mise) — TUI markdown browser; `ngl` opens the whole vault

### Git sync

Handled automatically by the `tn-sync` launchd daemon (see [Auto-sync](#auto-sync)). Manual sync available via `n sync`.

Pre-commit validation blocks commits if `type:` or `date:` frontmatter is missing.

## Todos

Plain GFM checkboxes in `~/notes/todos/`.

### File structure

```
~/notes/todos/
├── inbox.md    # quick capture (default target)
├── work.md
├── dev.md
├── personal.md
└── someday.md
```

### Format

Four statuses:

```md
- [ ] Open task          #tag
- [/] Active (in progress)
- [x] Done
- [-] Cancelled
```

Tasks have IDs in the format `#<project-num>-<task-num>`.

### Shell aliases

All aliases delegate to the `t` binary:

```sh
ta='t a'           # append to inbox (no args → open inbox in Helix)
tl='t l'           # fzf list → open in Helix at exact line
td='t d'           # mark done via fzf picker
tp='t p'           # open a todo file
tw='t l work'      # list work todos
tper='t l personal'
tdev='t l dev'
tn='t new'         # tn work billing → t new work billing
```

Filter by tag: `t l --tag <tag>`

`Alt+t` in Helix (normal or insert, `.md` files only) — inserts `- [ ] ` below cursor.

tmux `notes` layout: todos window (Helix 42.5% + tl 42.5% + shell 15%) + notes window (Helix 80% + shell 20%). `tl` opens files directly in the Helix pane when in the `notes:todos` session.

## tn CLI

Go CLI binaries at `~/.local/bin/t` and `~/.local/bin/n`.

### Context resolution

The context determines which todo file is targeted. Resolution order:

1. `--project` / `-p` flag (e.g. `t a -p work Fix bug`)
2. `$T_CONTEXT` environment variable (set via `t use`)
3. `.todo.toml` file in the current directory
4. `dir_domains` map in config (maps directory prefixes to contexts)
5. Falls back to `inbox`

### t commands

```sh
t a [text]         # add task (to current context or inbox)
t a -p work <text> # add task to a specific context
t l [context]      # list open tasks (fzf picker)
t d                # mark task done (fzf picker)
t cancel           # mark task cancelled (fzf picker)
t use <context>    # set $T_CONTEXT for the current shell session
t use --clear      # unset $T_CONTEXT
t sync             # manual git commit + push
t doctor           # check config, directories, git status
t new <ctx> <name> # create a new todo file
t p                # open/pick a todo file
t completion zsh   # generate shell completions
```

The `t` shell wrapper (in `.zshrc`) intercepts `t use` to run `eval "$(command t use-eval ...)"` so the env var is set in the current shell.

### n commands

```sh
n sync             # manual git commit + push for notes
n doctor           # check config, directories, git status
n completion zsh   # generate shell completions
```

### Config

`~/.config/tn/config.toml`

Contains the `dir_domains` map that associates directory prefixes with todo contexts (e.g. `~/source/` → `work`).

## Auto-sync

The `tn-sync` binary (`~/.local/bin/tn-sync`) is a launchd daemon that automatically commits and pushes changes to the notes/todos Git repo every 5 minutes.

Managed via a launchd plist. Ensures notes and todos are always backed up and available across machines without manual `sync` calls.

## MCP Server

The `tn-mcp` binary (`~/.local/bin/tn-mcp`) exposes 12 tools for AI agent access to the notes and todos system. This lets Copilot, Claude, and other AI assistants read, search, create, and manage notes and tasks programmatically.

## Workflows

### Morning Standup

1. `nj` → opens today's journal (creates if needed with date frontmatter)
2. Write standup notes: what I did, what's next, blockers
3. `tl` → fzf list of open todos, review priorities
4. `t use work` → set context for the session
5. `t l` → see work tasks for today

### Capture During a Meeting

1. `nmeet sprint-planning` → creates `work/meet-YYYY-MM-DD-sprint-planning.md` with template
2. Take notes in Helix
3. Action items: `Alt+t` → inserts `- [ ] ` checkbox below cursor
4. After meeting: `ta Fix the billing bug` → quick capture to inbox
5. Or: `t a -p work Fix billing bug` → add directly to work context

### Search and Organize

1. `ngs` → live interactive search across all notes (opens at exact line)
2. `nft meeting` → filter notes by type
3. `ntag api` → filter by tag
4. `ng kafka` → ripgrep with fzf preview
5. `t l work` → list work todos
6. `td` → mark a task done via fzf picker
