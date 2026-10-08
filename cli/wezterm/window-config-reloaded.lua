local wezterm = require 'wezterm'

-- Maximize each GUI window once, the first time its config loads. The event
-- re-fires on every set_config_overrides call (theme.lua does that on tab
-- change), so the guard keeps a manually resized window from snapping back.
wezterm.on('window-config-reloaded', function(window, pane)
	local key = 'maximized_' .. window:window_id()
	if wezterm.GLOBAL[key] then
		return
	end
	wezterm.GLOBAL[key] = true

	-- The window isn't fully materialized yet at this point in the event (an
	-- immediate maximize() call silently no-ops, e.g. in gui-attached, or on
	-- a window reattaching to a mux window that outlived a previous GUI
	-- process). Give it a moment.
	wezterm.time.call_after(0.5, function()
		window:maximize()
	end)
end)
