#!/usr/bin/env python3
"""Find the cargo test filter pattern for the test at the given file:line.

Usage: hx-rusttest.py <file> <line> [cursor|func|file]

Outputs a pattern suitable for `cargo nextest run <pattern>`.
"""

import sys
import re

# Matches any test attribute: #[test], #[tokio::test], #[rstest], etc.
TEST_ATTR_RE = re.compile(r'#\[.*\btest\b.*\]')
# Matches a function signature line
FN_RE = re.compile(r'^\s*(?:pub\s+)?(?:async\s+)?fn\s+(\w+)\s*[(<]')
# Matches a mod declaration
MOD_RE = re.compile(r'^\s*(?:pub\s+)?mod\s+(\w+)\s*\{')


def parse_tests(lines):
    """Return list of (start_line, end_line, fn_name, mod_name) for all test fns.

    start_line and end_line are 0-based indices.
    mod_name may be None if the test is not inside a named mod block.
    """
    results = []
    # Track mod stack: list of (mod_name, brace_depth_at_open)
    mod_stack = []
    brace_depth = 0
    pending_test_attr = False  # True when we've seen a test attribute on a recent line
    attr_start = 0  # line index of the first test attribute in a run

    i = 0
    while i < len(lines):
        line = lines[i]

        # Count braces to track nesting depth changes
        opens = line.count('{')
        closes = line.count('}')

        # Check for mod declaration before updating depth
        mod_match = MOD_RE.match(line)
        if mod_match and '{' in line:
            mod_stack.append((mod_match.group(1), brace_depth))

        # Update brace depth
        brace_depth += opens - closes

        # Pop mod stack when we drop below the mod's open depth
        while mod_stack and brace_depth <= mod_stack[-1][1]:
            mod_stack.pop()

        # Detect test attributes
        if TEST_ATTR_RE.search(line):
            if not pending_test_attr:
                attr_start = i  # track first test attr line for inclusive range
            pending_test_attr = True
            i += 1
            continue

        # Detect function declaration
        fn_match = FN_RE.match(line)
        if fn_match and pending_test_attr:
            fn_name = fn_match.group(1)
            fn_start = attr_start  # include attribute line(s) in range
            # Find function end by tracking brace depth
            fn_brace = 0
            fn_end = i
            for k in range(i, len(lines)):
                fn_brace += lines[k].count('{') - lines[k].count('}')
                if k > i and fn_brace <= 0:
                    fn_end = k
                    break
                fn_end = k  # fallback: last line if no closing found

            mod_name = mod_stack[-1][0] if mod_stack else None
            results.append((fn_start, fn_end, fn_name, mod_name))
            pending_test_attr = False
        elif line.strip() and not line.strip().startswith('#[') and not line.strip().startswith('//'):
            # Reset pending test attr if we hit something that isn't an attribute
            if not TEST_ATTR_RE.search(line):
                pending_test_attr = False

        i += 1

    return results


def find_at_cursor(lines, target_line):
    """Return (fn_name, mod_name) for test containing target_line (0-based), or None."""
    tests = parse_tests(lines)
    for start, end, name, mod_name in tests:
        if start <= target_line <= end:
            return name, mod_name
    return None, None


def file_pattern(lines):
    """Return a filter matching all test functions in the file."""
    tests = parse_tests(lines)
    if not tests:
        return None
    # Just return a pattern that matches any of the test function names.
    # cargo nextest run supports substring matching; joining unique names works.
    names = [name for _, _, name, _ in tests]
    if len(names) == 1:
        return names[0]
    # Use a broad pattern — nextest will match all of them if we run without filter
    # and restrict to the package. For file mode, return the joined names as alternation.
    # nextest run accepts -E 'test(name)' but the simplest is to just run all.
    # We return a special sentinel so the shell script knows to run without filter.
    return "__ALL__"


def make_pattern(fn_name, mod_name):
    """Build the cargo nextest filter pattern."""
    if mod_name:
        return f"{mod_name}::{fn_name}"
    return fn_name


def main():
    if len(sys.argv) < 3:
        print("usage: hx-rusttest.py <file> <line> [cursor|func|file]", file=sys.stderr)
        sys.exit(1)

    filename = sys.argv[1]
    try:
        line = int(sys.argv[2]) - 1  # convert to 0-based
    except ValueError:
        print(f"invalid line number: {sys.argv[2]}", file=sys.stderr)
        sys.exit(1)

    mode = sys.argv[3] if len(sys.argv) >= 4 else "cursor"

    try:
        with open(filename) as f:
            lines = f.readlines()
    except OSError as e:
        print(f"cannot open file: {e}", file=sys.stderr)
        sys.exit(1)

    if mode == "file":
        pattern = file_pattern(lines)
        if not pattern:
            print("no test functions found in file", file=sys.stderr)
            sys.exit(1)
        print(pattern)
        return

    # cursor or func mode
    fn_name, mod_name = find_at_cursor(lines, line)
    if not fn_name:
        print("cursor is not inside a test function", file=sys.stderr)
        sys.exit(1)

    print(make_pattern(fn_name, mod_name))


if __name__ == "__main__":
    main()
