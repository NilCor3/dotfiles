"""Add nvim-test.d to sys.path so runners can import from runner.py."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / 'nvim-test.d'))
