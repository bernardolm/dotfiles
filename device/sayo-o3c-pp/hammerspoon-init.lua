hs.hotkey.bind({"cmd"}, "`", function()
  -- hs.application.launchOrFocus("Wezterm")

	wez = hs.application.find("Wezterm")

	if wez then
		if wez:isFrontmost() then
			wez:hide()
		else
			wez:activate()
		end
	end
end)

-- SayoDevice O3C macro keys (Z/X/C/V -> ctrl+alt+cmd+1/2/3/4)
-- F13/F14/F15 were reserved by macOS for brightness, so we moved to this chord.
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "1", function()
	hs.application.launchOrFocus("/Applications/Docker.app/Contents/MacOS/Docker Desktop.app")
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "2", function()
	hs.application.launchOrFocus("Wezterm")
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "3", function()
	hs.execute("/Users/bernardo/sync/personal/vpn/acao/openvpn.sh &")
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "4", function()
	hs.application.launchOrFocus("Claude")
end)

