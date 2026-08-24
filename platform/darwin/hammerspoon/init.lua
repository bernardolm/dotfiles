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
