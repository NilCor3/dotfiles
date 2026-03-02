
local wezterm = require("wezterm")
local act = wezterm.action
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")

-- Find the pane adjacent to from_id in the given direction.
-- Returns a PaneInformation table or nil.
local function find_neighbor(tab, from_id, direction)
	local panes = tab:panes_with_info()
	local src = nil
	for _, info in ipairs(panes) do
		if info.pane:pane_id() == from_id then src = info; break end
	end
	if not src then return nil end
	local best = nil
	for _, info in ipairs(panes) do
		if info.pane:pane_id() ~= from_id then
			local ok = false
			if direction == "Down" then
				ok = info.top > src.top + src.height - 1
					and info.left < src.left + src.width
					and info.left + info.width > src.left
				if ok and (not best or info.top < best.top) then best = info end
			elseif direction == "Up" then
				ok = info.top + info.height - 1 < src.top
					and info.left < src.left + src.width
					and info.left + info.width > src.left
				if ok and (not best or info.top + info.height > best.top + best.height) then best = info end
			elseif direction == "Right" then
				ok = info.left > src.left + src.width - 1
					and info.top < src.top + src.height
					and info.top + info.height > src.top
				if ok and (not best or info.left < best.left) then best = info end
			elseif direction == "Left" then
				ok = info.left + info.width - 1 < src.left
					and info.top < src.top + src.height
					and info.top + info.height > src.top
				if ok and (not best or info.left + info.width > best.left + best.width) then best = info end
			end
		end
	end
	return best
end

-- Collapse pane from_id by growing its neighbor toward it.
-- Saves height + restore direction into ac_heights for later restore.
-- nav_dir: the direction the user is navigating ("Down", "Up", "Left", "Right")
local function collapse_pane(win, tab, from_id, nav_dir)
	local panes = tab:panes_with_info()
	local src = nil
	for _, info in ipairs(panes) do
		if info.pane:pane_id() == from_id then src = info; break end
	end
	wezterm.log_info("collapse_pane: from=" .. tostring(from_id) .. " dir=" .. nav_dir
		.. " src_found=" .. tostring(src ~= nil)
		.. (src and (" h=" .. src.height) or ""))
	if not src or src.height <= 1 then return end

	-- Save height and direction needed to restore (opposite of how we collapse)
	wezterm.GLOBAL.ac_heights = wezterm.GLOBAL.ac_heights or {}
	wezterm.GLOBAL.ac_heights[tostring(from_id)] = src.height
	wezterm.GLOBAL.ac_restore_dirs = wezterm.GLOBAL.ac_restore_dirs or {}
	wezterm.GLOBAL.ac_restore_dirs[tostring(from_id)] = nav_dir

	-- Grow the neighbor in the opposite direction to eat the collapsing pane's space
	local grow_dirs = { Down = "Up", Up = "Down", Right = "Left", Left = "Right" }
	local neighbor = find_neighbor(tab, from_id, nav_dir)
	wezterm.log_info("collapse_pane: neighbor_found=" .. tostring(neighbor ~= nil)
		.. " grow_dir=" .. (grow_dirs[nav_dir] or "?")
		.. " amount=" .. tostring(src.height - 1))
	if neighbor then
		win:perform_action(act.AdjustPaneSize({ grow_dirs[nav_dir], src.height - 1 }), neighbor.pane)
	end
end

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
		local id = pane:pane_id()
		if ac and ac[tostring(id)] then
			collapse_pane(win, win:active_tab(), id, "Left")
		end
		win:perform_action(act.ActivatePaneDirection("Left"), pane)
	end) },
	{ key = "j", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		local ac = wezterm.GLOBAL.ac_panes
		local id = pane:pane_id()
		if ac and ac[tostring(id)] then
			collapse_pane(win, win:active_tab(), id, "Down")
		end
		win:perform_action(act.ActivatePaneDirection("Down"), pane)
	end) },
	{ key = "k", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		local ac = wezterm.GLOBAL.ac_panes
		local id = pane:pane_id()
		if ac and ac[tostring(id)] then
			collapse_pane(win, win:active_tab(), id, "Up")
		end
		win:perform_action(act.ActivatePaneDirection("Up"), pane)
	end) },
	{ key = "l", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		local ac = wezterm.GLOBAL.ac_panes
		local id = pane:pane_id()
		if ac and ac[tostring(id)] then
			collapse_pane(win, win:active_tab(), id, "Right")
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
