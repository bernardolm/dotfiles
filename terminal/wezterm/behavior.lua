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
	-- check_for_updates = true,
	-- check_for_updates_interval_seconds = 86400,
	-- enable_kitty_graphics = false,
	-- enable_kitty_keyboard = false,
	-- enable_scroll_bar = true,
	-- enable_tab_bar = true,
	-- enable_title_reporting = true,
	-- enable_wayland = false,
	-- hide_tab_bar_if_only_one_tab = false,
	-- pane_focus_follows_mouse = true,
	-- show_update_window = false,
	-- tab_and_split_indices_are_zero_based = true,
	-- tab_bar_at_bottom = false,
	-- unzoom_on_switch_pane = false,
	-- use_fancy_tab_bar = true,
	-- use_resize_increments = true,
	-- visual_bell = visual_bell,
	adjust_window_size_when_changing_font_size = true,
	automatically_reload_config = true,
	bypass_mouse_reporting_modifiers = '',
	-- default_cwd = HomePath,
	exit_behavior = "Close",
	experimental_pixel_positioning = false, -- NOTE: this config break everthing!
	prefer_to_spawn_tabs = true,
	skip_close_confirmation_for_processes_named = { 'bash', 'sh', 'zsh', 'fish', 'tmux' },
	ssh_domains = wezterm.default_ssh_domains(),
	window_close_confirmation = 'NeverPrompt',
}
