local wezterm = require 'wezterm'

if not wezterm.target_triple:find("linux") then return {} end

print('loading linux')

return {
	-- default_prog = { '/bin/zsh', '--login' },
}
