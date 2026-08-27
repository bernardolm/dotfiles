local wezterm = require 'wezterm'

if not wezterm.target_triple:find("darwin") then return {} end

print('loading darwin')

local config = wezterm.config_builder()
config.set_environment_variables = {
	PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
}

return {
	-- default_prog = { '/usr/bin/env', '/bin/zsh', '--login' },
	-- window_decorations = "RESIZE | INTEGRATED_BUTTONS | MACOS_FORCE_ENABLE_SHADOW",
	macos_window_background_blur = 10,
	window_background_opacity = 0.95,
	window_decorations = "RESIZE | TITLE | MACOS_FORCE_ENABLE_SHADOW",
}
