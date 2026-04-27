# /todos — AI-assisted Todo Management

Manage todos using the `tn` task system. All operations use the `tn-mcp` MCP server when available, otherwise fall back to `t` CLI.

## Usage

```
/todos [action] [args]
```

**Examples:**
- `/todos` — show open tasks for current context
- `/todos add Fix the billing bug` — add a task to current context
- `/todos work` — list work tasks
- `/todos done Fix billing` — mark matching task as done
- `/todos search API timeout` — search across all todos

## What I'll do

1. **No args** → call `get_context`, then `list_todos` for that context, present a summary
2. **Keyword is a domain/project** → `list_todos` for that scope
3. **"add ..."** → `add_todo` with the given text, using current context
4. **"done ..."** → `search_todos` first, then `done_todo` after confirming match
5. **"cancel ..."** → `search_todos` first, then `cancel_todo` after confirming match
6. **"search ..."** → `search_todos` across all scopes, present grouped results

## Context system

Tasks live in `~/notes/todos/<domain>/<project>.md`.
The active context is resolved as: `--project` flag → `$T_CONTEXT` env → `.todo.toml` → cwd dir_domain → none.

Use `t use <context>` in your terminal to set a persistent context for the shell session.
