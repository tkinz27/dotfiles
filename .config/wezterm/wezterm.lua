local wezterm = require('wezterm')
local action = wezterm.action

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

-- wezterm.on('format-tab-title', function(tab, tabs, _, _, hover, _)
--   local is_first = tab.tab_id == tabs[1].tab_id
--   local is_last = tab.tab_id == tabs[#tabs].tab_id
--
--   local title = tab.active_pane.title
--
--   return {
--     { Attribute = { Italic = false } },
--     { Attribute = { Intensity = hover and 'Bold' or 'Normal' } },
--     -- { Background = { Color = leading_bg } },
--     -- { Foreground = { Color = leading_fg } },
--     { Text = SOLID_RIGHT_ARROW },
--     -- { Background = { Color = background } },
--     -- { Foreground = { Color = foreground } },
--     { Text = ' ' .. title .. ' ' },
--     -- { Background = { Color = trailing_bg } },
--     -- { Foreground = { Color = trailing_fg } },
--     { Text = SOLID_RIGHT_ARROW },
--   }
-- end)

local copy_mode = nil
if wezterm.gui then
  copy_mode = wezterm.gui.default_key_tables().copy_mode
  for _, key_binding in ipairs({
    { key = 'd', mods = 'CTRL', action = action.CopyMode('PageDown') },
    { key = 'u', mods = 'CTRL', action = action.CopyMode('PageUp') },
  }) do
    table.insert(copy_mode, key_binding)
  end
end

return {
  color_scheme = 'tokyonight',
  font = wezterm.font('JetBrainsMono Nerd Font'),
  font_size = 13,

  window_background_opacity = 0.9,
  -- window_decorations = 'NONE',
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  },

  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = 'a', mods = 'LEADER', action = action.SendString('\x01') },

    -- Split Panes
    { key = '|', mods = 'LEADER|SHIFT', action = action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = '_', mods = 'LEADER|SHIFT', action = action.SplitVertical({ domain = 'CurrentPaneDomain' }) },

    -- Navigate Panes
    { key = 'h', mods = 'LEADER', action = action.ActivatePaneDirection('Left') },
    { key = 'j', mods = 'LEADER', action = action.ActivatePaneDirection('Down') },
    { key = 'k', mods = 'LEADER', action = action.ActivatePaneDirection('Up') },
    { key = 'l', mods = 'LEADER', action = action.ActivatePaneDirection('Right') },

    -- Copy mode
    { key = '[', mods = 'LEADER', action = action.ActivateCopyMode },
  },

  key_tables = {
    copy_mode = copy_mode,
  },
}
