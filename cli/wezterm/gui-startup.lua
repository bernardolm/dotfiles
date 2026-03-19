local wezterm = require("wezterm")
local mux = wezterm.mux

local function copy_table(source)
	local target = {}
	if type(source) ~= "table" then
		return target
	end
	for key, value in pairs(source) do
		target[key] = value
	end
	return target
end

local function path_exists(path)
	if not path or path == "" then
		return false
	end
	local ok = os.rename(path, path)
	if ok then
		return true
	end
	return false
end

local function read_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	if not content or content == "" then
		return nil
	end
	content = content:gsub("%s+$", "")
	if content == "" then
		return nil
	end
	return content
end

local START_OPEN_PATHS_FILE = "dotfiles/cli/wezterm/start-open-paths.txt"

local function expand_path(line)
	local home = HomePath or wezterm.home_dir or ""
	return (line:gsub("^~", home):gsub("%$HOME", home))
end

local function startup_tab_paths()
	local home = HomePath or wezterm.home_dir or ""
	local path = home .. "/" .. START_OPEN_PATHS_FILE
	local file = io.open(path, "r")
	if not file then
		return { home }
	end
	local paths = {}
	for line in file:lines() do
		line = line:match("^%s*(.-)%s*$") or line
		if #line > 0 and not line:match("^#") then
			table.insert(paths, expand_path(line))
		end
	end
	file:close()
	if #paths == 0 then
		return { home }
	end
	return paths
end

wezterm.on("gui-startup", function(cmd)
	local paths = startup_tab_paths()
	local first_cwd = paths[1]
	local bootstrap_tab_opts = copy_table(cmd)
	bootstrap_tab_opts.args = { "/bin/sh" }
	bootstrap_tab_opts.cwd = first_cwd
	local _, _, window = mux.spawn_window(bootstrap_tab_opts)
	local gui_window = window:gui_window()
	if gui_window then
		gui_window:maximize()
	end

	for i = 2, #paths do
		window:spawn_tab({ cwd = paths[i] })
	end
end)
