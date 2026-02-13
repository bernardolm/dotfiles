local wezterm = require("wezterm")
local mux = wezterm.mux

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
	local dotfiles_cwd = (HomePath or "") .. "/dotfiles"
	local first_tab_opts = cmd or {}
	first_tab_opts.cwd = dotfiles_cwd
	local _, _, window = mux.spawn_window(first_tab_opts)
	local gui_window = window:gui_window()
	gui_window:maximize()

	local second_tab_cwd = resolve_last_zsh_cwd()
	window:spawn_tab({ cwd = second_tab_cwd })
end)
