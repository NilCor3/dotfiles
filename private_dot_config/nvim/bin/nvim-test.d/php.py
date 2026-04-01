"""PHPUnit runner for .php files."""
import os
import re
from runner import Runner


class PhpRunner(Runner):
    extensions = ['php']

    def detect(self, file: str, git_root: str) -> bool:
        root = git_root or os.getcwd()
        return os.path.exists(os.path.join(root, 'vendor', 'bin', 'phpunit'))

    def cmd_all(self, file: str) -> str:
        return 'vendor/bin/phpunit'

    def cmd_file(self, file: str, rel: str) -> str:
        return f'vendor/bin/phpunit {file}'

    def cmd_cursor(self, file: str, rel: str, line: int) -> str:
        name = self._find_test_fn(file, line)
        if name:
            return f'vendor/bin/phpunit --filter {name} {file}'
        return self.cmd_file(file, rel)

    def cmd_func(self, file: str, rel: str, line: int) -> str:
        return self.cmd_cursor(file, rel, line)

    def _find_test_fn(self, file: str, line: int) -> str | None:
        try:
            lines = open(file).read().splitlines()[:line]
        except OSError:
            return None
        for ln in reversed(lines):
            m = re.search(r'function\s+(test\w+)', ln)
            if m:
                return m.group(1)
        return None
