"""Tests for the Vitest runner."""
import pytest
from vitest import VitestRunner


@pytest.fixture
def runner():
    return VitestRunner()


@pytest.fixture
def ts_file(tmp_path):
    f = tmp_path / 'foo.test.ts'
    f.write_text(
        "describe('MyGroup', () => {\n"
        "  it('does the thing', () => {})\n"
        "  it('does another thing', () => {})\n"
        "})\n"
    )
    return str(f)


def test_detect_no_playwright(runner, tmp_path):
    assert runner.detect(str(tmp_path / 'x.ts'), str(tmp_path)) is True


def test_detect_with_playwright_ts(runner, tmp_path):
    (tmp_path / 'playwright.config.ts').touch()
    assert runner.detect(str(tmp_path / 'x.ts'), str(tmp_path)) is False


def test_detect_with_playwright_js(runner, tmp_path):
    (tmp_path / 'playwright.config.js').touch()
    assert runner.detect(str(tmp_path / 'x.ts'), str(tmp_path)) is False


def test_cmd_all(runner, ts_file):
    assert runner.cmd_all(ts_file) == 'npx vitest run'


def test_cmd_file(runner, ts_file):
    rel = 'src/foo.test.ts'
    assert runner.cmd_file(ts_file, rel) == 'npx vitest run src/foo.test.ts'


def test_cmd_cursor_finds_it(runner, ts_file):
    rel = 'foo.test.ts'
    # line 2 is the first it(
    cmd = runner.cmd_cursor(ts_file, rel, 2)
    assert cmd == "npx vitest run foo.test.ts -t 'does the thing'"


def test_cmd_cursor_finds_nearest_it(runner, ts_file):
    rel = 'foo.test.ts'
    # line 3 is the second it(
    cmd = runner.cmd_cursor(ts_file, rel, 3)
    assert cmd == "npx vitest run foo.test.ts -t 'does another thing'"


def test_cmd_cursor_fallback_to_file(runner, tmp_path):
    f = tmp_path / 'empty.test.ts'
    f.write_text('// no tests here\n')
    cmd = runner.cmd_cursor(str(f), 'empty.test.ts', 1)
    assert cmd == 'npx vitest run empty.test.ts'


def test_cmd_func_finds_describe(runner, ts_file):
    rel = 'foo.test.ts'
    # line 2 is inside the describe block
    cmd = runner.cmd_func(ts_file, rel, 2)
    assert cmd == "npx vitest run foo.test.ts -t 'MyGroup'"


def test_cmd_func_fallback_to_file(runner, tmp_path):
    f = tmp_path / 'nodescribe.test.ts'
    f.write_text("it('solo', () => {})\n")
    cmd = runner.cmd_func(str(f), 'nodescribe.test.ts', 1)
    assert cmd == 'npx vitest run nodescribe.test.ts'


def test_cmd_cursor_double_quotes(runner, tmp_path):
    f = tmp_path / 'dq.test.ts'
    f.write_text('it("double quoted", () => {})\n')
    cmd = runner.cmd_cursor(str(f), 'dq.test.ts', 1)
    assert cmd == "npx vitest run dq.test.ts -t 'double quoted'"


def test_cmd_cursor_backtick(runner, tmp_path):
    f = tmp_path / 'bt.test.ts'
    f.write_text('it(`backtick name`, () => {})\n')
    cmd = runner.cmd_cursor(str(f), 'bt.test.ts', 1)
    assert cmd == "npx vitest run bt.test.ts -t 'backtick name'"
