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

local function resolve_last_zsh_cwd()
	local candidates = {
		(HomePath or "") .. "/.cache/zsh/last-working-dir",
	}

	for _, candidate in ipairs(candidates) do
		local cwd = read_file(candidate)
		if cwd and path_exists(cwd) then
			return cwd
		end
	end

	return HomePath
end

wezterm.on("gui-startup", function(cmd)
	local bootstrap_tab_opts = copy_table(cmd)
	bootstrap_tab_opts.args = { "/bin/sh" }
	bootstrap_tab_opts.cwd = HomePath
	local _, temp_pane, window = mux.spawn_window(bootstrap_tab_opts)
	local gui_window = window:gui_window()
	if gui_window then
		gui_window:maximize()
	end

	local dotfiles_cwd = (HomePath or "") .. "/dotfiles"
	window:spawn_tab({ cwd = dotfiles_cwd })
	local second_tab_cwd = resolve_last_zsh_cwd()
	window:spawn_tab({ cwd = second_tab_cwd })

	if temp_pane then
		wezterm.time.call_after(0.05, function()
			temp_pane:send_text("exit\n")
		end)
	end
end)
