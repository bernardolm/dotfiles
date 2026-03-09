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

local function path_basename(path)
	if path == "/" then
		return "/"
	end
	return path:match("([^/]+)$")
end

local function path_parent_name(path)
	if path == "/" then
		return nil
	end

	local parent_path = path:match("(.+)/[^/]+$")
	if not parent_path or parent_path == "" then
		return nil
	end
	if parent_path == "/" then
		return "/"
	end
	return parent_path:match("([^/]+)$")
end

-- Regra:
-- 1) mostrar "parent/current"
-- 2) se current > 25 chars, mostrar apenas current (sem truncar)
local function build_cwd_title(path)
	local normalized = normalize_path(path)
	if not normalized then
		return nil
	end

	local current = path_basename(normalized)
	if not current or current == "" then
		return nil
	end
	if #current > 25 then
		return current
	end

	local parent = path_parent_name(normalized)
	if not parent or parent == "" then
		return current
	end
	return parent .. "/" .. current
end

local function tab_title_handler(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end

	local pane = tab_info.active_pane
	local cwd = decode_uri_path(pane and pane.current_working_dir)
	local cwd_title = build_cwd_title(cwd)
	if cwd_title and #cwd_title > 0 then
		return cwd_title
	end

	return "WezTerm"
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title_handler(tab)
	return {
		{ Text = " " .. title .. " " },
	}
end)
