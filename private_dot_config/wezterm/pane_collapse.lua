-- pane_collapse.lua
-- Auto-collapse: mark a pane so it shrinks to 1 line when you navigate away,
-- and restores its original height when you navigate back.
--
-- State lives in wezterm.GLOBAL so it survives config reloads:
--   ac_panes   = { [pane_id] = true }            -- panes with auto-collapse enabled
--   ac_heights = { [pane_id] = original_height } -- stored heights (cells)
--
-- Restoration is handled by the "update-status" event in wezterm.lua, which
-- fires every second for the active pane (avoids async issues with perform_action).

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

--- Ensure GLOBAL tables exist (call from wezterm.lua on startup).
function M.init()
	if not wezterm.GLOBAL.ac_panes then
		wezterm.GLOBAL.ac_panes = {}
	end
	if not wezterm.GLOBAL.ac_heights then
		wezterm.GLOBAL.ac_heights = {}
	end
end

--- Return the cell height of a pane from panes_with_info, or nil if not found.
local function pane_cell_height(tab, pane_id)
	for _, info in ipairs(tab:panes_with_info()) do
		if info.pane:pane_id() == pane_id then
			return info.height
		end
	end
end

--- Collapse a pane: store its height, shrink to 1 line.
local function collapse(win, pane_id)
	local tab = win:active_tab()
	local h = pane_cell_height(tab, pane_id)
	if not h or h <= 1 then return end
	wezterm.GLOBAL.ac_heights[tostring(pane_id)] = h
	for _, info in ipairs(tab:panes_with_info()) do
		if info.pane:pane_id() == pane_id then
			win:perform_action(act.AdjustPaneSize({ "Up", h - 1 }), info.pane)
			return
		end
	end
end

--- Restore a pane to its stored height (called from update-status on the active pane).
function M.restore_if_needed(win, pane)
	local id = pane:pane_id()
	local key = tostring(id)
	if not wezterm.GLOBAL.ac_heights then return end
	local stored = wezterm.GLOBAL.ac_heights[key]
	if not stored then return end
	local tab = win:active_tab()
	local current = pane_cell_height(tab, id)
	if not current then return end
	local delta = stored - current
	if delta > 0 then
		win:perform_action(act.AdjustPaneSize({ "Down", delta }), pane)
	end
	wezterm.GLOBAL.ac_heights[key] = nil
end

--- Build a nav action for one direction; collapses the current pane if marked.
-- Restoration of the target pane happens via update-status (async-safe).
function M.nav(direction)
	return wezterm.action_callback(function(win, pane)
		-- Wrap collapse logic in pcall so a failure never blocks navigation.
		local ok, err = pcall(function()
			local old_id = pane:pane_id()
			local ac = wezterm.GLOBAL.ac_panes
			if ac and ac[old_id] then
				collapse(win, old_id)
			end
		end)
		if not ok then
			wezterm.log_error("pane_collapse nav: " .. tostring(err))
		end
		-- Navigation always runs, even if collapse logic errored.
		win:perform_action(act.ActivatePaneDirection(direction), pane)
	end)
end

--- Toggle auto-collapse on the current pane, show a toast.
function M.toggle()
	return wezterm.action_callback(function(win, pane)
		local ok, err = pcall(function()
			M.init()
			local id = pane:pane_id()
			if wezterm.GLOBAL.ac_panes[id] then
				wezterm.GLOBAL.ac_panes[id] = nil
				-- If it's currently collapsed, restore it now.
				local key = tostring(id)
				local stored = wezterm.GLOBAL.ac_heights[key]
				if stored then
					local tab = win:active_tab()
					local current = pane_cell_height(tab, id)
					if current then
						local delta = stored - current
						if delta > 0 then
							win:perform_action(act.AdjustPaneSize({ "Down", delta }), pane)
						end
					end
					wezterm.GLOBAL.ac_heights[key] = nil
				end
				win:toast_notification("WezTerm", "Auto-collapse OFF", nil, 2000)
			else
				wezterm.GLOBAL.ac_panes[id] = true
				win:toast_notification("WezTerm", "Auto-collapse ON", nil, 2000)
			end
		end)
		if not ok then
			wezterm.log_error("pane_collapse toggle: " .. tostring(err))
		end
	end)
end

return M
