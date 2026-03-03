local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
-- Font size
{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
{ key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
-- Clipboard
{ key = "c", mods = "CMD", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },
{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
-- Scroll to shell prompt
{ key = "UpArrow",   mods = "SHIFT", action = act.ScrollToPrompt(-1) },
{ key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
-- Outer scrollback (scrolls WezTerm viewport, useful outside Zellij)
{ key = "j", mods = "CTRL|SHIFT", action = act.ScrollByLine(1) },
{ key = "k", mods = "CTRL|SHIFT", action = act.ScrollByLine(-1) },
{ key = "d", mods = "CTRL|SHIFT", action = act.ScrollByPage(0.5) },
{ key = "u", mods = "CTRL|SHIFT", action = act.ScrollByPage(-0.5) },
-- Fix Delete key (macOS sends BS/^H; remap to proper ESC[3~ sequence)
{ key = "Delete", mods = "", action = act.SendString("\x1b[3~") },
}

return keys
