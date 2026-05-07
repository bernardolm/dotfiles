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

local STARTUP_COMMANDS_FILE = "dotfiles/cli/wezterm/startup-commads.txt"

local function ssh_tab_title(command)
	local host = command:match("^ssh%s+([^%s]+)")
	if not host then
		return nil
	end
	host = host:gsub("^.+@", "")
	host = host:gsub("^%[", ""):gsub("%].*$", "")
	host = host:gsub(":.*$", "")
	if host:match("^%d+%.%d+%.%d+%.%d+$") then
		return host
	end
	return host:match("^([^%.]+)") or host
end

local function startup_tab_options(entry, cmd)
	local opts = copy_table(cmd)
	opts.args = { "/bin/zsh", "-lc", entry }
	return opts, ssh_tab_title(entry)
end

local function startup_commands()
	local home = HomePath or wezterm.home_dir or ""
	local path = home .. "/" .. STARTUP_COMMANDS_FILE
	local file = io.open(path, "r")
	if not file then
		return { "/bin/zsh" }
	end
	local commands = {}
	for line in file:lines() do
		if #line > 0 and not line:match("^#") then
			table.insert(commands, line)
		end
	end
	file:close()
	if #commands == 0 then
		return { "/bin/zsh" }
	end
	return commands
end

wezterm.on("gui-startup", function(cmd)
	local commands = startup_commands()
	local bootstrap_tab_opts, first_title = startup_tab_options(commands[1], cmd)
	local first_tab, _, window = mux.spawn_window(bootstrap_tab_opts)
	if first_title then
		first_tab:set_title(first_title)
	end
	local gui_window = window:gui_window()
	if gui_window then
		gui_window:maximize()
	end

	for i = 2, #commands do
		local tab_opts, title = startup_tab_options(commands[i], nil)
		local tab = window:spawn_tab(tab_opts)
		if title then
			tab:set_title(title)
		end
	end
end)
