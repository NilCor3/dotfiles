"""Vitest runner for .ts/.tsx/.js/.jsx files."""
import os
from runner import Runner, find_js_name


class VitestRunner(Runner):
    extensions = ['ts', 'tsx', 'js', 'jsx']

    def detect(self, file: str, git_root: str) -> bool:
        if not git_root:
            return True
        return not (
            os.path.exists(os.path.join(git_root, 'playwright.config.ts')) or
            os.path.exists(os.path.join(git_root, 'playwright.config.js'))
        )

    def cmd_all(self, file: str) -> str:
        return 'npx vitest run'

    def cmd_file(self, file: str, rel: str) -> str:
        return f'npx vitest run {rel}'

    def cmd_func(self, file: str, rel: str, line: int) -> str:
        """Run the enclosing describe block."""
        name = find_js_name(file, line, 'describe')
        if name:
            return f"npx vitest run {rel} -t '{name}'"
        return self.cmd_file(file, rel)

    def cmd_cursor(self, file: str, rel: str, line: int) -> str:
        """Run the nearest it/test at or above cursor."""
        name = find_js_name(file, line, 'it|test')
        if name:
            return f"npx vitest run {rel} -t '{name}'"
        return self.cmd_file(file, rel)
