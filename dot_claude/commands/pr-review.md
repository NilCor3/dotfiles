# PR Review

Review the changes on a git branch against its base branch.

## Usage

```
/pr-review [branch-name]
```

If no branch name is given, use the current branch. The branch can be a local name (`feature/x`) or remote-qualified (`origin/feature/x`).

## Instructions

You are a senior software engineer doing a code review. Follow these steps exactly.

### Step 1: Gather the diff

Run these commands:

```bash
git fetch origin
```

Detect the base branch:
```bash
git symbolic-ref refs/remotes/origin/HEAD --short 2>/dev/null || echo "origin/main"
```

If no branch was specified, get the current branch:
```bash
git rev-parse --abbrev-ref HEAD
```

Find the fork point:
```bash
git merge-base <base> <branch>
```

Get commit list and file overview:
```bash
git log <fork>..<branch> --oneline
git diff --stat <fork>..<branch>
```

Get the full diff:
```bash
git diff <fork>..<branch>
```

For each finding, look up the exact line number:
```bash
git diff <fork>..<branch> -- <file> | grep -n "<relevant snippet>"
# or to get line numbers from the branch HEAD:
git show <branch>:<file> | grep -n "<relevant snippet>"
```

### Step 2: Review the diff

Evaluate across these dimensions:

- **Correctness** — logic bugs, edge cases, off-by-one errors, data races
- **Design** — naming, API shape, duplication, violations of existing patterns
- **Safety** — nil/null dereferences, unhandled errors, resource leaks, panics
- **Security** — injections, auth bypass, secret exposure, unsafe input (brief scan)
- **Tests** — missing coverage for new behaviour, tests that don't verify intent

Be language-aware: Go idioms for Go, Rust ownership for Rust, etc.

### Step 3: Output the review

Use exactly this structure:

---

## PR Review: `<branch-name>`

**Commits:** N commits · `<first-sha>...<last-sha>`  
**Changed:** X files, +Y −Z lines

### Summary

[2–4 sentences: what does this branch do, overall quality, ready to merge?]

### Findings

For each issue:

#### [label] Short title

**File:** `path/to/file.go:42`  ← exact file path and line number from the diff or `git show`  
**Severity:** 🔴 Critical / 🟠 High / 🟡 Medium / 🔵 Low / ⚪ Suggestion

```language
// relevant code snippet (3–8 lines)
```

[What the problem is and what to fix. 1–4 sentences.]

---

Skip empty categories. Don't say "No issues found in X" for every dimension.

### Verdict

One of:
- **✅ Approve** — Ready to merge as-is.
- **🟡 Approve with suggestions** — Minor issues, not blocking.
- **🔴 Request changes** — Must fix before merging.

[One sentence rationale.]

---

Keep the review under ~60 lines unless there are many findings. Be direct — no hedging, no padding.
