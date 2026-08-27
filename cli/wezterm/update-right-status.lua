local random_theme = require("random-theme")
local style = require("style")
local wezterm = require("wezterm")

wezterm.on('update-right-status', function(window, pane)
	local scheme = random_theme.current_scheme_name(window)
	if scheme then
		window:set_right_status(wezterm.format {
			-- { Foreground = { Color = 'FF91F2ED' } }, # NOTE: temporarily disabled by the user
			{ Text = '  ' .. scheme .. '  ' },
		})
	else
		window:set_right_status('')
	end
end)

--[[ Previous right-status implementation (cwd/hostname/date, arrow-segment
style), kept for reference/reuse — not deleted, just not wired up.

local function format_date()
	local weekday = wezterm.strftime "%A"
	-- local day = wezterm.strftime "%-d"
	-- local month = wezterm.strftime "%B"
	-- local year = wezterm.strftime "%y"
	-- local time = wezterm.strftime "%H:%M"
	-- return string.format("%s, %s %s %s, %s", weekday, day, month, year, time)
	return weekday
end

local function shorten_path(path, max_chars)
	max_chars = max_chars or 4
	local parts = {}
	for part in path:gmatch("[^/]+") do
		table.insert(parts, part:sub(1, max_chars))
	end
	return "/" .. table.concat(parts, "/")
end

wezterm.on('update-right-status', function(window, pane)
	window:set_right_status('')

	if false then
		local cells = {}

		local cwd_uri = pane:get_current_working_dir()
		if cwd_uri then
			local cwd = ''
			local hostname = ''

			if type(cwd_uri) == 'userdata' then
				cwd = cwd_uri.file_path
				hostname = cwd_uri.host or wezterm.hostname()
			else
				cwd_uri = cwd_uri:sub(8)
				local slash = cwd_uri:find '/'
				if slash then
					hostname = cwd_uri:sub(1, slash - 1)
					cwd = cwd_uri:sub(slash):gsub('%%(%x%x)', function(hex)
						return string.char(tonumber(hex, 16))
					end)
				end
			end

			local dot = hostname:find '[.]'
			if dot then
				hostname = hostname:sub(1, dot - 1)
			end
			if hostname == '' then
				hostname = wezterm.hostname()
			end

			table.insert(cells, shorten_path(cwd))
			table.insert(cells, hostname)
		end

		local date = format_date()
		table.insert(cells, date)

		-- for _, b in ipairs(wezterm.battery_info()) do
		-- 	table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
		-- end

		local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

		local colors = style.right_status_palette.steps
		local text_fg = style.right_status_palette.text_fg
		local elements = {}

		local function push(text, idx)
			table.insert(elements, { Background = { Color = colors[idx] } })
			table.insert(elements, { Foreground = { Color = colors[idx + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })

			table.insert(elements, { Background = { Color = colors[idx+1] } })
			table.insert(elements, { Foreground = { Color = text_fg } })
			table.insert(elements, { Text = '   ' .. text .. '   ' })
		end

		for idx, value in ipairs(cells) do
			push(value, idx)
		end

		window:set_right_status(wezterm.format(elements))
	end
end)
]]
