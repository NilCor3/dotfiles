local wezterm = require("wezterm")
local mux = wezterm.mux
wezterm.log_info("Config reloaded - v2")

local function mergeTables(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end
end

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local config = {
	enable_kitty_keyboard = true,
	default_workspace = "~",
	font = require("font").font,
	font_rules = require("font").font_rules,
	warn_about_missing_glyphs = false,

	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	hide_tab_bar_if_only_one_tab = false,
	hide_mouse_cursor_when_typing = true,
	inactive_pane_hsb = {
		brightness = 0.7,
	},
	scrollback_lines = 10000,
	audible_bell = "Disabled",
	enable_scroll_bar = true,

	status_update_interval = 1000,
	xcursor_theme = "Adwaita", -- fix cursor bug on gnome + wayland

	max_fps = 120,
	-- front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
	disable_default_key_bindings = true,

	native_macos_fullscreen_mode = true,
}

local colors = require("colors")
mergeTables(config, colors)

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = require("keybinds")
-- config.mouse_bindings = require("mousebinds")

local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)

-- Pane auto-collapse: initialise state and register the restore-on-focus handler.
local pc = require("pane_collapse")
pc.init()

-- Patch copy_mode key_table after modal sets it up.
-- Fixes a bug in modal.wezterm defaults where both `t` and `T` are JumpBackward.
-- Also adds Helix-style `x` for line selection.
local function patch_copy_mode(key_tables)
	local copy_mode = key_tables.copy_mode
	for i, binding in ipairs(copy_mode) do
		-- Fix: `t` should be JumpForward (till char forward), not JumpBackward
		if binding.key == "t" and (binding.mods == nil or binding.mods == "NONE") then
			copy_mode[i] = { key = "t", action = wezterm.action.CopyMode({ JumpForward = { prev_char = true } }) }
		end
	end
	-- Add `x` → select current line (Helix: x selects line, like vim's V)
	table.insert(copy_mode, { key = "x", action = wezterm.action.CopyMode({ SetSelectionMode = "Line" }) })
end
patch_copy_mode(config.key_tables)

wezterm.on("modal.enter", function(name, window, pane)
	modal.set_right_status(window, name)
	modal.set_window_title(pane, name)
end)

wezterm.on("modal.exit", function(name, window, pane)
	local title = basename(window:active_workspace())
	window:set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = title .. "  " },
	}))
	modal.reset_window_title(pane)
end)

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.state_manager.periodic_save({
	interval_seconds = 15 * 60,
	save_workspaces = true,
	save_windows = true,
	save_tabs = true,
})

resurrect.state_manager.set_encryption({
	enable = false,
	private_key = wezterm.home_dir .. "/.age/resurrect.txt",
	public_key = "age1ddyj7qftw3z5ty84gyns25m0yc92e2amm3xur3udwh2262pa5afqe3elg7",
})

wezterm.on("resurrect.error", function(err)
	wezterm.log_error("ERROR!")
	wezterm.gui.gui_windows()[1]:toast_notification("resurrect", err, nil, 3000)
end)

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.apply_to_config({})

workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { Color = colors.colors.ansi[3] } },
		{ Background = { Color = colors.colors.background } },
		{ Text = "󱂬 : " .. label },
	})
end

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.state_manager.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,

		resize_window = false,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, label)
	wezterm.log_info(window)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	wezterm.log_info(window)
	local workspace_state = resurrect.workspace_state
	resurrect.state_manager.save_state(workspace_state.get_workspace_state())
	resurrect.state_manager.write_current_state(label, "workspace")
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.start", function(window, _)
	wezterm.log_info(window)
end)
wezterm.on("smart_workspace_switcher.workspace_switcher.canceled", function(window, _)
	wezterm.log_info(window)
end)

local domains = wezterm.plugin.require("https://github.com/DavidRR-F/quick_domains.wezterm")
domains.apply_to_config(config, {
	keys = {
		attach = {
			key = "t",
			mods = "ALT|SHIFT",
			tbl = "",
		},
		vsplit = {
			key = "_",
			mods = "CTRL|ALT",
			tbl = "",
		},
		hsplit = {
			key = "-",
			mods = "CTRL|ALT",
			tbl = "",
		},
	},
	auto = {
		ssh_ignore = true,
		exec_ignore = {
			ssh = true,
			docker = true,
			kubernetes = true,
		},
	},
})

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = " "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("(%d/%d) ", tab.tab_index + 1, #tabs)
	end

	return zoomed .. index .. tab.active_pane.title
end)

wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

return config
