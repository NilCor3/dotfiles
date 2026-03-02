
local wezterm = require("wezterm")
local act = wezterm.action
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")

local keys = {
	{key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize},
	{key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize},
	{key = "c", mods = "CMD", action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection'},
	{key = "v", mods = "CMD", action = wezterm.action.PasteFrom 'Clipboard'},

 --    -- Because of kitty protocol bug: https://github.com/nushell/nushell/issues/14783
 --    { key = "Delete", action = act.SendKey { key = "Delete" } },
 -- --    {
	-- 	key = "s",
	-- 	mods = "LEADER",
	-- 	action = workspace_switcher.switch_workspace(),
	-- },
	-- {
	-- 	key = "S",
	-- 	mods = "LEADER",
	-- 	action = workspace_switcher.switch_to_prev_workspace(),
	-- },
	{
		key = "g",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local current_tab_id = pane:tab():tab_id()
			local cmd = "lazygit ; wezterm cli activate-tab --tab-id " .. current_tab_id .. " ; exit\n"
			local tab, tab_pane, _ = window:mux_window():spawn_tab({})
			tab_pane:send_text(cmd)
			tab:set_title(wezterm.nerdfonts.dev_git .. " Lazygit")
		end),
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 30 },
		}),
	},
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 40 },
		}),
	},
	{
		key = "z",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "o",
		mods = "LEADER",
		action = wezterm.action.ActivateLastTab,
	},
	{
		key = "t",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.PaneSelect({}),
	},
	{
		key = "P",
		mods = "LEADER",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.state_manager.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.state_manager.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.state_manager.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
	{
		key = "b",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					window = pane:window(),
					-- tab = win:active_tab(),
					close_open_tabs = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.state_manager.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.state_manager.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.state_manager.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
	{ key = "L", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },

	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },

	-- Helix-like passive scroll (no mode needed): mirrors C-e/C-y/C-d/C-u in Helix normal mode.
	-- WezTerm intercepts CTRL+SHIFT+letter before the terminal app sees it.
	{ key = "j", mods = "CTRL|SHIFT", action = act.ScrollByLine(1) },
	{ key = "k", mods = "CTRL|SHIFT", action = act.ScrollByLine(-1) },
	{ key = "d", mods = "CTRL|SHIFT", action = act.ScrollByPage(0.5) },
	{ key = "u", mods = "CTRL|SHIFT", action = act.ScrollByPage(-0.5) },
	-- Pane navigation: LEADER+h/j/k/l (mirrors Helix CTRL+w h/j/k/l window nav)
	{ key = "h", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		local ac = wezterm.GLOBAL.ac_panes
		if ac and ac[tostring(pane:pane_id())] then
			local tab = win:active_tab()
			local id = pane:pane_id()
			for _, info in ipairs(tab:panes_with_info()) do
				if info.pane:pane_id() == id and info.height > 1 then
					wezterm.GLOBAL.ac_heights = wezterm.GLOBAL.ac_heights or {}
					wezterm.GLOBAL.ac_heights[tostring(id)] = info.height
					win:perform_action(act.AdjustPaneSize({ "Up", info.height - 1 }), pane)
					break
				end
			end
		end
		win:perform_action(act.ActivatePaneDirection("Left"), pane)
	end) },
	{ key = "j", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		local ac = wezterm.GLOBAL.ac_panes
		if ac and ac[tostring(pane:pane_id())] then
			local tab = win:active_tab()
			local id = pane:pane_id()
			for _, info in ipairs(tab:panes_with_info()) do
				if info.pane:pane_id() == id and info.height > 1 then
					wezterm.GLOBAL.ac_heights = wezterm.GLOBAL.ac_heights or {}
					wezterm.GLOBAL.ac_heights[tostring(id)] = info.height
					win:perform_action(act.AdjustPaneSize({ "Up", info.height - 1 }), pane)
					break
				end
			end
		end
		win:perform_action(act.ActivatePaneDirection("Down"), pane)
	end) },
	{ key = "k", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		local ac = wezterm.GLOBAL.ac_panes
		if ac and ac[tostring(pane:pane_id())] then
			local tab = win:active_tab()
			local id = pane:pane_id()
			for _, info in ipairs(tab:panes_with_info()) do
				if info.pane:pane_id() == id and info.height > 1 then
					wezterm.GLOBAL.ac_heights = wezterm.GLOBAL.ac_heights or {}
					wezterm.GLOBAL.ac_heights[tostring(id)] = info.height
					win:perform_action(act.AdjustPaneSize({ "Up", info.height - 1 }), pane)
					break
				end
			end
		end
		win:perform_action(act.ActivatePaneDirection("Up"), pane)
	end) },
	{ key = "l", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		local ac = wezterm.GLOBAL.ac_panes
		if ac and ac[tostring(pane:pane_id())] then
			local tab = win:active_tab()
			local id = pane:pane_id()
			for _, info in ipairs(tab:panes_with_info()) do
				if info.pane:pane_id() == id and info.height > 1 then
					wezterm.GLOBAL.ac_heights = wezterm.GLOBAL.ac_heights or {}
					wezterm.GLOBAL.ac_heights[tostring(id)] = info.height
					win:perform_action(act.AdjustPaneSize({ "Up", info.height - 1 }), pane)
					break
				end
			end
		end
		win:perform_action(act.ActivatePaneDirection("Right"), pane)
	end) },

	-- Toggle auto-collapse on current pane (shrinks to 1 line on nav away, restores on nav back)
	{ key = "Z", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		wezterm.GLOBAL.ac_panes = wezterm.GLOBAL.ac_panes or {}
		local id = tostring(pane:pane_id())
		if wezterm.GLOBAL.ac_panes[id] then
			wezterm.GLOBAL.ac_panes[id] = nil
			wezterm.log_info("Auto-collapse OFF for pane " .. id)
		else
			wezterm.GLOBAL.ac_panes[id] = true
			wezterm.log_info("Auto-collapse ON for pane " .. id)
		end
	end) },

	-- Pane resize: ALT+h/j/k/l
	{ key = "h", mods = "ALT", action = act.AdjustPaneSize({ "Left", 3 }) },
	{ key = "j", mods = "ALT", action = act.AdjustPaneSize({ "Down", 3 }) },
	{ key = "k", mods = "ALT", action = act.AdjustPaneSize({ "Up", 3 }) },
	{ key = "l", mods = "ALT", action = act.AdjustPaneSize({ "Right", 3 }) },

	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_tab()
		end),
	},
	{
		key = "N",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_window()
		end),
	},
	{
		key = "Enter",
		mods = "LEADER",
		action = act.ToggleFullScreen,
	},
	{
		key = "u",
		mods = "LEADER",
		action = modal.activate_mode("UI"),
	},
	{
		key = "c",
		mods = "LEADER",
		action = modal.activate_mode("copy_mode"),
	},
	{
		key = "y",
		mods = "LEADER",
		action = modal.activate_mode("Scroll"),
	}
}

local function tab_switch_keys(key_table, modifier)
	for i = 1, 9 do
		table.insert(key_table, {
			key = tostring(i),
			mods = modifier,
			action = act.ActivateTab(i - 1),
		})
	end
	table.insert(key_table, {
		key = "0",
		mods = modifier,
		action = act.ActivateTab(9),
	})
end

tab_switch_keys(keys, "ALT")

return keys
