local wezterm = require 'wezterm'

if not wezterm.target_triple:find("darwin") then return {} end

print('loading darwin')

return {
	-- SF (system UI font) is hidden from CoreText enumeration; load it from its directory
	font_dirs = { '/System/Library/Fonts' },
	macos_window_background_blur = 10,
	native_macos_fullscreen_mode = true,
	set_environment_variables = {
		PATH = '/opt/homebrew/bin:' .. os.getenv('PATH'),
		SSH_AUTH_SOCK = os.getenv('HOME') .. '/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock',
	},
	window_background_opacity = 0.95,
	window_decorations = "RESIZE | INTEGRATED_BUTTONS | MACOS_FORCE_ENABLE_SHADOW",
	window_frame = { font = wezterm.font('.SF NS') }, -- tab bar uses the system UI font
}
