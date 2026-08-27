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

local function startup_commands()
	local home = HomePath or wezterm.home_dir or ""
	local path = home .. "/" .. STARTUP_COMMANDS_FILE
	local file = io.open(path, "r")
	if not file then
		return {}
	end
	local commands = {}
	for line in file:lines() do
		if #line > 0 and not line:match("^#") then
			table.insert(commands, line)
		end
	end
	file:close()
	return commands
end

local function startup_tab_options(entry, cmd)
	local opts = copy_table(cmd)
	local target = ssh_target(entry)
	if target then
		opts.domain = { DomainName = ssh_domain_name(target) }
		return opts, ssh_domain_name(target)
	end
	-- Must match behavior.lua's default_domain, or this spawns on a
	-- different domain than the window wezterm-gui auto-attaches to.
	opts.domain = { DomainName = 'unix' }
	opts.args = { "/bin/zsh", "-lc", entry }
	return opts, nil
end

-- wezterm-gui independently guarantees the configured default_domain (see
-- behavior.lua) has a window — a plain $HOME shell — regardless of what
-- gui-startup does, so commands[1] (the "cd $HOME" entry) is never spawned
-- explicitly; that built-in window already covers it (and gets maximized
-- by window-config-reloaded.lua). The rest (commands[2..N]) are spawned
-- here, deferred until a window exists, only if the window doesn't already
-- have them.
--
-- KNOWN ISSUE, kept implemented anyway (user's call): the "no windows yet"
-- guard below does NOT reliably prevent this from re-adding tabs on every
-- relaunch — verified across 5 consecutive kill+reopen cycles, pane count
-- grew 3→4→5→6 with entries active. Leave startup-commads.txt with only
-- commented-out entries (its current state) to keep this dormant/safe;
-- uncomment entries there deliberately, accepting that tab count may grow
-- on every wezterm-gui restart.
wezterm.on("gui-startup", function(cmd)
	if #mux.all_windows() > 0 then
		return
	end

	wezterm.time.call_after(0.2, function()
		local window = mux.all_windows()[1]
		if not window then
			return
		end

		local commands = startup_commands()
		for i = 2, #commands do
			local tab_opts, title = startup_tab_options(commands[i], nil)
			local tab = window:spawn_tab(tab_opts)
			if title then
				tab:set_title(title)
			end
		end
	end)
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
