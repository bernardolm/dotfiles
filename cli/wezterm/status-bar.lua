local wezterm = require 'wezterm'
local config = wezterm.config_builder()

wezterm.plugin
  .require('https://github.com/yriveiro/wezterm-status')
  .apply_to_config(config)