# Personal Projects — Global Agent Instructions

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
```

Optionally reference a GitHub issue at the end of the body:
```
Closes #42
```

Rules:
- Subject line: imperative mood ("Add", "Fix", "Remove" — not "Added" or "Fixes")
- Do not add Co-authored-by trailers
- Do not add statistics or summaries (e.g. "Added 3 functions, modified 2 files")
- Do not describe what could be read directly from the diff

## Git

- Never commit directly to `main`/`master` unless it is a solo project with no open PRs
- Branch naming: `short-description` or `issue-42-short-description`

## Always

- Run file-scoped tests during development, not the full suite
- Format code before committing
- Write tests for new functionality

## Ask First

- Adding new dependencies
- Large refactoring — discuss approach before starting

## Never

- Commit secrets, API keys, or credentials
