local wezterm = require("wezterm")
-- local mux = wezterm.mux

wezterm.on("update-left-status", function(window, _)
	-- Intentionally empty.
	-- Previously this handler set `set_right_status`, but we now draw the
	-- right-status content into the terminal content area instead.
	-- local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
	-- window:set_right_status(wezterm.format({
	-- 	{ Attribute = { Underline = "Single" } },
	-- 	{ Attribute = { Italic = true } },
	-- 	{ Text = "Hello " .. date },
	-- }))
end)
