local wezterm = require 'wezterm'

local M = {}

local schemes = wezterm.color.get_builtin_schemes()

local scheme_names = {}
for name, scheme in pairs(schemes) do
	table.insert(scheme_names, name)
end

local blocklist_names = {
	"3024 (base16)",
	"3024 (dark) (terminal.sexy)",
	"astromouse (terminal.sexy)",
	"Bitmute (terminal.sexy)",
	"Black Metal (Khold) (base16)",
	"Bleh-1 (terminal.sexy)",
	"Borland",
	"C64 (Gogh)",
	"CGA",
	"Cloud (terminal.sexy)",
	"Dark Pastel (Gogh)",
	"Dark Pastel",
	"Dark Violet (base16)",
	"Derp (terminal.sexy)",
	"Digerati (terminal.sexy)",
	"Dissonance (Gogh)",
	"Django",
	"ENCOM",
	"Fahrenheit",
	"Fairyfloss",
	"Fishbone (terminal.sexy)",
	"Gnometerm (terminal.sexy)",
	"Gotham (terminal.sexy)",
	"Grass (Gogh)",
	"Grass",
	"Green Screen (base16)",
	"Greenscreen (dark) (terminal.sexy)",
	"Gruvbox Material (Gogh)",
	"Harper",
	"HaX0R_R3D",
	"HemisuDark (Gogh)",
	"Hipster Green",
	"Hurtado",
	"Hybrid (terminal.sexy)",
	"ICGreenPPL (Gogh)",
	"Iiamblack (terminal.sexy)",
	"Insignificato (terminal.sexy)",
	"IrBlack (Gogh)",
	"iTerm2 Dark Background",
	"Jackie Brown (Gogh)",
	"Jason Wryan (terminal.sexy)",
	"Jellybeans (Gogh)",
	"Jup (Gogh)",
	"JWR dark (terminal.sexy)",
	"Kokuban (Gogh)",
	"Laser",
	"LiquidCarbonTransparentInverse",
	"Low Contrast (terminal.sexy)",
	"Lunaria Dark (Gogh)",
	"Mathias",
	"Modus-Vivendi-Tritanopia",
	"MonaLisa",
	"mono-amber (Gogh)",
	"mono-amber",
	"mono-red (Gogh)",
	"mono-yellow (Gogh)",
	"Neopolitan",
	"PaulMillr",
	"rebecca",
	"Red Alert",
	"Red Sands (Gogh)",
	"Red Sands",
	"RedAlert (Gogh)",
	"RedSands (Gogh)",
	"Sat (Gogh)",
	"Selenized Dark (Gogh)",
	"Shapeshifter (dark) (terminal.sexy)",
	"Simple Rainbow (terminal.sexy)",
	"SolarizedDarcula (Gogh)",
	"SOS (terminal.sexy)",
	"Symfonic",
	"Synth Midnight Terminal Dark (base16)",
	"Tangoesque (terminal.sexy)",
	"Tender (Gogh)",
	"UltraDark",
	"Vibrant Ink (Gogh)",
	"Warmneon",
	"Website (Gogh)",
	"Wez",
	"Windows NT (base16)",
	"Wombat",
	"CrayonPonyFish",
	"Wryan",
	"Wzoreck (Gogh)",
	"Zenburn (Gogh)",
}

local blocklist = {}
for _, name in ipairs(blocklist_names) do
	blocklist[name] = true
end

-- No dark/light metadata field on this wezterm build, so this reads the
-- actual background color instead of guessing from the name — catches
-- light themes whose name doesn't say "light"/"bright".
local function is_light_scheme(name)
	local scheme = schemes[name]
	local color = wezterm.color.parse(scheme.background)
	local _, _, lightness, _ = color:hsla()
	return lightness > 0.5
end

local function pick_random_scheme()
	local scheme
	repeat
		scheme = scheme_names[math.random(#scheme_names)]
	until not blocklist[scheme] and not scheme:lower():find("light") and not scheme:lower():find("bright") and not is_light_scheme(scheme)
	return scheme
end

local tab_schemes = {}
local last_active_tab_id = nil

local function scheme_for_tab(tab_id)
	local scheme = tab_schemes[tab_id]
	if not scheme then
		scheme = pick_random_scheme()
		tab_schemes[tab_id] = scheme
	end
	return scheme
end

function M.current_scheme_name(window)
	local tab = window:active_tab()
	if not tab then
		return nil
	end
	return tab_schemes[tab:tab_id()]
end

function M.copy_current_scheme_name(window)
	local scheme = M.current_scheme_name(window)
	if scheme then
		window:copy_to_clipboard(scheme)
		window:toast_notification('theme', scheme .. ' copied to clipboard', nil, 2000)
	end
end

wezterm.on('update-status', function(window, pane)
	local tab = window:active_tab()
	if not tab then
		return
	end
	local tab_id = tab:tab_id()
	if tab_id == last_active_tab_id then
		return
	end
	last_active_tab_id = tab_id

	local scheme = scheme_for_tab(tab_id)
	window:set_config_overrides { color_scheme = scheme }
end)

return M
