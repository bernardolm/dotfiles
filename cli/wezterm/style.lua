local wezterm = require 'wezterm'

print('loading style')

local font = wezterm.font_with_fallback({
	{ family = "Victor Mono", weight = "Bold" },
	{ family = "Agave",       weight = "Regular" },
	'Monaco',
	{ family = "Symbols Nerd Font Mono", weight = "Regular" }, -- nerd font glyphs
})

return {
	font = font,
	font_size = 16,
	harfbuzz_features = {
		'zero', 'calt=1', 'clig=1', 'liga=1',                                         -- to use with nerd fonts
		'ss01=1', 'ss02=1', 'ss03=1', 'ss04=1', 'ss05=1', 'ss06=1', 'ss07=1', 'ss08=1', -- Victor Mono stylistic sets
	},
	line_height = 1.4,
	-- `colors` is overlaid on top of every color scheme (including the random per-tab ones from theme.lua), so the tab bar stays readable on all of them.
	colors = {
		tab_bar = {
			active_tab = { bg_color = '#4a4a4a', fg_color = '#ffffff' },
			inactive_tab = { bg_color = '#262626', fg_color = '#d8d8d8' },
			inactive_tab_hover = { bg_color = '#3a3a3a', fg_color = '#ffffff' },
			new_tab = { bg_color = '#1c1c1c', fg_color = '#d8d8d8' },
			new_tab_hover = { bg_color = '#3a3a3a', fg_color = '#ffffff' },
		},
	},
	window_frame = {
		font_size = 14,
		active_titlebar_bg = '#1c1c1c',
		inactive_titlebar_bg = '#1c1c1c',
	},
}
