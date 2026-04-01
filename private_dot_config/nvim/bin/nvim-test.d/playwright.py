"""Playwright runner for .ts/.tsx/.js/.jsx files."""
import os
from runner import Runner, find_js_name


class PlaywrightRunner(Runner):
    extensions = ['ts', 'tsx', 'js', 'jsx']

    def detect(self, file: str, git_root: str) -> bool:
        if not git_root:
            return False
        return (
            os.path.exists(os.path.join(git_root, 'playwright.config.ts')) or
            os.path.exists(os.path.join(git_root, 'playwright.config.js'))
        )

    def cmd_all(self, file: str) -> str:
        return 'npx playwright test'

    def cmd_file(self, file: str, rel: str) -> str:
        return f'npx playwright test {rel}'

    def cmd_func(self, file: str, rel: str, line: int) -> str:
        """Run the enclosing describe block via --grep."""
        name = find_js_name(file, line, 'describe')
        if name:
            return f"npx playwright test --grep '{name}'"
        return self.cmd_file(file, rel)

    def cmd_cursor(self, file: str, rel: str, line: int) -> str:
        """Run the test at the cursor line via file:line."""
        return f'npx playwright test {rel}:{line}'
