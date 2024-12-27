local wezterm = require('wezterm')

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'tokyonight'

config.font = wezterm.font('BlexMono Nerd Font')

wezterm.on('update-status', function(window, pane)
  require('status').status_func(window, pane)
end)

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = 'a', mods = 'LEADER|CTRL',  action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' } },

  -- split panes
  { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER',       action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

  --
  { key = 'h', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Right' },
}

config.mouse_bindings = {
  { modes = 'CMD', event = { Up = { streak = 1, button = 'Left' } }, action = wezterm.action.OpenLinkAtMouseCursor },
}

return config
