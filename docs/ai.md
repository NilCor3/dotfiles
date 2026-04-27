# AI Tools

Three AI surfaces share a common philosophy: **skills** inject persistent context, **agents** are specialized AI personas with their own tools and model, and **MCP servers** provide tool access (data/actions) that any AI can call automatically.

## GitHub Copilot CLI

Standalone terminal AI assistant. Runs in WezTerm, reads `~/AGENTS.md` and folder-level `AGENTS.md` files for project context.

```sh
brew install --cask copilot-cli@prerelease
copilot                          # launch
```

The `~/.copilot/` directory (tracked in chezmoi):

- `agents/` — custom sub-agents (10 agents, see below)
- `skills/` — persistent context sets (3 skills)
- `mcp-config.json` — MCP server configs
- `config.json` — UI preferences

### Agents

Agents are specialized AI personas with their own system prompt, tools, and model selection. Invoke via `/agent` in Copilot CLI, or let auto-selection pick them when `infer: true`.

| Agent | Description | Auto-infer |
|-------|-------------|:----------:|
| `agent-writer` | Expert in creating well-structured Copilot custom agent files | ✓ |
| `bevy-game-dev` | Bevy game development tutor and co-developer (Socratic teaching) | |
| `indie-game-designer` | Indie game design expert — idea to Game Design Document | |
| `notes` | Search, read, create, and append notes via the tn notes system | |
| `pr-reviewer` | Structured code review of branch changes with findings and verdict | ✓ |
| `rust-game-architect` | Rust game tech stack advisor — reads GDD, picks crates, writes agent files | |
| `rust-game-dev` | Rust indie game dev tutor using a curated library stack (three-d, bevy_ecs, rapier3d) | |
| `security-reviewer` | Read-only security code review with prioritized findings and Jira suggestions | |
| `tech-tutor` | Socratic teaching for learning new technologies | |
| `todo` | Manage todos via the tn task system — add, list, complete, search tasks | |

### Skills

Skills are persistent context injected into the system prompt. Unlike agents (which are separate personas), skills augment your current session with domain knowledge. Activate with `/skills use <name>`.

| Skill | Description |
|-------|-------------|
| `personal` | Joakim's personal preferences for Copilot CLI |
| `dotfiles` | Manage home directory dotfiles tracked with chezmoi |
| `pr-check` | Run full lint and test suite across all sub-projects and report failures |

### MCP Servers

MCP (Model Context Protocol) servers provide tool access that AI agents call automatically — no manual invocation needed. Configured in `~/.copilot/mcp-config.json`.

| Server | Description |
|--------|-------------|
| `tn` | `tn-mcp` — todo and notes access from AI agents (list/add/complete todos, search/read/create notes) |
| `postgres-blink` | PostgreSQL access via Docker container |
| `searxng` | Web search via local SearXNG instance |

## Claude Code

Claude Code CLI with custom slash commands in `~/.claude/commands/`:

| Command | Purpose |
|---------|---------|
| `/dotfiles` | Load full dotfiles context for chezmoi work |
| `/notes` | Work with the tn notes system |
| `/pr-review` | Review changes on the current branch |
| `/todos` | Manage todos via the tn task system |

## Workflows

### Use a Copilot Agent for PR Review

1. `copilot` → launch Copilot CLI in terminal
2. `/agent` → browse available agents
3. Select `PR Reviewer` → or just ask "review this PR" (`infer: true` auto-selects it)
4. Agent fetches diff, analyzes changes, produces structured review with findings and verdict

### Access Todos via MCP from AI

1. In Copilot CLI or Claude Code, the `tn-mcp` server is auto-loaded
2. Ask: "show my work todos" → agent calls `list_todos` MCP tool
3. Ask: "add a todo: fix billing bug" → agent calls `add_todo`
4. Ask: "search notes for Kafka" → agent calls `search_notes`
5. No manual tool invocation needed — the AI uses MCP tools automatically
