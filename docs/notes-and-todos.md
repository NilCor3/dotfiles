# Notes & Todos

Unified Zettelkasten system. Everything is a note — tasks, journals, meetings, references, people, projects, areas. Plain markdown files with YAML frontmatter in a flat `~/notes/` directory, powered by the `tn` Go CLI system.

Source: [github.com/NilCor3/tn](https://github.com/NilCor3/tn)

## Architecture

```
tn-t   tn-n   j (tn-j)   tn-mcp2
  └──────┴──────┴──────┘
        Unix socket (~/.local/state/tn/tn.sock)
              │
          tn-index  (daemon, launchd)
          ├─ in-memory note graph
          ├─ fsnotify file watcher
          ├─ git auto-sync (every 5 min)
          └─ MCP server (AI agents)
              │
           ~/notes/*.md  (source of truth)
```

`tn-index` starts automatically when any CLI is invoked, and also runs as a launchd agent on login.

## Note Format

```yaml
---
id: 20260428T1045
title: "Fix auth timeout"
type: task               # task|journal|meeting|reference|source|person|project|area|note
status: active           # task only: open|active|done|cancelled|blocked
tags: [backend, auth]
related: [20260415T1200] # bidirectional links
parent: 20260420T0900    # hierarchy (task→epic, project→area)
jira: NOV-550
due: 2026-05-01
created: 2026-04-28
modified: 2026-04-28
---
```

## Shell Commands

```bash
# Tasks (tn-t)
tn-t add "summary" [-p parent] [--jira NOV-550] [--tag backend]
tn-t ls [dsl-query]     # list open/active tasks
tn-t info <ref>         # show full task + history
tn-t start / done / cancel / block / stop <ref>
tn-t plan <project>     # project overview with task tree

# Notes (tn-n)
tn-n new / ref / meet / person [title]
tn-n search [dsl-query]
tn-n find               # fzf picker
tn-n recent [n]         # last N modified notes
tn-n backlinks <ref>    # notes linking to this note
tn-n tags               # list all tags with counts

# Journal (tn-j, aliased as j)
j                       # open today's journal (shell wrapper)
j add "text"            # quick append
j log <ref>             # entries linked to task/project
j today / j week        # timeline views
```

`<ref>` is any of: note ID, Jira key, title substring.

## Query DSL

```
type:task status:active +backend       # AND filters
under:blink                            # all descendants of project
related:mirnes                         # bidirectional links
after:2026-04-20 before:2026-04-28
week | today | month                   # date shorthands
jira:NOV-550
"auth timeout"                         # full-text search
```

## Config

`~/.config/tn/config.toml` — key sections:
- `notes_dir` — flat notes directory
- `[index]` — socket path, sync interval
- `[[dir_domains]]` — directory → domain mappings (e.g. `~/source` → `work`)
- `[jira]` — Jira base URL and auth (via `$JIRA_TOKEN`)
- `[project_roots]` — maps project note names to git repo paths

## MCP Server

`tn-mcp2` exposes 15 tools. Registered in `~/.claude.json` as `tn-v2`. AI agents can:
- Query tasks and notes with DSL
- Create tasks, notes, journal entries
- Follow link chains (parent, related, under)

## Auto-sync

`tn-index` daemon handles git sync in the background. Launchd agent at
`~/Library/LaunchAgents/com.joakim.tn-index.plist` starts it on login with `-sync-interval 300`.

Replaces the old `tn-sync` launchd agent.

## Jira Integration

Link notes and tasks to Jira tickets. Config: `jira.base_url` in `config.toml`, auth via `$JIRA_TOKEN`.

```bash
tn-t add --jira NOV-515 "Fix billing"
tn-t info NOV-515       # live Jira status, description, recent comments
```

## Workflows

### Morning routine
1. `tn-t ls` → open/active tasks
2. `j today` → yesterday's journal
3. `tn-t start <ref>` → set task active (auto-creates journal entry)

### Capture during a meeting
1. `tn-n meet sprint-planning` → meeting note with template (parent: project)
2. `tn-t add "Action item" -p work/blink` → task directly from meeting
3. `tn-n link <meeting-id> <task-id>` → cross-reference

### Deep work on a task
1. `tn-t info NOV-550` → see task details, Jira status, linked notes
2. `j add "investigating X" --task NOV-550` → journal entry linked to task
3. `tn-n new "auth timeout root cause"` → reference note, link to task
4. `tn-t done NOV-550` → auto-creates journal entry

### Search and navigate
1. `tn-n search "type:meeting +blink week"` → this week's blink meetings
2. `tn-n backlinks <note-id>` → what links here?
3. `tn-t plan blink` → blink project overview with task tree
