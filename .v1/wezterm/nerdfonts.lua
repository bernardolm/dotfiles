local wezterm = require 'wezterm'

wezterm.on('update-right-status', function(window, pane)
	-- "Wed Mar 3 08:14"
	local date = wezterm.strftime '%a %b %-d %H:%M '

	window:set_right_status(wezterm.format {
	{ Text = wezterm.nerdfonts.fa_clock_o .. ' ' .. date },
	})
end)
