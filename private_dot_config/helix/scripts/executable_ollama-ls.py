#!/usr/bin/env python3
"""
ollama-ls: LSP bridge implementing textDocument/inlineCompletion via ollama FIM.
Speaks LSP stdio protocol; connects to ollama at localhost:11434.
Model: qwen2.5-coder:7b (FIM: <|fim_prefix|>...<|fim_suffix|>...<|fim_middle|>)
"""
import json
import sys
import urllib.request
import urllib.error
import logging
import os

OLLAMA_URL = "http://127.0.0.1:11434/api/generate"
MODEL = "qwen2.5-coder:7b"
TIMEOUT = 5  # seconds — fast on Apple Silicon
MAX_PREFIX = 4000  # chars
MAX_SUFFIX = 1000  # chars

log = logging.getLogger("ollama-ls")
logging.basicConfig(filename="/tmp/ollama-ls.log", level=logging.DEBUG)


# ── LSP I/O ──────────────────────────────────────────────────────────────────

def read_message():
    headers = {}
    while True:
        line = sys.stdin.buffer.readline()
        if not line:
            return None
        line = line.rstrip(b"\r\n").decode("utf-8")
        if line == "":
            break
        if ":" in line:
            k, v = line.split(":", 1)
            headers[k.strip().lower()] = v.strip()
    length = int(headers.get("content-length", 0))
    body = sys.stdin.buffer.read(length).decode("utf-8")
    return json.loads(body)


def send_message(msg):
    body = json.dumps(msg)
    encoded = body.encode("utf-8")
    header = f"Content-Length: {len(encoded)}\r\n\r\n".encode("utf-8")
    sys.stdout.buffer.write(header + encoded)
    sys.stdout.buffer.flush()


def send_response(req_id, result):
    send_message({"jsonrpc": "2.0", "id": req_id, "result": result})


def send_error(req_id, code, message):
    send_message({"jsonrpc": "2.0", "id": req_id, "error": {"code": code, "message": message}})


# ── Ollama ────────────────────────────────────────────────────────────────────

def complete_fim(prefix: str, suffix: str) -> str | None:
    prompt = f"<|fim_prefix|>{prefix}<|fim_suffix|>{suffix}<|fim_middle|>"
    payload = json.dumps({
        "model": MODEL,
        "prompt": prompt,
        "stream": False,
        "options": {"temperature": 0.1, "stop": ["<|fim_pad|>", "<|repo_name|>", "<|file_sep|>", "\n\n"]},
    }).encode()
    try:
        req = urllib.request.Request(OLLAMA_URL, data=payload, headers={"Content-Type": "application/json"})
        with urllib.request.urlopen(req, timeout=TIMEOUT) as r:
            resp = json.loads(r.read())
            text = resp.get("response", "")
            # Strip markdown code fences if model wraps output
            if text.startswith("```"):
                lines = text.splitlines()
                # drop first line (``` or ```lang) and last ``` line
                inner = lines[1:-1] if lines[-1].strip() == "```" else lines[1:]
                text = "\n".join(inner)
            return text
    except Exception as e:
        log.warning("ollama request failed: %s", e)
        return None


# ── File reading ──────────────────────────────────────────────────────────────

def read_file(uri: str) -> str:
    path = uri.removeprefix("file://")
    try:
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            return f.read()
    except OSError:
        return ""


# ── LSP handlers ─────────────────────────────────────────────────────────────

def handle_initialize(req_id, _params):
    send_response(req_id, {
        "capabilities": {
            "inlineCompletionProvider": True,
        },
        "serverInfo": {"name": "ollama-ls", "version": "0.1.0"},
    })


def handle_inline_completion(req_id, params):
    uri = params["textDocument"]["uri"]
    pos = params["position"]
    line_no = pos["line"]
    char_no = pos["character"]

    content = read_file(uri)
    lines = content.splitlines(keepends=True)

    # Split at cursor
    prefix_lines = lines[:line_no]
    cursor_line = lines[line_no] if line_no < len(lines) else ""
    suffix_lines = lines[line_no + 1:] if line_no + 1 < len(lines) else []

    prefix = "".join(prefix_lines) + cursor_line[:char_no]
    suffix = cursor_line[char_no:] + "".join(suffix_lines)

    # Trim to context window
    prefix = prefix[-MAX_PREFIX:]
    suffix = suffix[:MAX_SUFFIX]

    log.debug("inline_completion at %d:%d prefix_len=%d suffix_len=%d", line_no, char_no, len(prefix), len(suffix))

    completion = complete_fim(prefix, suffix)
    if not completion:
        send_response(req_id, {"items": []})
        return

    # Strip any trailing newlines from single-line completions (cleaner)
    completion = completion.rstrip("\n") if "\n" not in completion.rstrip("\n") else completion

    send_response(req_id, {
        "items": [{
            "insertText": completion,
            "range": {
                "start": {"line": line_no, "character": char_no},
                "end": {"line": line_no, "character": char_no},
            },
        }],
    })


# ── Main loop ─────────────────────────────────────────────────────────────────

def main():
    log.info("ollama-ls started")
    while True:
        msg = read_message()
        if msg is None:
            break
        method = msg.get("method", "")
        req_id = msg.get("id")
        params = msg.get("params", {})
        log.debug("← %s", method)

        if method == "initialize":
            handle_initialize(req_id, params)
        elif method == "initialized":
            pass  # notification, no response
        elif method == "textDocument/inlineCompletion":
            handle_inline_completion(req_id, params)
        elif method == "shutdown":
            send_response(req_id, None)
        elif method == "exit":
            break
        elif req_id is not None:
            # Unknown request — return empty/null
            send_response(req_id, None)
        # Notifications (no id) are silently ignored


if __name__ == "__main__":
    main()
