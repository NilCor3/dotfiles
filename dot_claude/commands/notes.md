# /notes — AI-assisted Notes Management

Manage notes using the `tn` notes system. All operations use `tn-mcp` MCP server when available, otherwise fall back to `n` CLI or direct file access.

## Usage

```
/notes [action] [args]
```

**Examples:**
- `/notes` — list recent notes
- `/notes search Kafka consumer` — full-text search across notes
- `/notes journal stood up the k8s cluster` — append to today's journal
- `/notes meet sprint planning` — create a meeting note
- `/notes read work/meet-2026-05-01-sprint.md` — read a specific note

## What I'll do

1. **No args** → `list_notes` to show recent notes, summarize
2. **"search ..."** → `search_notes` with the query, show grouped results
3. **"journal ..."** → `add_journal_entry` with the text (appends to today's file)
4. **"read <path>"** → `read_note` and display contents
5. **"meet <topic>"** → `create_note` with type `meet`, or `n meet <topic>`
6. **"issue <id>"** → `create_note` with type `issue`, or `n issue <id>`
7. **"append <path> ..."** → `append_to_note` with the content

## Notes structure

```
~/notes/
├── journal/YYYY-MM-DD.md    # Daily journals
├── work/                    # Work notes (meetings, issues)
├── dev/                     # Dev research notes
├── personal/                # Personal notes
└── *.md                     # Freeform notes
```

Config lives at `~/.config/tn/config.toml` (`notes_dir` key).
