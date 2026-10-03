local wezterm = require 'wezterm'

print('loading style')

local font = wezterm.font_with_fallback({
	{ family = "Agave Nerd Font Propo", weight = "Regular" },
	{ family = "Victor Mono",           weight = "DemiBold" },
	'Monaco',
})

return {
	font = font,
	font_size = 16,
	harfbuzz_features = {
		'zero', 'calt=1', 'clig=1', 'liga=1',                                         -- to use with nerd fonts
		'ss01=1', 'ss02=1', 'ss03=1', 'ss04=1', 'ss05=1', 'ss06=1', 'ss07=1', 'ss08=1', -- Victor Mono stylistic sets
	},
	line_height = 1.4,
}
