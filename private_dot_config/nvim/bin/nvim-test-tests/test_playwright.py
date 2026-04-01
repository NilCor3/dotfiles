"""Tests for the Playwright runner."""
import pytest
from playwright import PlaywrightRunner


@pytest.fixture
def runner():
    return PlaywrightRunner()


@pytest.fixture
def ts_file(tmp_path):
    (tmp_path / 'playwright.config.ts').touch()
    f = tmp_path / 'login.spec.ts'
    f.write_text(
        "import { test } from '@playwright/test'\n"
        "describe('Auth', () => {\n"
        "  test('user can login', async ({ page }) => {})\n"
        "})\n"
    )
    return str(f), str(tmp_path)


def test_detect_with_config_ts(runner, tmp_path):
    (tmp_path / 'playwright.config.ts').touch()
    assert runner.detect(str(tmp_path / 'x.ts'), str(tmp_path)) is True


def test_detect_with_config_js(runner, tmp_path):
    (tmp_path / 'playwright.config.js').touch()
    assert runner.detect(str(tmp_path / 'x.ts'), str(tmp_path)) is True


def test_detect_without_config(runner, tmp_path):
    assert runner.detect(str(tmp_path / 'x.ts'), str(tmp_path)) is False


def test_cmd_all(runner, ts_file):
    f, _ = ts_file
    assert runner.cmd_all(f) == 'npx playwright test'


def test_cmd_file(runner, ts_file):
    f, _ = ts_file
    assert runner.cmd_file(f, 'login.spec.ts') == 'npx playwright test login.spec.ts'


def test_cmd_cursor(runner, ts_file):
    f, _ = ts_file
    # line 3 is the test line
    cmd = runner.cmd_cursor(f, 'login.spec.ts', 3)
    assert cmd == 'npx playwright test login.spec.ts:3'


def test_cmd_func_finds_describe(runner, ts_file):
    f, _ = ts_file
    # line 3 is inside the describe block
    cmd = runner.cmd_func(f, 'login.spec.ts', 3)
    assert cmd == "npx playwright test --grep 'Auth'"


def test_cmd_func_fallback_to_file(runner, tmp_path):
    (tmp_path / 'playwright.config.ts').touch()
    f = tmp_path / 'bare.spec.ts'
    f.write_text("test('bare test', async () => {})\n")
    cmd = runner.cmd_func(str(f), 'bare.spec.ts', 1)
    assert cmd == 'npx playwright test bare.spec.ts'
