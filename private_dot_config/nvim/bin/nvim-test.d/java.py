"""Java runner for .java files (all mode only)."""
from runner import Runner


class JavaRunner(Runner):
    extensions = ['java']

    def detect(self, file: str, git_root: str) -> bool:
        return True

    def cmd_all(self, file: str) -> str:
        return 'mvn test'
