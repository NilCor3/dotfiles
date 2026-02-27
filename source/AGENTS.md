# Fortnox — Global Agent Instructions

These instructions apply to all repositories under this directory.

---

## Commit Messages

**Format:**

```
Short imperative description (≤72 chars, no period)

- Explain what was done and why — not what the diff already shows
- Use bullet points for clear separation when multiple things changed
- Enough detail to understand the change without reading the code
- Omit trivial details that are self-evident from the diff

Solves: NOV-123
```

**NOJIRA** (docs, config, non-code changes only, or when explicitly told):
```
NOJIRA: Short description
```

Rules:
- Subject line: imperative mood ("Add", "Fix", "Remove" — not "Added" or "Fixes")
- Ask for a JIRA ticket if none is provided and the change is not clearly NOJIRA
- Do not add Co-authored-by trailers
- Do not add statistics or summaries (e.g. "Added 3 functions, modified 2 files")
- Do not describe what could be read directly from the diff

## Git

- Main branch: `master`
- Branch naming: `NOV-123-short-description`
- Never commit directly to `master` — always use feature branches

## Always

- Run file-scoped tests during development, not the full suite
- Format code before committing
- Write tests for new functionality

## Ask First

- Database schema changes (migrations)
- Adding new dependencies
- Modifying CI/CD configuration
- Deleting files or migrations
- Large refactoring — discuss approach before starting

## Never

- Commit secrets, API keys, or credentials
- Modify existing migrations that have been merged to master
- Edit `node_modules/` or `vendor/`
