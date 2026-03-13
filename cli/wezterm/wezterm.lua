-- Declaring global variables
HomePath = os.getenv("HOME") or os.getenv("USERPROFILE")
-- Declaring global variables - end

local behavior = require("behavior")
local config_darwin = require("darwin")
local config_linux = require("linux")
local config_windows = require("windows")
-- local inspect = require 'inspect'
local merge = require("merge")
local style = require("style")
local wezterm = require("wezterm")

require("gui-startup")
require("format-tab-title")
require("update-left-status")
require("update-right-status")

local config = wezterm.config_builder()
-- local mux = wezterm.mux

-- Merging config
---- Default
config = merge.MergeObject(config, behavior)
config = merge.MergeObject(config, style)
---- Per system
config = merge.MergeObject(config, config_darwin)
config = merge.MergeObject(config, config_linux)
config = merge.MergeObject(config, config_windows)
-- Merging config - end

-- print(config)

return config
