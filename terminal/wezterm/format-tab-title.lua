local wezterm = require 'wezterm'

-- Function to get the suggested title for a tab.
-- It prefers the explicitly set title but falls back to the pane's title.
local function tab_title_handler(tab_info)
	local title = tab_info.tab_title
	-- If an explicit title is set (e.g. by an application), use that.
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the CWD from the active pane in that tab.
	local pane = tab_info.active_pane
	local cwd = pane.current_working_dir
	if cwd then
		-- Return the basename (last component) of the path for a cleaner look
		return wezterm.basename(cwd)
		-- Or return the full path if preferred
		-- return cwd
	end
	return "WezTerm" -- Fallback title
end

-- Register the format-tab-title event handler
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
	-- You can customize the styling here if you wish,
	-- but this minimal example just returns the title string.
	local title = tab_title_handler(tab)
	return {
		{ Text = " " .. title .. " " },
	}
end)
