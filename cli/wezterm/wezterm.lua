-- Declaring global variables
HomePath = os.getenv("HOME") or os.getenv("USERPROFILE")
-- Declaring global variables - end

-- local inspect = require 'inspect'
local behavior = require "behavior"
local config_darwin = require "darwin"
local config_linux = require "linux"
local config_windows = require "windows"
local gui_startup = require "gui-startup"
local keys = require "keys"
local merge = require "merge"
local style = require "style"
local wezterm = require "wezterm"

require "window-config-reloaded"
require "theme"
require "format-tab-title"
-- require "update-left-status"
require "update-right-status"
-- require "status-bar"

local config = wezterm.config_builder()

-- Merging config
---- Default
config = merge.MergeObject(config, behavior)
config = merge.MergeObject(config, keys)
config = merge.MergeObject(config, style)
---- Per system
config = merge.MergeObject(config, config_darwin)
config = merge.MergeObject(config, config_linux)
config = merge.MergeObject(config, config_windows)
-- Merging config - end

config.ssh_domains = gui_startup.ssh_domains()

return config
