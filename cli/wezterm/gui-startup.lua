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

local function ssh_target(command)
	local target = command:match("^ssh%s+([^%s]+)")
	if not target then
		return nil
	end
	return target
end

local function ssh_host(target)
	local host = target:gsub("^.+@", "")
	return host:gsub("^%[", ""):gsub("%].*$", "")
end

local function ssh_username(target)
	return target:match("^([^@]+)@")
end

local function ssh_domain_name(target)
	local host = ssh_host(target)
	if host:match("^%d+%.%d+%.%d+%.%d+$") then
		return host
	end
	return host:match("^([^%.]+)") or host
end

local function startup_tab_options(entry, cmd)
	local opts = copy_table(cmd)
	local target = ssh_target(entry)
	if target then
		opts.domain = { DomainName = ssh_domain_name(target) }
		return opts, ssh_domain_name(target)
	end
	opts.args = { "/bin/zsh", "-lc", entry }
	return opts, nil
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

local function ssh_domains()
	local domains = {}
	for _, command in ipairs(startup_commands()) do
		local target = ssh_target(command)
		if target then
			table.insert(domains, {
				name = ssh_domain_name(target),
				remote_address = ssh_host(target),
				username = ssh_username(target),
				multiplexing = "None",
			})
		end
	end
	return domains
end

return {
	ssh_domains = ssh_domains,
}
