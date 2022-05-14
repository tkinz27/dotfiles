local ok, lualine = pcall(require, 'lualine')

if not ok then
  return
end

lualine.setup({
  options = {
    theme = 'tokyonight',
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'filename', 'branch' },
    lualine_c = { 'toggleterm' },
    lualine_x = {},
    lualine_y = { 'filetype', 'fileformat', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'filetype', 'location' },
  },
  tabline = {},
  extensions = {
    'toggleterm',
  },
})
