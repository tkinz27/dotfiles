----------------------------------------
-- nvim-tree.lua
----------------------------------------
vim.api.nvim_set_keymap('n', '<F6>', [[:NvimTreeToggle<cr>]], { silent = true })

----------------------------------------
-- Telescope
----------------------------------------
local telescope = require('telescope')
local builtins = require('telescope.builtin')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    layout_stategy = 'vertical',
    -- vimgrep_arguments = {
    --   'rg',
    --   '--color=never',
    --   '--no-heading',
    --   '--with-filename',
    --   '--line-number',
    --   '--column',
    --   '--smart-case',
    -- },
    -- mappings = {
    --   i = {
    --     ['<c-j>'] = actions.move_selection_next,
    --     ['<c-k>'] = actions.move_selection_previous,
    --   },
    -- },
  },
  extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown({}),
      },
      project = {
        base_dirs = {
          '~/.config/nvim/',
          '~/code',
        },
      },
    },
})

telescope.load_extension 'gh'
telescope.load_extension 'ui-select'
telescope.load_extension 'project'

vim.keymap.set('n', '<leader>pick', builtins.builtin, {desc="Telescope Pickers"})
vim.keymap.set('n', '<leader>ff', builtins.find_files, {desc="Telescope Find Files"})

vim.keymap.set('n', '<leader>lg', builtins.live_grep, {desc="Telescope Live Grep"})
vim.keymap.set('n', '<leader>grep', builtins.grep_string, {desc="Telescope Grep"})

vim.keymap.set('n', '<leader>erc', function()
  builtins.find_files({
    cwd = '~/.config/nvim',
  })
end, {desc="Telescope find neovim config files"})

-- vim pickers
vim.keymap.set('n', '<leader>bb', function()
  builtins.buffers({ show_all_buffers = true })
end, {desc="Telescope buffers"})
vim.keymap.set('n', '<leader>map', builtins.keymaps, {desc="Telescope keymaps"})
vim.keymap.set('n', '<leader>cmd', builtins.commands, {desc="Telescope commands"})

vim.keymap.set('n', '<leader>prs', telescope.extensions.gh.pull_request, {desc="Telescope GitHub Pull Requests"})

vim.keymap.set('n', '<leader>qf', builtins.quickfix, {desc="Telescope QuickFix"})
vim.keymap.set('n', '<leader>ll', builtins.loclist, {desc="Telescope LocList"})

vim.keymap.set('n', '<C-p>', telescope.extensions.project.project)
