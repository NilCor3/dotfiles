"""Rust runner for .rs files."""
from runner import Runner, find_rust_fn


class RustRunner(Runner):
    extensions = ['rs']

    def detect(self, file: str, git_root: str) -> bool:
        return True

    def cmd_all(self, file: str) -> str:
        return 'cargo nextest run'

    # cargo nextest has no file-level filter; fall back to all
    # cmd_file raises NotImplementedError → main script falls back to cmd_all

    def cmd_func(self, file: str, rel: str, line: int) -> str:
        name = find_rust_fn(file, line)
        if name:
            return f'cargo nextest run {name}'
        return self.cmd_all(file)

    def cmd_cursor(self, file: str, rel: str, line: int) -> str:
        return self.cmd_func(file, rel, line)
