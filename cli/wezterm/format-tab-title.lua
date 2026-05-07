local wezterm = require("wezterm")

local MAX_TAB_WIDTH = 42

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

local function build_cwd_title(path)
	local last3 = last_n_path_segments(path, 3, 4)
	if not last3 or last3 == "" then
		return nil
	end
	return last3
end

local function hostname_from_cwd_uri(cwd_uri)
	if not cwd_uri then
		return nil
	end

	if type(cwd_uri) == "userdata" then
		if cwd_uri.host and #cwd_uri.host > 0 then
			return cwd_uri.host
		end
		return nil
	end

	if type(cwd_uri) == "string" then
		if cwd_uri:find("^file://") then
			local rest = cwd_uri:sub(8)
			if rest:sub(1, 1) ~= "/" then
				return rest:match("^([^/]+)/")
			end
		end
	end

	return nil
end

local function short_hostname_from_pane(pane)
	local cwd_uri = pane and pane.current_working_dir
	local host = hostname_from_cwd_uri(cwd_uri) or wezterm.hostname() or ""
	if host:match("^%d+%.%d+%.%d+%.%d+$") then
		return host
	end
	local short = host:match("^([^%.]+)")
	return (short and #short > 0) and short or host
end

local function explicit_tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return nil
end

local function domain_title(pane)
	local domain = pane and pane.domain_name
	if domain and #domain > 0 and domain ~= "local" then
		return domain
	end
	return nil
end

local function tab_title_handler(tab_info)
	local hostname = short_hostname_from_pane(tab_info.active_pane)

	-- » « ║ ı •
	local separator = " • "

	local title = domain_title(tab_info.active_pane)
	if title then
		return title
	end

	title = explicit_tab_title(tab_info)
	if title then
		return title
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
	local tab_width = math.min(max_width, MAX_TAB_WIDTH)
	local title_width = math.max(tab_width - 2, 1)
	if #title > title_width then
		title = title:sub(1, title_width)
	end
	return {
		{ Text = " " .. title .. " " },
	}
end)
