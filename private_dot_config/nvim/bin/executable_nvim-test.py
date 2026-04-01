#!/usr/bin/env python3
"""nvim-test.py <file> <line> <mode>

Sends a test command to the 'tests' tmux pane (creates it if needed).
mode: all | file | func | cursor
"""
import sys
import os
import subprocess
import importlib.util
from pathlib import Path

RUNNERS_DIR = Path(__file__).parent / 'nvim-test.d'
FALLBACK_CHAIN = ['cursor', 'func', 'file', 'all']


# ── tmux pane management ────────────────────────────────────────────────────

def find_or_create_tests_pane() -> str:
    window = subprocess.check_output(
        ['tmux', 'display-message', '-p', '#{window_id}']
    ).decode().strip()

    panes = subprocess.check_output(
        ['tmux', 'list-panes', '-t', window, '-F', '#{pane_title} #{pane_id}']
    ).decode().strip()

    for line in panes.splitlines():
        parts = line.split()
        if parts and parts[0] == 'tests':
            return parts[1]

    # Create new pane split to the right
    pane = subprocess.check_output(
        ['tmux', 'split-window', '-h', '-P', '-F', '#{pane_id}', '-c', os.getcwd()]
    ).decode().strip()
    subprocess.run(['tmux', 'select-pane', '-t', pane, '-T', 'tests'], check=True)

    # Return focus to nvim
    tmux_pane = os.environ.get('TMUX_PANE', '')
    if tmux_pane:
        subprocess.run(['tmux', 'select-pane', '-t', tmux_pane], check=True)

    return pane


def send(pane: str, cmd: str, cwd: str) -> None:
    import shlex
    # Cancel any incomplete input in the pane before sending the command
    subprocess.run(['tmux', 'send-keys', '-t', pane, 'C-c', ''])
    full_cmd = f'cd {shlex.quote(cwd)} && {cmd}'
    subprocess.run(['tmux', 'send-keys', '-t', pane, full_cmd, 'Enter'], check=True)


# ── runner loading ──────────────────────────────────────────────────────────

def load_runners():
    sys.path.insert(0, str(RUNNERS_DIR))
    runners = []
    for f in sorted(RUNNERS_DIR.glob('*.py')):
        if f.name == 'runner.py':
            continue
        spec = importlib.util.spec_from_file_location(f.stem, f)
        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
        # Each module exposes its runner class as <Name>Runner
        for attr in dir(mod):
            cls = getattr(mod, attr)
            if (
                isinstance(cls, type)
                and attr.endswith('Runner')
                and attr != 'Runner'
            ):
                runners.append(cls())
    return runners


# ── command dispatch ────────────────────────────────────────────────────────

def get_cmd(runner, mode: str, file: str, rel: str, line: int) -> str:
    methods = {
        'all':    lambda: runner.cmd_all(file),
        'file':   lambda: runner.cmd_file(file, rel),
        'func':   lambda: runner.cmd_func(file, rel, line),
        'cursor': lambda: runner.cmd_cursor(file, rel, line),
    }
    start = FALLBACK_CHAIN.index(mode)
    for m in FALLBACK_CHAIN[start:]:
        try:
            return methods[m]()
        except NotImplementedError:
            continue
    raise RuntimeError(f"No command available for mode '{mode}'")


# ── main ────────────────────────────────────────────────────────────────────

def main() -> None:
    if len(sys.argv) < 4:
        print(f'Usage: {sys.argv[0]} <file> <line> <mode>', file=sys.stderr)
        sys.exit(1)

    file = sys.argv[1]
    line = int(sys.argv[2])
    mode = sys.argv[3]

    ext = Path(file).suffix.lstrip('.')

    git_root = subprocess.run(
        ['git', 'rev-parse', '--show-toplevel'],
        capture_output=True, text=True,
        cwd=str(Path(file).parent)
    ).stdout.strip()

    pane = find_or_create_tests_pane()

    runners = load_runners()
    runner = next(
        (r for r in runners if ext in r.extensions and r.detect(file, git_root)),
        None
    )

    if runner is None:
        subprocess.run(['tmux', 'display-message', f'nvim-test: no runner for .{ext}'])
        sys.exit(1)

    rel = os.path.relpath(file, os.getcwd())

    try:
        cmd = get_cmd(runner, mode, file, rel, line)
    except RuntimeError as e:
        subprocess.run(['tmux', 'display-message', f'nvim-test: {e}'])
        sys.exit(1)

    send(pane, cmd, os.getcwd())


if __name__ == '__main__':
    main()
