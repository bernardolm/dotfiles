-- local wezterm = require 'wezterm'

-- local config = wezterm.config_builder()

-- -- config.window_background_gradient = {
-- -- 	-- preset = "BuPu",
-- -- 	-- preset = "CubeHelixDefault",
-- -- 	preset = "Magma",
-- -- 	-- preset = "Plasma",
-- -- 	-- preset = "PuRd",
-- -- 	-- preset = "RdBu",
-- -- 	-- preset = "RdPu",
-- -- 	-- preset = "Spectral",
-- -- 	-- preset = "Turbo",
-- -- 	-- preset = "Viridis",
-- -- 	-- preset = "Warm",
-- -- 	orientation = { Linear = { angle = -45.0 } },
-- -- }

-- -- config.window_frame = {
-- --   -- IoskeleyMono Nerd Font Light for me again, though an idea could be to try a
-- --   -- serif font here instead of monospace for a nicer look?
-- --   font = wezterm.font({ family = 'IoskeleyMono Nerd Font Light', weight = 'Bold' }),
-- --   font_size = 11,
-- -- }




-- -- Use it!
-- -- local appearance = require 'appearance'
-- -- if appearance.is_dark() then
-- --   config.color_scheme = 'Tokyo Night'
-- -- else
-- --   config.color_scheme = 'Tokyo Night Day'
-- -- end

-- -- config.color_scheme = 'Aci (Gogh)'
-- -- config.color_scheme = 'AdventureTime'
-- -- config.color_scheme = 'Andromeda'
-- -- config.color_scheme = 'Argonaut'
-- -- config.color_scheme = 'Catppuccin Frappe'
-- -- config.color_scheme = 'Catppuccin Latte'
-- -- config.color_scheme = 'Catppuccin Macchiato'
-- -- config.color_scheme = 'Catppuccin Mocha'
-- -- On macOS, 'RESIZE|INTEGRATED_BUTTONS' also looks nice if
-- -- Removes the title bar, leaving only the tab bar. Keeps
-- -- Sets the font for the window frame (tab bar)
-- -- Slightly transparent and blurred background
-- -- the ability to resize by dragging the window's edges.
-- -- them into the tab bar.
-- -- you want to keep the window controls visible and integrate
-- config.color_scheme = 'Tokyo Night'
-- config.enable_tab_bar = true
-- config.font_size = 15
-- config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
-- config.hide_tab_bar_if_only_one_tab = false
-- config.macos_window_background_blur = 30
-- config.ssh_domains = wezterm.default_ssh_domains()
-- config.text_background_opacity = 0.3
-- config.use_fancy_tab_bar = true
-- config.window_background_opacity = 0.9
-- config.window_decorations = 'RESIZE'

-- -- return config

-- return {
--   font = wezterm.font_with_fallback({
-- 		'Apple Color Emoji',
-- 		'monospace',
-- 		'Noto Color Emoji',
-- 		'Segoe UI Emoji',
-- 		"Apple Color Emoji",
-- 		"Fira Code",
-- 		"JetBrains Mono",
-- 		"Noto Color Emoji",
--   }),
--   harfbuzz_features = { 'calt=1', 'liga=1', 'clig=1' },
--   use_fancy_tab_bar = true,
--   tab_bar_at_bottom = false,
--   hide_tab_bar_if_only_one_tab = false,
--   enable_tab_bar = true,
--   ssh_domains = {
--     -- Example:
--     -- { name = 'server', remote_address = 'user@host' },
--   },
-- }
