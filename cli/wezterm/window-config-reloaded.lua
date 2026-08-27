local wezterm = require 'wezterm'

-- When the config for a window is reloaded (i.e. when you save this file
-- or open a new window)...
-- wezterm.on('window-config-reloaded', function(window, pane)
-- The window/pane aren't fully materialized yet at this point in the
-- event (an immediate maximize() call silently no-ops on a window
-- that's reattaching to a mux window that outlived a previous GUI
-- process). Give it a moment.
-- wezterm.time.call_after(0.5, function()
-- window:maximize() # NOTE: temporarily disabled by the user
-- end)
-- end)
