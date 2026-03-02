-- pane_collapse.lua
-- Auto-collapse: mark a pane so it shrinks to 1 line when you navigate away,
-- and restores its original height when you navigate back.
--
-- State lives in wezterm.GLOBAL so it survives config reloads:
--   ac_panes   = { [pane_id] = true }            -- panes with auto-collapse enabled
--   ac_heights = { [pane_id] = original_height } -- stored heights (cells)

local wezterm = require("wezterm")
local act = wezterm.action

-- Ensure GLOBAL tables exist after a config reload.
if not wezterm.GLOBAL.ac_panes then
	wezterm.GLOBAL.ac_panes = {}
end
if not wezterm.GLOBAL.ac_heights then
	wezterm.GLOBAL.ac_heights = {}
end

local M = {}

--- Return the cell height of a pane from panes_with_info, or nil if not found.
local function pane_cell_height(tab, pane_id)
	for _, info in ipairs(tab:panes_with_info()) do
		if info.pane:pane_id() == pane_id then
			return info.height
		end
	end
end

--- Collapse a pane: store its height, shrink to 1 line.
local function collapse(win, tab, pane_id)
	local h = pane_cell_height(tab, pane_id)
	if not h or h <= 1 then return end
	wezterm.GLOBAL.ac_heights[tostring(pane_id)] = h
	-- Shrink by (h - 1) lines. WezTerm clamps at minimum (1 line).
	for _, info in ipairs(tab:panes_with_info()) do
		if info.pane:pane_id() == pane_id then
			win:perform_action(act.AdjustPaneSize({ "Up", h - 1 }), info.pane)
			return
		end
	end
end

--- Restore a pane to its stored height.
local function restore(win, tab, pane_id)
	local stored = wezterm.GLOBAL.ac_heights[tostring(pane_id)]
	if not stored then return end
	local current = pane_cell_height(tab, pane_id)
	if not current then return end
	local delta = stored - current
	if delta <= 0 then return end
	for _, info in ipairs(tab:panes_with_info()) do
		if info.pane:pane_id() == pane_id then
			win:perform_action(act.AdjustPaneSize({ "Down", delta }), info.pane)
			wezterm.GLOBAL.ac_heights[tostring(pane_id)] = nil
			return
		end
	end
end

--- Build a nav callback for one direction that handles auto-collapse around the move.
function M.nav(direction)
	return wezterm.action_callback(function(win, pane)
		local tab = pane:tab()
		local old_id = pane:pane_id()

		-- Collapse the pane we are leaving if it has auto-collapse on.
		if wezterm.GLOBAL.ac_panes[old_id] then
			collapse(win, tab, old_id)
		end

		-- Move to the next pane.
		win:perform_action(act.ActivatePaneDirection(direction), pane)

		-- Restore the pane we just moved into if it has auto-collapse on.
		local new_id = win:active_tab():active_pane():pane_id()
		if wezterm.GLOBAL.ac_panes[new_id] then
			restore(win, tab, new_id)
		end
	end)
end

--- Toggle auto-collapse on the current pane, show a toast.
function M.toggle()
	return wezterm.action_callback(function(win, pane)
		local id = pane:pane_id()
		if wezterm.GLOBAL.ac_panes[id] then
			wezterm.GLOBAL.ac_panes[id] = nil
			wezterm.GLOBAL.ac_heights[tostring(id)] = nil
			-- Restore if currently collapsed (height stored).
			restore(win, pane:tab(), id)
			win:toast_notification("WezTerm", "Auto-collapse OFF", nil, 2000)
		else
			wezterm.GLOBAL.ac_panes[id] = true
			win:toast_notification("WezTerm", "Auto-collapse ON", nil, 2000)
		end
	end)
end

return M
