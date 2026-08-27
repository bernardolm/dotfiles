local wezterm = require 'wezterm'

if not wezterm.target_triple:find("darwin") then return {} end

print('loading darwin')

return {
	-- default_prog = { '/usr/bin/env', '/bin/zsh', '--login' },
	-- window_decorations = "RESIZE | INTEGRATED_BUTTONS | MACOS_FORCE_ENABLE_SHADOW",
	macos_window_background_blur = 10,
	set_environment_variables = {
		PATH = '/opt/homebrew/bin:' .. os.getenv('PATH'),
		-- Panes spawn under wezterm-mux-server, whose own inherited
		-- environment isn't reliable (depends on how/when it first got
		-- spawned). Pin this explicitly so every pane's ssh always finds
		-- 1Password's agent regardless.
		SSH_AUTH_SOCK = os.getenv('HOME') .. '/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock',
	},
	window_background_opacity = 0.95,
	window_decorations = "RESIZE | TITLE | MACOS_FORCE_ENABLE_SHADOW",
}
