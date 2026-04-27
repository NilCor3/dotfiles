# Development Tools

## Go

All installed via mise.

### air — live reload

**[air](https://github.com/air-verse/air)** watches your project and rebuilds/restarts on file save.

```sh
air init    # scaffold .air.toml in project root
air         # start live reload
```

### gotestsum + richgo — prettier tests

**[gotestsum](https://github.com/gotestyourself/gotestsum)**:

```sh
gw             # gotestsum — run all tests with pretty output
gwa            # gotestsum --watch — rerun on file save
gwf            # gotestsum --format testname — show individual test names
```

**[richgo](https://github.com/kyoh86/richgo)** — color-coded pass/fail output. Used by `hx-gotest.sh` and `got`/`gota` aliases:

```sh
got            # richgo test ./... — run all tests with color
gota           # richgo test ./... -v — verbose with color
```

### dlv — Go debugger

**[dlv](https://github.com/go-delve/delve)** — standard Go debugger with DAP support.

```sh
dlvr                      # dlv debug . (debug current package)
dlvt [TestName]           # dlv test . -- -run TestName
dlv attach <pid>          # attach to running process
dlv dap --listen=:2345    # DAP server for Helix integration
```

### gdlv — GUI companion for dlv

**[gdlv](https://github.com/aarzilli/gdlv)** — native GUI frontend for dlv:

```sh
dlvg debug ./...          # headless dlv + gdlv GUI + dlv CLI connected together
dlvg test ./pkg/...
dlvg attach <pid>
```

`dlvg` starts `dlv --headless --listen=:2345 --accept-multiclient`, opens gdlv, then connects a CLI dlv client — all in one command.

### Workflow

- Run `air` in one pane, `gwa` in another — instant feedback loop
- `dlvr` to debug binary, `dlvt TestName` to debug a specific test
- `dlv dap --listen=:2345` → connect from Helix for breakpoint debugging via DAP

---

## Rust

All installed via mise (`cargo:` prefix).

### bacon — background watcher

**[bacon](https://dystroy.org/bacon/)** reruns on every file save:

```sh
bac           # bacon — default watch
bacon clippy  # watch clippy
```

### cargo-nextest — faster tests

**[cargo-nextest](https://nexte.st)** — drop-in for `cargo test` with better output and parallelism:

```sh
nt            # cargo nextest run
nta           # cargo nextest run --all
```

### cargo-audit — security audit

```sh
audit         # cargo audit
cargo audit fix
```

### cargo-expand — macro expansion

**[cargo-expand](https://github.com/dtolnay/cargo-expand)** — see fully expanded source after macro substitution:

```sh
expand <module>   # cargo expand <module>
expand            # expand entire crate
```

### Workflow

- `bacon clippy` in a split while coding — instant feedback
- `nt` everywhere — faster than `cargo test`, cleaner output
- `rdb` — debug binary; `rdt [filter]` — debug a specific test (both use `rust-lldb`)

---

## TypeScript

**[biome](https://biomejs.dev)** (mise) — fast all-in-one formatter + linter. Replaces ESLint + Prettier.

**[tsx](https://github.com/privatenumber/tsx)** (mise) — run TypeScript directly, no compile step.

**[knip](https://knip.dev)** (mise) — finds unused exports, dependencies, and files.

```sh
bio='biome'
biof='biome format --write'   # biof: format + fix
bioc='biome check --apply'    # bioc: check only

tsx file.ts     # run TypeScript directly
knip            # find dead code and unused deps
```

---

## JSON & YAML

### JSON — jq, jnv, fx

- **jq** — system-installed; standard for scripting and one-liners
- **[jnv](https://github.com/ynqa/jnv)** (mise) — interactive filter builder with live preview
- **[fx](https://fx.wtf)** (mise) — interactive explorer and JS-powered processor

```sh
xh api.example.com/data | jnv                    # build filter interactively
fx file.json                                     # explore interactively
fx file.json '.users.filter(u => u.active)'      # JS expression
xh api.example.com/data | jq -r '.items[].name'  # one-liner scripting
jq '[.[] | {name: .name, id: .id}]' file.json    # reshape
```

Workflow: **jnv** to discover the filter → **jq** to script it → **fx** for large nested structures.

### YAML — yq

**[yq](https://mikefarah.gitbook.io/yq/)** (mise) — jq-like processor for YAML, JSON, TOML, XML.

```sh
yq '.key.nested' file.yaml
yq -i '.version = "2.0"' file.yaml       # edit in-place
cat file.yaml | yq -o json               # convert YAML → JSON
yq e 'select(.kind == "Service")' k8s.yaml
```

---

## Workflows

### Go TDD Cycle

1. Start tmux `dev` layout in project dir
2. Left: `hx .` → open or create test file
3. Right top: `gwa` → gotestsum watch, reruns all tests on save
4. Write a failing test → `Ctrl+s` → watch pane shows red
5. Implement the code → `Ctrl+s` → watch pane shows green
6. From Helix: `Space , t` for single test, `Space , F` for file
7. Verbose check: `gota` → richgo with full output

### Go Debugging Session

1. `dlvt TestMyFunction` → Delve test debugging
2. `break main.go:42` → set breakpoint
3. `continue` → run to breakpoint
4. `print myVar` → inspect state
5. For GUI: `dlvg test ./pkg/...` → headless dlv + gdlv + CLI all connected

### Rust Development Loop

1. Left pane: `hx .` → edit Rust code
2. Right: `bacon clippy` → continuous clippy feedback on save
3. Fix warnings → save → bacon updates instantly
4. Run tests: `nt` (nextest, faster than cargo test)
5. Check for vulnerabilities: `audit`
6. Debug macros: `expand module_name` → see expanded output

### Working with JSON APIs

1. `xh api.example.com/data | jnv` → interactively build a jq filter
2. Found the filter? Copy it → use in script: `jq -r '.items[].name'`
3. Large nested JSON? `fx file.json` → interactive tree explorer
4. YAML config: `yq '.key.nested' config.yaml` → query like jq
5. Convert: `cat file.yaml | yq -o json` → YAML to JSON
