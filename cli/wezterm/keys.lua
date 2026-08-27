-- local mux = wezterm.mux
local wezterm = require 'wezterm'

local projects = require 'projects'

-- print('loading keys')

return {
	leader = {
		key = 'a',
		mods = 'CTRL',
		timeout_milliseconds = 1000,
	},
	keys = {
		-- Turn off the default CMD-m Hide action, allowing CMD-m to
		-- be potentially recognized and handled by the tab
		{
			key = '`',
			mods = 'CMD',
			action = wezterm.action.Hide,
		},
		-- ... add these new entries to your config.keys table
		{
			key = 'p',
			mods = 'LEADER',
			-- Present in to our project picker
			action = wezterm.action_callback(function(window, pane)
				window:perform_action(projects.choose_project(), pane)
			end),
		},
		{
			key = 'f',
			mods = 'LEADER',
			-- Present a list of existing workspaces
			action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
		}
	}
}
