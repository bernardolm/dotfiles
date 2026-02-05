local wezterm = require 'wezterm'

if not wezterm.target_triple:find("windows") then return {} end

print('loading windows')

return {
	-- default_prog = { 'wsl', '/bin/zsh', '--login' },
	window_background_opacity = 0.85,
	window_decorations = "TITLE | RESIZE",
}
