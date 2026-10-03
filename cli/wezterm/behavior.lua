local wezterm = require 'wezterm'

print('loading behavior')

return {
	skip_close_confirmation_for_processes_named = {
		'bash', 'sh', 'zsh', 'fish', 'tmux', 'nu', 'cmd.exe', 'pwsh.exe', 'powershell.exe',
	},
	automatically_reload_config = false,
	default_cwd = HomePath,
	default_domain = 'unix',
	enable_scroll_bar = true,
	experimental_pixel_positioning = false, -- NOTE: this config break everthing!
	hide_tab_bar_if_only_one_tab = false,
	prefer_to_spawn_tabs = true,
	scrollback_lines = 999999999,
	show_new_tab_button_in_tab_bar = true,
	show_tabs_in_tab_bar = true,
	ssh_domains = wezterm.default_ssh_domains(),
	tab_bar_at_bottom = false,
	tab_max_width = 999,
	unix_domains = { { name = 'unix' } },
	unzoom_on_switch_pane = false,
	use_fancy_tab_bar = true,
	use_resize_increments = true,
	window_close_confirmation = 'NeverPrompt',
}
