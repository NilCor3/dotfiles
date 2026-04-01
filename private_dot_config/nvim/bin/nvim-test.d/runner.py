"""Base Runner class and shared helpers for nvim-test."""
import re
import os
from abc import ABC, abstractmethod
from typing import Optional


class Runner(ABC):
    extensions: list[str] = []

    @abstractmethod
    def detect(self, file: str, git_root: str) -> bool:
        """Return True if this runner should handle the given file."""

    @abstractmethod
    def cmd_all(self, file: str) -> str:
        """Run all tests in the project."""

    def cmd_file(self, file: str, rel: str) -> str:
        """Run all tests in the given file. Falls back to cmd_all."""
        raise NotImplementedError

    def cmd_func(self, file: str, rel: str, line: int) -> str:
        """Run the enclosing suite/describe block. Falls back to cmd_file."""
        raise NotImplementedError

    def cmd_cursor(self, file: str, rel: str, line: int) -> str:
        """Run the nearest test at or above cursor. Falls back to cmd_func."""
        raise NotImplementedError


def find_js_name(file: str, line: int, pattern: str) -> Optional[str]:
    """Scan lines[0:line] in reverse for a JS test/describe name.

    pattern: regex alternation for the function name, e.g. 'it|test' or 'describe'
    Returns the string literal argument, or None if not found.
    """
    try:
        lines = open(file).read().splitlines()[:line]
    except OSError:
        return None
    regex = re.compile(r'(?:' + pattern + r')\s*\(\s*[\'"`]([^\'"`]+)')
    for ln in reversed(lines):
        m = regex.search(ln)
        if m:
            return m.group(1)
    return None


def find_rust_fn(file: str, line: int) -> Optional[str]:
    """Scan lines[0:line] in reverse for a Rust test function name."""
    try:
        lines = open(file).read().splitlines()[:line]
    except OSError:
        return None
    for ln in reversed(lines):
        m = re.search(r'fn\s+(test_\w+)', ln)
        if m:
            return m.group(1)
    return None
