local wezterm = require("wezterm")
-- local mux = wezterm.mux

wezterm.on("update-left-status", function(window, _)
	local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
	window:set_right_status(wezterm.format({
		{ Attribute = { Underline = "Single" } },
		{ Attribute = { Italic = true } },
		{ Text = "Hello " .. date },
	}))
end)
