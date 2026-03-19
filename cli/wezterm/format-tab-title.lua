local wezterm = require("wezterm")

local function decode_uri_path(cwd_uri)
	if not cwd_uri then
		return nil
	end

	if type(cwd_uri) == "userdata" then
		if cwd_uri.file_path then
			return cwd_uri.file_path
		end
		cwd_uri = tostring(cwd_uri)
	end

	if type(cwd_uri) ~= "string" then
		return nil
	end

	local cwd = cwd_uri
	if cwd:find("^file://") then
		cwd = cwd:gsub("^file://[^/]*", "")
	end
	cwd = cwd:gsub("%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end)
	return cwd
end

local function normalize_path(path)
	if not path or path == "" then
		return nil
	end
	local normalized = path:gsub("/+$", "")
	if normalized == "" then
		return "/"
	end
	return normalized
end

-- Return the last N path segments joined by "/", each truncated to max_char chars (e.g. last 3 folders, 4 chars each).
local function last_n_path_segments(path, n, max_char)
	max_char = max_char or 0
	local normalized = normalize_path(path)
	if not normalized or normalized == "/" then
		return nil
	end
	local parts = {}
	for segment in (normalized .. "/"):gmatch("([^/]+)/") do
		table.insert(parts, segment)
	end
	if #parts == 0 then
		return nil
	end
	local from = math.max(1, #parts - n + 1)
	local slice = {}
	for i = from, #parts do
		local s = parts[i]
		if max_char > 0 and #s > max_char then
			s = s:sub(1, max_char)
		end
		table.insert(slice, s)
	end
	return table.concat(slice, "/")
end

-- Tab title: hostname » last 3 path segments, 4 chars each (e.g. "hostname » work/bern/dotf").
local function build_cwd_title(path)
	local last3 = last_n_path_segments(path, 3, 4)
	if not last3 or last3 == "" then
		return nil
	end
	return last3
end

-- Shortest hostname: part before first dot (e.g. "machine.local" -> "machine").
local function short_hostname()
	local full = wezterm.hostname() or ""
	local short = full:match("^([^%.]+)")
	return (short and #short > 0) and short or full
end

local function tab_title_handler(tab_info)
	local hostname = short_hostname()

	-- » « ║ ı •
	local separator = " • "

	local title = tab_info.tab_title
	if title and #title > 0 then
		return hostname .. separator .. title
	end

	local pane = tab_info.active_pane
	local cwd = decode_uri_path(pane and pane.current_working_dir)
	local cwd_title = build_cwd_title(cwd)
	if cwd_title and #cwd_title > 0 then
		return hostname .. separator .. cwd_title
	end

	return #hostname > 0 and hostname or "WezTerm"
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title_handler(tab)
	return {
		{ Text = " " .. title .. " " },
	}
end)
