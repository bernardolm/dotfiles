local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()
local gui = wezterm.gui

local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"

local colors = {
	visual_bell = '#202020',
}
-- local default_prog = { '/bin/zsh', '--login', '--sourcetrace' }
-- Windows: x86_64-pc-windows-msvc
-- macOS (Intel): x86_64-apple-darwin
-- macOS (Apple Silicon): aarch64-apple-darwin
-- Linux: x86_64-unknown-linux-gnu (or similar)
-- local default_prog = { '/bin/zsh', '--login', '--xtrace' }
local default_prog = { '/bin/zsh', '--login' }
-- local default_prog = { '/bin/zsh', '--login', '--sourcetrace', '|', 'grep', '-vE', '"(<sourcetrace>)"' }
if is_windows then
	table.insert(default_prog, 1, 'wsl')
end
local inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5
}
local unix_domains = { { name = 'unix' } }
local visual_bell = {
	fade_in_duration_ms = 150,
	fade_in_function = 'EaseIn',
	fade_out_duration_ms = 150,
	fade_out_function = 'EaseOut',
}
local window_padding = { bottom = 10, left = 10, right = 10, top = 10 }

-- config.initial_cols = 90
-- config.initial_rows = 48
-- config.mux_enable_ssh_agent = true
-- config.window_decorations = "TITLE | RESIZE | MACOS_FORCE_ENABLE_SHADOW | INTEGRATED_BUTTONS"
config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true
config.check_for_updates = true
config.window_close_confirmation = 'NeverPrompt'
config.check_for_updates_interval_seconds = 86400
config.colors = colors
config.default_prog = default_prog
config.inactive_pane_hsb = inactive_pane_hsb
config.enable_kitty_graphics = true
config.enable_kitty_keyboard = true
config.enable_scroll_bar = true
config.enable_tab_bar = true
config.enable_title_reporting = true
config.enable_wayland = false
config.experimental_pixel_positioning = true
config.font_size = 16
config.macos_window_background_blur = 15
config.pane_focus_follows_mouse = false
config.prefer_to_spawn_tabs = true
config.show_update_window = true
config.tab_and_split_indices_are_zero_based = true
config.tab_max_width = 2
config.unix_domains = unix_domains
config.unzoom_on_switch_pane = false
config.use_fancy_tab_bar = true
config.use_resize_increments = true
config.visual_bell = visual_bell
config.window_background_opacity = 0.9
config.skip_close_confirmation_for_processes_named = { 'bash', 'sh', 'zsh', 'fish', 'tmux' }
config.window_padding = window_padding

if is_windows then
	config.window_background_opacity = 2
	config.harfbuzz_features = {"calt=0", "clig=0", "liga=0"}
end

wezterm.on('update-left-status', function(window, pane)
	local date = wezterm.strftime '%Y-%m-%d %H:%M:%S'
	-- Make it italic and underlined
	window:set_right_status(wezterm.format {
		{ Attribute = { Underline = 'Single' } },
		{ Attribute = { Italic = true } },
		{ Text = 'Hello ' .. date },
	})
end)

wezterm.on('update-right-status', function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	-- Figure out the cwd and host of the current pane.
	-- This will pick up the hostname for the remote host if your
	-- shell is using OSC 7 on the remote host.
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		local cwd = ''
		local hostname = ''

		if type(cwd_uri) == 'userdata' then
			-- Running on a newer version of wezterm and we have
			-- a URL object here, making this simple!

			cwd = cwd_uri.file_path
			hostname = cwd_uri.host or wezterm.hostname()
		else
			-- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
			-- which doesn't have the Url object
			cwd_uri = cwd_uri:sub(8)
			local slash = cwd_uri:find '/'
			if slash then
				hostname = cwd_uri:sub(1, slash - 1)
				-- and extract the cwd from the uri, decoding %-encoding
				cwd = cwd_uri:sub(slash):gsub('%%(%x%x)', function(hex)
					return string.char(tonumber(hex, 16))
				end)
			end
		end

		-- Remove the domain name portion of the hostname
		local dot = hostname:find '[.]'
		if dot then
			hostname = hostname:sub(1, dot - 1)
		end
		if hostname == '' then
			hostname = wezterm.hostname()
		end

		table.insert(cells, cwd)
		table.insert(cells, hostname)
	end

	-- I like my date/time in this style: "Wed Mar 3 08:14"
	local date = wezterm.strftime '%a %b %-d %H:%M'
	table.insert(cells, date)

	-- An entry for each battery (typically 0 or 1 battery)
	for _, b in ipairs(wezterm.battery_info()) do
		table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
	end

	-- The powerline < symbol
	local LEFT_ARROW = utf8.char(0xe0b3)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Color palette for the backgrounds of each cell
	local colors = {
		'#3c1361',
		'#52307c',
		'#663a82',
		'#7c5295',
		'#b491c8',
	}

	-- Foreground color for the text across the fade
	local text_fg = '#c0c0c0'

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	function push(text, is_last)
		local cell_no = num_cells + 1
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = ' ' .. text .. ' ' })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

if not is_windows then
	local function screen_info()
		local target_screen_name = 'LG ULTRAWIDE'
		local screens = wezterm.gui.screens()
		local target_screen = screens.by_name[target_screen_name] or screens.main
		-- print('screen_info:target_screen', target_screen)

		local cabalistic_height_adjustment = 74
		local cabalistic_x_adjustment = 12
		local cabalistic_y_adjustment = 210

		local data = {
			height = target_screen.height - cabalistic_height_adjustment, -- 1440 - 74 = 1366
			name = target_screen.name,
			width = target_screen.width / 4,                          -- 860
			x = 0 + cabalistic_x_adjustment,
			y = -screens.virtual_height - cabalistic_y_adjustment,
		}
		print('screen_info:data', data)

		return data
	end


	wezterm.on('gui-startup', function(cmd)
		local screen = screen_info()
		local position = {
			x = screen.x,
			y = screen.y,
			origin = "MainScreen",
		}
		print('gui-startup:position', position)

		cmd = cmd or { screen = screen.name, position = position }

		local _, pane, window_1 = wezterm.mux.spawn_window(cmd)

		print(
			string.format(
				'gui-startup:window_1:gui_window():set_inner_size(%d,%d)',
				screen.width, screen.height),
			window_1:gui_window():set_inner_size(
				screen.width, screen.height))

		pane:split {
			direction = 'Top',
			size = 0.5,
		}
	end)

	wezterm.on('window-config-reloaded', function(window, pane)
		print('window-config-reloaded:window:get_dimensions()', window:get_dimensions())
		local screens = wezterm.gui.screens()
		print('window-config-reloaded:wezterm.gui.screens()', {
			active_x = screens.active.x,
			active_y = screens.active.y,
			main_x = screens.main.x,
			main_y = screens.main.y,
			origin_x = screens.origin_x,
			origin_y = screens.origin_y,
			virtual_height = screens.virtual_height,
			virtual_width = screens.virtual_width,
		})
	end)
end

return config
