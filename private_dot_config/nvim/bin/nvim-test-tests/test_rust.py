"""Tests for the Rust runner."""
import pytest
from rust import RustRunner


@pytest.fixture
def runner():
    return RustRunner()


@pytest.fixture
def rs_file(tmp_path):
    f = tmp_path / 'lib.rs'
    f.write_text(
        '#[cfg(test)]\n'
        'mod tests {\n'
        '    #[test]\n'
        '    fn test_add() { assert_eq!(2 + 2, 4); }\n'
        '\n'
        '    #[test]\n'
        '    fn test_subtract() { assert_eq!(4 - 2, 2); }\n'
        '}\n'
    )
    return str(f)


def test_detect(runner, rs_file):
    assert runner.detect(rs_file, '') is True


def test_cmd_all(runner, rs_file):
    assert runner.cmd_all(rs_file) == 'cargo nextest run'


def test_cmd_file_raises(runner, rs_file):
    with pytest.raises(NotImplementedError):
        runner.cmd_file(rs_file, 'lib.rs')


def test_cmd_cursor_finds_fn(runner, rs_file):
    # line 4 is test_add
    cmd = runner.cmd_cursor(rs_file, 'lib.rs', 4)
    assert cmd == 'cargo nextest run test_add'


def test_cmd_func_finds_fn(runner, rs_file):
    # line 7 is test_subtract
    cmd = runner.cmd_func(rs_file, 'lib.rs', 7)
    assert cmd == 'cargo nextest run test_subtract'


def test_cmd_cursor_fallback_when_no_fn(runner, tmp_path):
    f = tmp_path / 'nofn.rs'
    f.write_text('fn main() {}\n')
    cmd = runner.cmd_cursor(str(f), 'nofn.rs', 1)
    assert cmd == 'cargo nextest run'
