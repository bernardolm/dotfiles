local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	local gui_window = window:gui_window()
	gui_window:maximize()
	-- window:spawn_tab({args = {'htop'}})
	window:spawn_tab({ cwd = HomePath .. "/dotfiles" })
	-- window:spawn_tab({cwd = HomePath})
	-- window:spawn_tab({})
end)
