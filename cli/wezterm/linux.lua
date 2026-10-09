local wezterm = require 'wezterm'

if not wezterm.target_triple:find("linux") then return {} end

print('loading linux')

return {
	window_frame = { font = wezterm.font('sans-serif') }, -- tab bar uses the system UI font (fontconfig default)
}
