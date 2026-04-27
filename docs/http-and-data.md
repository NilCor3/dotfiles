# HTTP, Database & Kafka

## HTTP & APIs

### xh — HTTP client

**[xh](https://github.com/ducaale/xh)** is a fast, friendly HTTP client (httpie-compatible syntax, written in Rust).

```sh
http=xh          # alias
https='xh --https'

xh httpbin.org/get
xh POST api.example.com/users name=Alice age:=30   # = string, := raw/number
xh api.example.com Authorization:"Bearer $TOKEN"
xh --print=b api.example.com/data                  # body only (pipe-friendly)
xh --download https://example.com/file.zip
xh --session=myapp POST api.example.com/login username=me password=secret
xh --session=myapp api.example.com/profile         # reuses session
xh --offline POST api.example.com key=value        # preview without sending
xh --follow https://example.com
```

Pairs well with: `| jq`, `| fx`, `| bat -l json`. Sessions stored in `~/.config/xh/sessions/`.

### httpyac — .http file runner

**[httpyac](https://httpyac.github.io/)** (mise npm) — run `.http` files with environments, variables, and assertions.

```sh
henv <file> <env>     # set httpyac environment file and name
hrun [file]           # run .http file (or current if no arg)
```

Supports `@name` request names, `### separator` between requests, and environment files for staging/prod.

### hurl — HTTP integration tests

**[hurl](https://hurl.dev)** (mise) — run HTTP requests defined in plain text `.hurl` files. Great for API integration tests you can commit alongside code.

```sh
hurl request.hurl                  # run a request file
hurl --test *.hurl                 # run all as tests, report pass/fail
hurl --variable host=localhost:8080 api.hurl
```

Example `.hurl` file:
```
GET http://localhost:8080/api/users
HTTP 200
[Asserts]
jsonpath "$.count" > 0
```

### Mock REST — prism

**[prism](https://stoplight.io/open-source/prism)** mocks from an OpenAPI/Swagger spec. Can also act as a validating proxy to a real API.

```sh
prism mock openapi.yaml                          # mock from local spec
prism mock https://api.example.com/openapi.yaml  # mock from remote spec
prism proxy openapi.yaml https://real-api.com    # validating proxy
```

Compose with xh: `prism mock openapi.yaml &` then `xh :3000/users` — full local request/response flow. Prism validates requests and responses against the spec.

---

## Database

### pgcli

**[pgcli](https://www.pgcli.com)** enhances `psql` with autocomplete, syntax highlighting, and named query shortcuts.

```sh
pgc <database>                                    # alias for pgcli
pgcli -h <host> -U <user> <database>
pgcli postgresql://user:pass@host/db
```

Config at `~/.config/pgcli/config`. Open quickly with **tmux `Ctrl+Space Q`** — spawns a popup from anywhere.

#### Key meta-commands

| Command | Description |
|---------|-------------|
| `\dt` | List all tables |
| `\d <table>` | Describe table |
| `\l` | List databases |
| `\ns <name> <query>` | Save named query |
| `\n <name>` | Run named query |
| `\copy (...) TO 'file.csv'` | Export to CSV |
| `\e` | Open query in `$EDITOR` (Helix) |

Named queries (`\ns`) stored in `~/.config/pgcli/named_queries.cfg`.

### Postgres Language Server

**[postgres-language-server](https://github.com/supabase-community/postgres-language-server)** (brew) provides LSP support for `.sql` files in Helix: syntax diagnostics, formatting, autocomplete (with DB connection), migration linting.

For autocomplete/type checking, create a per-project config:
```sh
postgres-language-server init
# edit generated file to set DB credentials
# add postgres-language-server.jsonc to .gitignore
```

### lazysql + DBeaver

- **[lazysql](https://github.com/jorgerojas26/lazysql)** (mise) — TUI SQL client; Postgres, MySQL, SQLite
- **DBeaver Community** (cask) — GUI client for schema exploration

---

## Kafka

Client-only tools — no local broker needed. Connect directly to remote clusters.

### kcat

**[kcat](https://github.com/edenhill/kcat)** (brew) — netcat for Kafka. C binary, no JVM required.

```sh
# Consume
kcat -C -b broker:9092 -t my-topic
kcat -C -b broker:9092 -t my-topic -o -10 -e   # last 10 messages then exit

# Produce
echo "hello" | kcat -P -b broker:9092 -t my-topic
kcat -P -b broker:9092 -t my-topic < messages.txt

# Inspect
kcat -L -b broker:9092                          # list topics, partitions, brokers
kcat -C -b broker:9092 -t my-topic -f '%k %o %s\n'  # show key + offset + value

# SASL/SSL auth
kcat -C -b broker:9092 -t my-topic \
  -X security.protocol=SASL_SSL \
  -X sasl.mechanisms=PLAIN \
  -X sasl.username=user \
  -X sasl.password=pass
```

### kaskade

**[kaskade](https://github.com/sauljabin/kaskade)** (brew) — interactive TUI for Kafka. Browse topics, consume messages with real-time filtering by key/value/header/partition. Supports JSON, Avro, Protobuf deserialization.

```sh
kaskade consumer -b my-kafka:9092 -t my-topic
```

---

## Workflows

### Test a New API Endpoint

1. `xh POST localhost:8080/api/users name=Alice age:=30` → quick manual test
2. See full response with headers: `xh -v localhost:8080/api/users`
3. Body only for piping: `xh --print=b localhost:8080/api/users | jq '.id'`
4. Save as `.http` file for repeatable tests: `hurl --test api-tests.hurl`
5. Preview request without sending: `xh --offline POST api.example.com key=value`

### Mock an API from OpenAPI Spec

1. `prism mock openapi.yaml` → mock server starts on :4010
2. `xh :4010/users` → prism returns realistic responses matching the schema
3. Frontend team can develop against the mock immediately
4. Validate real API: `prism proxy openapi.yaml https://real-api.com`

### Explore a Postgres Database

1. `Ctrl+Space Q` from any tmux pane → pgcli popup
2. Or: `pgc mydb` → connect with alias
3. `\dt` → list tables, `\d users` → describe schema
4. Write a complex query: `\e` → opens in Helix for editing
5. Save as named query: `\ns active-users SELECT * FROM users WHERE active = true`
6. Reuse anytime: `\n active-users`

### Consume Kafka Messages

1. `kcat -C -b broker:9092 -t my-topic -o -10 -e` → last 10 messages then exit
2. Filter by key: `kcat -C -b broker:9092 -t my-topic -f '%k %s\n' | grep mykey`
3. Interactive browsing: `kaskade consumer -b broker:9092 -t my-topic` → TUI with filtering
4. Produce: `echo '{"event":"test"}' | kcat -P -b broker:9092 -t my-topic`
