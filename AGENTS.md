# Home directory conventions

- `~/dev/` — personal projects (git: jocke82karlsson@gmail.com)
- `~/source/` — work projects (git: joakim.karlsson@fortnox.se)
- `~/.local/bin/` — personal compiled binaries (rebuild from source, not tracked in chezmoi)

For dotfiles/chezmoi work from any directory, invoke the `/dotfiles` skill.

## ⚠️ Secret hygiene — mandatory checks before every commit

**Never commit plaintext credentials.** Before adding or committing any file:

1. **Scan for secrets** — check for API keys, tokens, passwords, connection strings, and private hostnames:
   ```sh
   grep -rn -i 'api.key\|api.secret\|token\|password\|passwd\|secret' <file>
   grep -rn '://[^@\s]\+:[^@\s]\+@' <file>   # credentials in URLs
   ```
2. **Secrets belong in age-encrypted files** — use `chezmoi encrypt <file>` for anything sensitive; the result is an `.age` file safe to commit.
3. **Config that references secrets** should use env var indirection (e.g. `api-key-env: MY_VAR`) or chezmoi templates (`{{ env "MY_VAR" }}`), not inline values.
4. **Machine-local config** (test credentials, local DB connections) should NOT be tracked in chezmoi at all — use `chezmoi forget` if already added.
5. **If a secret is accidentally committed**, purge it immediately with `git filter-repo --path <file> --invert-paths` and force-push. Do not just delete it in a follow-up commit — that leaves it in history.
