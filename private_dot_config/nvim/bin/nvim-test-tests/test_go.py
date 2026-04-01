"""Tests for the Go runner."""
import subprocess
import pytest
from unittest.mock import patch
from go import GoRunner


@pytest.fixture
def runner():
    return GoRunner()


@pytest.fixture
def go_file(tmp_path):
    f = tmp_path / 'service_test.go'
    f.write_text(
        'package svc\n'
        '\n'
        'func TestProcess(t *testing.T) {\n'
        '    t.Run("happy path", func(t *testing.T) {})\n'
        '    t.Run("error case", func(t *testing.T) {})\n'
        '}\n'
    )
    return str(f)


def test_detect(runner, go_file):
    assert runner.detect(go_file, '') is True


def test_cmd_all(runner, go_file):
    assert runner.cmd_all(go_file) == 'go test ./...'


def test_cmd_func_with_pattern(runner, go_file):
    with patch.object(runner, '_gotest_pattern', return_value='TestProcess/happy_path'):
        cmd = runner.cmd_func(go_file, 'service_test.go', 4)
    assert cmd == "go test -run 'TestProcess' -v ./..."


def test_cmd_cursor_with_pattern(runner, go_file):
    with patch.object(runner, '_gotest_pattern', return_value='TestProcess/happy_path'):
        cmd = runner.cmd_cursor(go_file, 'service_test.go', 4)
    assert cmd == "go test -run 'TestProcess/happy_path' -v ./..."


def test_cmd_func_fallback_when_no_pattern(runner, go_file):
    with patch.object(runner, '_gotest_pattern', return_value=None):
        cmd = runner.cmd_func(go_file, 'service_test.go', 1)
    assert cmd == 'go test ./...'


def test_cmd_cursor_fallback_when_no_pattern(runner, go_file):
    with patch.object(runner, '_gotest_pattern', return_value=None):
        cmd = runner.cmd_cursor(go_file, 'service_test.go', 1)
    assert cmd == 'go test ./...'


def test_cmd_file(runner, go_file, tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    cmd = runner.cmd_file(go_file, 'service_test.go')
    assert cmd == 'go test -count=1 -v ./'
