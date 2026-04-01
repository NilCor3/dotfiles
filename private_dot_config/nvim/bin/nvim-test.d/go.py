"""Go runner for .go files."""
import os
import subprocess
from pathlib import Path
from runner import Runner


class GoRunner(Runner):
    extensions = ['go']

    def detect(self, file: str, git_root: str) -> bool:
        return True

    def cmd_all(self, file: str) -> str:
        return 'go test ./...'

    def cmd_file(self, file: str, rel: str) -> str:
        rel_dir = os.path.relpath(str(Path(file).parent), os.getcwd())
        pkg = './' if rel_dir == '.' else './' + rel_dir
        return f'go test -count=1 -v {pkg}'

    def cmd_func(self, file: str, rel: str, line: int) -> str:
        pattern = self._gotest_pattern(file, line)
        if pattern:
            func_name = pattern.split('/')[0]
            return f"go test -run '{func_name}' -v ./..."
        return self.cmd_all(file)

    def cmd_cursor(self, file: str, rel: str, line: int) -> str:
        pattern = self._gotest_pattern(file, line)
        if pattern:
            return f"go test -run '{pattern}' -v ./..."
        return self.cmd_all(file)

    def _gotest_pattern(self, file: str, line: int) -> str | None:
        binary = Path.home() / '.local' / 'bin' / 'hx-gotest'
        result = subprocess.run(
            [str(binary), file, str(line)],
            capture_output=True, text=True
        )
        return result.stdout.strip() or None
