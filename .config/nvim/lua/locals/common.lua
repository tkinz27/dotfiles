----------------------------------------
-- Common helper functions
----------------------------------------
-- non-recursive remap, silence output
local mapopts = { noremap = true, silent = true }

-- set keymap in normal mode, with noremap and silent
local function map(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, mapopts)
end

-- buffer local keymap in normal mode, with noremap and silent
local function bmap(mode, lhs, rhs)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, mapopts)
end

return {
  map = map,
  bmap = bmap,
}
