local wezterm = require 'wezterm'
-- local mux = wezterm.mux

print('loading keys')

return {
	keys = {
		-- Turn off the default CMD-m Hide action, allowing CMD-m to
		-- be potentially recognized and handled by the tab
		{
			key = '`',
			mods = 'CMD',
			action = wezterm.action.Hide,
		},
	}
}