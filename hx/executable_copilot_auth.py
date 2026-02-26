#!/usr/bin/env python3
"""Authenticate with copilot-language-server via device flow."""
import json
import subprocess
import sys

def send_request(proc, method, params=None, req_id=1):
    msg = {"jsonrpc": "2.0", "id": req_id, "method": method}
    if params is not None:
        msg["params"] = params
    body = json.dumps(msg)
    header = f"Content-Length: {len(body)}\r\n\r\n"
    proc.stdin.write(header + body)
    proc.stdin.flush()

def read_message(proc):
    headers = {}
    while True:
        line = proc.stdout.readline()
        if line == "\r\n" or line == "\n":
            break
        if ":" in line:
            k, v = line.split(":", 1)
            headers[k.strip()] = v.strip()
    length = int(headers.get("Content-Length", 0))
    body = proc.stdout.read(length)
    return json.loads(body)

def read_response(proc, expected_id):
    while True:
        msg = read_message(proc)
        # Skip notifications (no id) and log them
        if "id" not in msg:
            if msg.get("method") == "window/logMessage":
                print(f"[log] {msg['params']['message']}")
            continue
        if msg.get("id") == expected_id:
            return msg

proc = subprocess.Popen(
    ["copilot-language-server", "--stdio"],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True,
)

# Initialize
send_request(proc, "initialize", {
    "processId": None,
    "capabilities": {},
    "initializationOptions": {
        "editorInfo": {"name": "Helix", "version": "25.01"},
        "editorPluginInfo": {"name": "helix-copilot", "version": "0.1.0"},
    },
})
resp = read_response(proc, 1)
print("Initialized:", resp.get("result", {}).get("serverInfo", {}))

# Send initialized notification
notify = {"jsonrpc": "2.0", "method": "initialized", "params": {}}
body = json.dumps(notify)
proc.stdin.write(f"Content-Length: {len(body)}\r\n\r\n{body}")
proc.stdin.flush()

# SignIn request
send_request(proc, "signIn", {}, 2)
resp = read_response(proc, 2)
result = resp.get("result", {})

if "verificationUri" in result:
    print(f"\n1. Go to: {result['verificationUri']}")
    print(f"2. Enter code: {result['userCode']}\n")
    input("Press Enter after authorizing...")

    # Check auth status
    send_request(proc, "signInConfirm", {"userCode": result["userCode"]}, req_id=3)
    resp = read_response(proc, 3)
    print("Auth result:", resp)
else:
    print("SignIn response:", resp)

proc.terminate()
