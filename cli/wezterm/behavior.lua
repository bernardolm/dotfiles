local wezterm = require 'wezterm'
-- local mux = wezterm.mux

print('loading behavior')

-- local default_prog = { '/bin/zsh', '--login', '--sourcetrace' }

local visual_bell = {
	fade_in_duration_ms = 150,
	fade_in_function = 'EaseIn',
	fade_out_duration_ms = 150,
	fade_out_function = 'EaseOut',
}

return {
	-- adjust_window_size_when_changing_font_size = true,
	-- bypass_mouse_reporting_modifiers = '',
	-- check_for_updates = true,
	-- check_for_updates_interval_seconds = 86400,
	-- default_cwd = HomePath,
	-- enable_kitty_graphics = false,
	-- enable_kitty_keyboard = false,
	-- enable_scroll_bar = true,
	-- enable_tab_bar = true,
	-- enable_title_reporting = true,
	-- enable_wayland = false,
	-- exit_behavior = "Close",
	-- hide_tab_bar_if_only_one_tab = false,
	-- pane_focus_follows_mouse = true,
	-- show_update_window = false,
	-- ssh_domains = wezterm.default_ssh_domains(),
	-- tab_and_split_indices_are_zero_based = true,
	-- unzoom_on_switch_pane = false,
	-- use_resize_increments = true,
	-- visual_bell = visual_bell,
	automatically_reload_config = true,
	experimental_pixel_positioning = false, -- NOTE: this config break everthing!
	prefer_to_spawn_tabs = true,
	scrollback_lines = 100000,
	show_new_tab_button_in_tab_bar = true,
	show_tabs_in_tab_bar = true,
	skip_close_confirmation_for_processes_named = { 'bash', 'sh', 'zsh', 'fish', 'tmux' },
	tab_bar_at_bottom = false,
	use_fancy_tab_bar = true,
	window_close_confirmation = 'NeverPrompt',
}
