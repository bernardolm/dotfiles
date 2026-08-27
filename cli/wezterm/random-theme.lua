local wezterm = require 'wezterm'

local M = {}

-- Every color scheme WezTerm ships with.
local scheme_names = {}
for name, scheme in pairs(wezterm.color.get_builtin_schemes()) do
	table.insert(scheme_names, name)
end

-- Schemes that never come up on random pick. Add names as you find ones
-- you don't like.
local blocklist = {
	-- ["Some Ugly Scheme"] = true,
	["Grayscale Light (base16)"] = true
}

local function pick_random_scheme()
	local scheme
	repeat
		scheme = scheme_names[math.random(#scheme_names)]
	until not blocklist[scheme]
	return scheme
end

-- color_scheme overrides are window-wide, not per-tab, so switching tabs
-- inside the same window doesn't naturally give each tab its own theme.
-- Simulated instead: remember which scheme each tab_id got (assigned once,
-- the first time we see it), and reapply that tab's scheme every time it
-- becomes the active one.
local tab_schemes = {}
local last_active_tab_id = nil

local function scheme_for_tab(tab_id)
	local scheme = tab_schemes[tab_id]
	if not scheme then
		scheme = pick_random_scheme()
		tab_schemes[tab_id] = scheme
	end
	return scheme
end

function M.current_scheme_name(window)
	local tab = window:active_tab()
	if not tab then
		return nil
	end
	return tab_schemes[tab:tab_id()]
end

-- The right-status text isn't selectable, so this copies the current tab's
-- scheme name to the clipboard instead — bind it to a key (see keys.lua) to
-- grab a name for the blocklist above.
function M.copy_current_scheme_name(window)
	local scheme = M.current_scheme_name(window)
	if scheme then
		window:copy_to_clipboard(scheme)
		window:toast_notification('theme', scheme .. ' copied to clipboard', nil, 2000)
	end
end

-- 'update-status' fires continuously (roughly every redraw), which is what
-- makes it reliable for noticing a tab switch — there's no dedicated
-- "tab activated" event in the Lua API.
wezterm.on('update-status', function(window, pane)
	local tab = window:active_tab()
	if not tab then
		return
	end
	local tab_id = tab:tab_id()
	if tab_id == last_active_tab_id then
		return
	end
	last_active_tab_id = tab_id

	local scheme = scheme_for_tab(tab_id)
	window:set_config_overrides { color_scheme = scheme }
end)

return M
