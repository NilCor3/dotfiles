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

### Shell commands

```sh
n              # open ~/notes in Helix
n search       # open scratch.md
n journal      # create/open today's journal (journal/YYYY-MM-DD.md)
n meet <title> # new meeting note with template (work/meet-YYYY-MM-DD-<title>.md)
n issue <id>   # new issue note (work/issue-NOV-123.md)
n new <path>   # new note at relative path (creates frontmatter)
n find [query] # fuzzy find by filename → open in Helix
n find --type <type>  # filter by frontmatter type
n tag <tag>    # filter by frontmatter tag
n grep <pattern>  # ripgrep → fzf with match preview
n search       # live interactive content search (opens at exact line)
ngl            # browse with glow TUI (alias for glow $NOTES_DIR)
```

`n` with no args opens `~/notes/` in Helix. With args it delegates to `~/.local/bin/n`.

#### Cross-reference search

`n find` searches notes with project/tag/text filters and fzf selection:

```sh
n find --project work    # notes linked to a project
n find --tag api         # notes with a specific tag
n find kafka             # free-text search across all notes
```

#### Jira-linked notes

```sh
n meet --jira            # meeting note auto-linked to active Jira context
n issue NOV-515          # issue note pre-filled with Jira ticket metadata
```

### Tools

- **[marksman](https://github.com/artempyanykh/marksman)** (mise) — Helix LSP: `[[wiki link]]` completion, go-to-definition, find-references
- **[glow](https://github.com/charmbracelet/glow)** (mise) — TUI markdown browser; `ngl` opens the whole vault (alias for `glow $NOTES_DIR`)

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

Five statuses:

```md
- [ ] Open task          +tag
- [/] Active (in progress)
- [x] Done
- [-] Cancelled
- [ ] Blocked task       (has a `blocked:` metadata line)
```

Nested tasks use 2-space indentation per level:

```md
- [ ] NOV-549: Epic title
  jira: NOV-549
  - [ ] NOV-550: Child task
    jira: NOV-550
    branch: feature/branch
```

Tasks have IDs in the format `#<project-num>-<task-num>`.

### Projects

Each todo file under `~/notes/todos/` is a project (except `inbox` and `someday`, which are permanent buckets with no lifecycle).

Projects are tracked in `~/notes/projects.json` and have a lifecycle:

```
active → paused → done → archived
```

```sh
t projects                    # list all projects with colored status
t project info <name>         # show project details
t project pause <name>        # pause a project
t project done <name>         # mark project done
t project archive <name>      # archive a completed project
t project activate <name>     # reactivate a paused/done project
```

### Focus

Set a focused task to scope your work. While focused, `t add` creates subtasks under the focused task.

```sh
t focus              # pick a task to focus on (fzf picker)
t unfocus            # clear focus
t add "subtask"      # added as subtask of focused task
t add --top "task"   # override focus — add as top-level task
t sub <id> "text"    # add subtask to a specific task
t sub done <id> "text"  # add an already-completed subtask
```

The p10k prompt shows 🎯 when a task is focused.

### Query DSL

A mini query language used across most commands for filtering tasks. Filters within a group are AND-ed; groups separated by ` | ` are OR-ed:

```
p:project t:tag d:<date s:status j:KEY /text #id !
```

| Token                  | Meaning                                      |
|------------------------|----------------------------------------------|
| `p:work`               | filter by project                            |
| `+backend`             | filter by tag                                |
| `-+backend`            | exclude tag                                  |
| `d:<7d` / `d:overdue`  | due before date / overdue                    |
| `s:active`             | filter by status (open/active/done/blocked)  |
| `j:NOV-515`            | filter by Jira key                           |
| `j:NOV-550..556`       | filter by Jira key range                     |
| `NOV-550`              | bare Jira key (auto-resolved)                |
| `/billing`             | free-text search in task content             |
| `#1-3`                 | task by ID                                   |
| `has:jira`             | tasks with a Jira link                       |
| `has:children`         | tasks with nested children                   |
| `depth:0`              | root-level tasks only                        |
| `-p:work`              | negate any filter with leading `-`           |
| `p:work \| p:personal` | OR: tasks in work or personal                |

Used in: `done`, `cancel`, `start`, `move`, `archive`, `open`, `edit`, `note`, `link-note`.

When a query matches multiple tasks, fzf opens in multi-select mode for bulk operations.

### Jira integration

Link tasks to Jira tickets for status tracking and quick access.

**Config:** Set `jira.base_url` in `~/.config/tn/config.toml` and export `$JIRA_TOKEN`.

```sh
t add --jira NOV-515 "Fix billing"   # create task linked to Jira ticket
t info #1-3                          # show task details including Jira status
t jira-refresh                       # manually refresh cached Jira data
```

- `t list` shows Jira status alongside tasks
- `t open` opens the Jira ticket URL in the browser
- Cache is VPN-resilient: cached data never expires, only updated on `t jira-refresh`

### Review

```sh
t review      # surface tasks needing attention
```

Shows: overdue tasks, stale tasks (no activity), paused projects, and empty projects.

### Shell integration

All commands use `t` and `n` directly — no shell aliases needed. The only alias is `ngl` (`glow $NOTES_DIR`).

`Alt+t` in Helix (normal or insert, `.md` files only) — inserts `- [ ] ` below cursor.

tmux `notes` layout: todos window (Helix 42.5% + `t list` 42.5% + shell 15%) + notes window (Helix 80% + shell 20%). `t list` opens files directly in the Helix pane when in the `notes:todos` session.

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
# Task management
t a [text]              # add task (to current context or inbox)
t a -p work <text>      # add task to a specific context
t a --jira NOV-515 <text>  # add task linked to Jira ticket
t l [context]           # list open tasks; children indented under parents
t l [context] --flat    # flat list without nesting indentation
t d [query]             # mark task done (fzf picker, supports query DSL)
t cancel [query]        # mark task cancelled
t start [query]         # mark task active (in progress)

# Focus
t focus                 # pick and focus on a task
t unfocus               # clear focus
t sub <id> "text"       # add subtask to a task
t sub done <id> "text"  # add already-completed subtask

# Query & bulk ops
t open [query]          # open task (or Jira URL) in browser
t edit [query]          # edit task text
t move <src> <dest>     # move task to project, or nest under another task
t move NOV-550 NOV-549  # nest task as child of epic
t move NOV-550..556 NOV-549  # bulk-nest Jira range under epic
t move NOV-550 --top    # promote nested task to top level
t archive [query]       # archive completed tasks
t note [query]          # attach a note to a task
t link-note [query]     # link an existing note to a task
t info [query]          # show task details (including Jira status)

# Projects
t projects              # list projects with colored status
t project info <name>   # show project details
t project pause <name>  # pause a project
t project done <name>   # mark project done
t project archive <name>  # archive a project
t project activate <name>  # reactivate a project

# Jira
t jira-refresh          # refresh cached Jira data

# Review
t review                # surface overdue/stale tasks, paused/empty projects

# Context & config
t use <context>         # set $T_CONTEXT for the current shell session
t use --clear           # unset $T_CONTEXT
t sync                  # manual git commit + push
t doctor                # check config, directories, git status
t new <ctx> <name>      # create a new todo file
t p                     # open/pick a todo file
t completion zsh        # generate shell completions
```

The `t` shell wrapper (in `.zshrc`) intercepts `t use` to run `eval "$(command t use-eval ...)"` so the env var is set in the current shell.

### n commands

```sh
n sync                   # manual git commit + push for notes
n doctor                 # check config, directories, git status
n find --project <name>  # search notes by project
n find --tag <tag>       # search notes by tag
n find <text>            # free-text note search with fzf
n completion zsh         # generate shell completions
```

### Config

`~/.config/tn/config.toml`

- `dir_domains` — maps directory prefixes to todo contexts (e.g. `~/source/` → `work`)
- `jira.base_url` — Jira instance URL for ticket integration
- `$JIRA_TOKEN` — environment variable for Jira API authentication

## Auto-sync

The `tn-sync` binary (`~/.local/bin/tn-sync`) is a launchd daemon that automatically commits and pushes changes to the notes/todos Git repo every 5 minutes.

Managed via a launchd plist. Ensures notes and todos are always backed up and available across machines without manual `sync` calls.

## MCP Server

The `tn-mcp` binary (`~/.local/bin/tn-mcp`) exposes 16 tools for AI agent access to the notes and todos system. This lets Copilot, Claude, and other AI assistants read, search, create, and manage notes and tasks programmatically.

Includes project management tools: `list_projects`, `get_project`, `update_project`.

New in recent updates:
- `move_todo` — move a task to a project file or nest it under another task (by Jira key)
- `list_todos` and `search_todos` accept a `query` / `dsl` param for DSL filtering (e.g. `s:active +backend`, `NOV-550`)
- `add_todo` accepts a `jira` param to link a task to a Jira issue on creation
- `get_task_info` fetches Jira description (configurable max length) and recent comments when the task has a Jira key

## Workflows

### Morning Routine

1. `t review` → see overdue tasks, stale items, paused projects
2. `t focus` → pick a task to focus on (🎯 appears in prompt)
3. Work on focused task — `t add "subtask"` creates subtasks under it
4. `t unfocus` → clear focus when done

### Jira Workflow

1. `t add --jira NOV-515 "Fix billing"` → task linked to Jira ticket
2. `t info #1-3` → see task details with live Jira status, description, and recent comments (auto-paged)
3. `n issue NOV-515` → create a linked issue note for deeper investigation
4. `t open #1-3` → open Jira ticket in browser
5. `t jira-refresh` → pull latest Jira status (VPN-resilient cache)

### Project Lifecycle

1. Create a todo file: `t new work billing` → `~/notes/todos/work.md`
2. `t projects` → auto-detected, shown with colored status
3. Work on tasks, track progress
4. `t project done work` → mark project complete
5. `t project archive work` → archive when no longer relevant

### Query Power

1. `t done p:work t:backend` → multi-select backend tasks in work → bulk complete
2. `t archive s:done` → archive all done tasks
3. `t l j:NOV-515` → find tasks linked to a Jira ticket
4. `t move p:inbox` → move inbox tasks to proper projects

### Capture During a Meeting

1. `n meet sprint-planning` → creates `work/meet-YYYY-MM-DD-sprint-planning.md` with template
2. Take notes in Helix
3. Action items: `Alt+t` → inserts `- [ ] ` checkbox below cursor
4. After meeting: `t add Fix the billing bug` → quick capture to inbox
5. Or: `t a -p work Fix billing bug` → add directly to work context

### Search and Organize

1. `n search` → live interactive search across all notes (opens at exact line)
2. `n find --type meeting` → filter notes by type
3. `n tag api` → filter by tag
4. `n find --project work` → find notes linked to a project
5. `t l work` → list work todos
6. `t done` → mark a task done via fzf picker
