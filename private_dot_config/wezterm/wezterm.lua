local wezterm = require("wezterm")
wezterm.log_info("Config reloaded - v2")

local function mergeTables(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end
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
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = false,
	enable_tab_bar = false,
	hide_mouse_cursor_when_typing = true,
	inactive_pane_hsb = {
		brightness = 0.5,
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

	native_macos_fullscreen_mode = false,
}

local colors = require("colors")
mergeTables(config, colors)

config.keys = require("keybinds")
-- config.mouse_bindings = require("mousebinds")

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

return config
