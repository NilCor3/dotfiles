
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
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	-- Collapse/uncollapse current pane (manual toggle). LEADER-a.
	-- Collapse: nav to a neighbor, grow it to eat this pane's space. Focus moves to neighbor.
	-- Restore: when back on the collapsed pane, press LEADER-a again to restore.
	{ key = "a", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		local id = tostring(pane:pane_id())
		local stored_h = wezterm.GLOBAL["ach_" .. id]
		wezterm.log_info("LEADER-a: pane=" .. id .. " stored_h=" .. tostring(stored_h))
		if stored_h and stored_h > 0 then
			-- Restore: grow this pane back in the stored direction
			local restore_dir = wezterm.GLOBAL["acr_" .. id] or "Down"
			local tab = win:active_tab()
			local current_h = nil
			for _, info in ipairs(tab:panes_with_info()) do
				if info.pane:pane_id() == pane:pane_id() then current_h = info.height; break end
			end
			wezterm.log_info("restore: dir=" .. restore_dir .. " current_h=" .. tostring(current_h) .. " target=" .. stored_h)
			if current_h then
				local delta = stored_h - current_h
				if delta > 0 then
					win:perform_action(act.AdjustPaneSize({ restore_dir, delta }), pane)
				end
			end
			wezterm.GLOBAL["ach_" .. id] = 0
			wezterm.GLOBAL["acr_" .. id] = ""
		else
			-- Collapse: find a neighbor (vertical preferred, then horizontal),
			-- nav to it, grow it into this pane. Leave focus on neighbor.
			local tab = win:active_tab()
			local src = nil
			for _, info in ipairs(tab:panes_with_info()) do
				if info.pane:pane_id() == pane:pane_id() then src = info; break end
			end
			if not src then return end
			-- opposite[grow_dir] = restore_dir for this pane
			local opposite = { Up="Down", Down="Up", Left="Right", Right="Left" }
			-- Candidates in priority order: vertical first, then horizontal
			local candidates = {
				{ nav="Down", grow="Up",   size=src.height },
				{ nav="Up",   grow="Down", size=src.height },
				{ nav="Right",grow="Left", size=src.width  },
				{ nav="Left", grow="Right",size=src.width  },
			}
			for _, c in ipairs(candidates) do
				if c.size <= 1 then goto continue end
				local found = false
				for _, info in ipairs(tab:panes_with_info()) do
					if info.pane:pane_id() ~= pane:pane_id() then
						if c.nav == "Down"  and info.top  >= src.top  + src.height - 1 then found = true end
						if c.nav == "Up"    and info.top  <= src.top                   then found = true end
						if c.nav == "Right" and info.left >= src.left + src.width  - 1 then found = true end
						if c.nav == "Left"  and info.left <= src.left                  then found = true end
					end
					if found then break end
				end
				if found then
					wezterm.GLOBAL["ach_" .. id] = c.size
					wezterm.GLOBAL["acr_" .. id] = opposite[c.grow]  -- direction to grow back on restore
					wezterm.log_info("collapse: pane=" .. id .. " nav=" .. c.nav .. " grow=" .. c.grow .. " size=" .. c.size .. " restore=" .. opposite[c.grow])
					win:perform_action(act.Multiple({
						act.ActivatePaneDirection(c.nav),
						act.AdjustPaneSize({ c.grow, c.size - 1 }),
					}), pane)
					return
				end
				::continue::
			end
			wezterm.log_info("collapse: pane=" .. id .. " no neighbor found")
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
