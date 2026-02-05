local wezterm = require 'wezterm'

print('loading style')

local font = wezterm.font_with_fallback({
	"Agave Nerd Font Mono",
	-- "IoskeleyMono Nerd Font Light",
	-- 'Apple Color Emoji',
	-- 'monospace',
	-- 'Noto Color Emoji',
	-- 'Segoe UI Emoji',
	-- "Apple Color Emoji",
	-- "Fira Code",
	-- "JetBrains Mono",
	-- "Noto Color Emoji",
})

-- local window_background_gradient = {
-- 	-- preset = "Blues",
-- 	-- preset = "BrBg",
-- 	-- preset = "BuGn",
-- 	-- preset = "BuPu",
-- 	-- preset = "Cividis",
-- 	-- preset = "Cool",
-- 	-- preset = "CubeHelixDefault",
-- 	-- preset = "GnBu",
-- 	-- preset = "Greens",
-- 	-- preset = "Greys",
-- 	-- preset = "Inferno",
-- 	-- preset = "Magma",
-- 	-- preset = "Oranges",
-- 	-- preset = "OrRd",
-- 	-- preset = "PiYg",
-- 	-- preset = "Plasma",
-- 	-- preset = "PrGn",
-- 	-- preset = "PuBu",
-- 	-- preset = "PuBuGn",
-- 	-- preset = "PuOr",
-- 	-- preset = "PuRd",
-- 	-- preset = "Purples",
-- 	-- preset = "Rainbow",
-- 	-- preset = "RdBu",
-- 	-- preset = "RdGy",
-- 	-- preset = "RdPu",
-- 	-- preset = "RdYlBu",
-- 	-- preset = "RdYlGn",
-- 	-- preset = "Reds",
-- 	-- preset = "Sinebow",
-- 	-- preset = "Spectral",
-- 	-- preset = "Turbo",
-- 	-- preset = "Viridis",
-- 	-- preset = "Warm",
-- 	-- preset = "YlGn",
-- 	-- preset = "YlGnBu",
-- 	-- preset = "YlOrBr",
-- 	-- preset = "YlOrRd",

-- 	colors = {
--     '#0f0c29',
--     '#302b63',
--     '#24243e',
--   },

-- 	-- orientation = {
-- 	-- 	Linear = {
-- 	-- 		angle = -45.0
-- 	-- 	}
-- 	-- },

-- 	orientation = {
--     Radial = {
--       cx = 0.75,
--       cy = 0.75,
--       radius = 1.25,
--     },
--   },
-- }

-- local colors = {
-- 	-- 	background = '#e06b6b'
-- 	-- 	foreground = "#b93baf",
-- 	visual_bell = '#202020',
-- }

local inactive_pane_hsb = { brightness = 0.5, saturation = 0.24 }
local window_padding = { bottom = 10, left = 10, right = 10, top = 10 }

return {
	-- colors = colors,
	-- harfbuzz_features = {"calt=0", "clig=0", "liga=0"},
	-- harfbuzz_features = {"calt=1", "clig=1", "liga=1"},
	-- text_background_opacity = 0.3, -- NOTE: this config break prompt
	-- window_background_gradient = window_background_gradient,
	color_scheme = 'Tokyo Night',
	font = font,
	font_size = 20,
	harfbuzz_features = { 'zero' }, -- to use with nerd fonts
	inactive_pane_hsb = inactive_pane_hsb,
	window_padding = window_padding,
}
