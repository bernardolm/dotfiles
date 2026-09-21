-- local mux = wezterm.mux
local wezterm = require 'wezterm'

local projects = require 'projects'
local random_theme = require 'theme'

-- print('loading keys')

return {
	leader = {
		key = 'a',
		mods = 'CTRL',
		timeout_milliseconds = 2000,
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
		},
		{
			key = 't',
			mods = 'LEADER',
			-- Enter theme mode: 't' again copies the current theme name,
			-- 'r' removes it from the random rotation (theme "remove").
			action = wezterm.action.ActivateKeyTable {
				name = 'theme_mode',
				one_shot = true,
				timeout_milliseconds = 2000,
			},
		}
	},
	key_tables = {
		theme_mode = {
			{
				key = 't',
				action = wezterm.action_callback(function(window, pane)
					random_theme.copy_current_scheme_name(window)
				end),
			},
			{
				key = 'r',
				action = wezterm.action_callback(function(window, pane)
					random_theme.remove_current_scheme(window)
				end),
			},
		},
	},
}
