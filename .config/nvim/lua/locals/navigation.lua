----------------------------------------
-- nvim-tree.lua
----------------------------------------
vim.api.nvim_set_keymap('n', '<F6>', [[:NvimTreeToggle<cr>]], { silent = true })

----------------------------------------
-- Telescope
----------------------------------------
local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    mappings = {
      i = {
        ['<c-j>'] = actions.move_selection_next,
        ['<c-k>'] = actions.move_selection_previous,
      },
    },
    extensions = {
      ['ui-select'] = {
          require('telescope.themes').get_dropdown {
          }
      },
    },
  },
})

telescope.load_extension('gh')
telescope.load_extension('projects')
telescope.load_extension('ui-select')

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>pick', [[<cmd>lua require('telescope.builtin').builtin{}<CR>]], opts)

vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files{}<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fg', [[<cmd>lua require('telescope.builtin').live_grep{}<CR>]], opts)

-- vim pickers
vim.api.nvim_set_keymap(
  'n',
  '<leader>fb',
  [[<cmd>lua require('telescope.builtin').buffers{show_all_buffers = true }<CR>]],
  opts
)
vim.api.nvim_set_keymap('n', '<leader>fm', [[<cmd>lua require('telescope.builtin').keymaps{}<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fc', [[<cmd>lua require('telescope.builtin').commands{}<CR>]], opts)

vim.api.nvim_set_keymap('n', '<leader>fpr', [[<cmd>lua require('telescope').extensions.gh.pull_request{}<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fqf', [[<cmd>lua require('telescope.builtin').quickfix{}<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fll', [[<cmd>lua require('telescope.builtin').loclist{}<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>lr', [[<cmd>lua require('telescope.builtin').lsp_references{}<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>li', [[<cmd>lua require('telescope.builtin').lsp_implementations{}<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fp', [[<cmd>lua require('telescope').extensions.projects.projects()<cr>]], opts)
