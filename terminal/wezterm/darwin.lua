local wezterm = require 'wezterm'

if not wezterm.target_triple:find("darwin") then return {} end

print('loading darwin')

return {
	-- default_prog = { '/usr/bin/env', '/bin/zsh', '--login' },
	macos_window_background_blur = 20,
	unix_domains = {{ name = 'unix' }},
	window_background_opacity = 0.82,
	window_decorations = "RESIZE | INTEGRATED_BUTTONS | MACOS_FORCE_ENABLE_SHADOW",
}
