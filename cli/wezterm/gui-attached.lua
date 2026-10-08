local wezterm = require 'wezterm'
local mux = wezterm.mux

-- Fires once, when the GUI starts and attaches to the default domain (the
-- unix mux), so windows/tabs created later keep whatever size they have.
wezterm.on('gui-attached', function(domain)
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)
