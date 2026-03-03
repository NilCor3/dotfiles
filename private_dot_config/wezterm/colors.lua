local wezterm = require("wezterm")

-- Change this one line to switch themes.
local THEME = "GruvboxDark"

local scheme = wezterm.color.get_builtin_schemes()[THEME]

-- Many built-in schemes omit tab_bar entirely. Build it from the palette when missing.
if not scheme.tab_bar then
	local bg = scheme.background
	local fg = scheme.foreground
	local dark = scheme.ansi[1]      -- usually the darkest shade, slightly darker than bg
	local accent = scheme.brights[5] -- bright blue/accent for active tab text
	local muted = scheme.ansi[8]     -- muted white/gray for inactive tab text
	local sel = scheme.selection_bg

	scheme.tab_bar = {
		background = dark,
		active_tab = {
			bg_color = bg,
			fg_color = accent,
		},
		inactive_tab = {
			bg_color = dark,
			fg_color = muted,
		},
		inactive_tab_hover = {
			bg_color = sel,
			fg_color = fg,
		},
		new_tab = {
			bg_color = dark,
			fg_color = muted,
		},
		new_tab_hover = {
			bg_color = sel,
			fg_color = fg,
		},
		inactive_tab_edge = sel,
	}
else
	-- Scheme has tab_bar data. Apply inversion so active tab shows a filled background
	-- rather than just colored text (original Tokyo Night Storm style).
	local tb = scheme.tab_bar
	tb.new_tab.bg_color = tb.inactive_tab.bg_color
	tb.background = scheme.background
	local orig_fg = tb.active_tab.fg_color
	local orig_bg = tb.active_tab.bg_color
	tb.active_tab.bg_color = orig_fg
	tb.active_tab.fg_color = orig_bg
	tb.inactive_tab_hover.bg_color = scheme.selection_bg
	tb.inactive_tab_edge = scheme.selection_bg
end

-- Make the pane split line clearly visible using the scheme's bright yellow/accent
scheme.split = scheme.brights[4]

return {
	window_frame = {
		inactive_titlebar_bg = scheme.background,
		active_titlebar_bg = scheme.background,
		inactive_titlebar_fg = scheme.foreground,
		active_titlebar_fg = scheme.foreground,
	},
	command_palette_bg_color = scheme.background,
	command_palette_fg_color = scheme.foreground,
	char_select_bg_color = scheme.background,
	char_select_fg_color = scheme.tab_bar.active_tab.fg_color,
	colors = scheme,
}
