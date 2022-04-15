vim.g.mapleader = ','

vim.opt.exrc = true

vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildignore = '*.o,*~,*.pyc,*/tmp/*,*.zip'
vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.shortmess = vim.opt.shortmess + 'c'
vim.opt.inccommand = 'nosplit'

vim.opt.incsearch = true
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- unless there are caps in search
vim.opt.cursorline = true -- highlight current line
vim.opt.scrolloff = 10

-- tabs
vim.opt.wrap = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.diffopt = vim.opt.diffopt + 'vertical'
vim.opt.mouse = 'n'

-- TODO looks cool from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/options.lua
-- TODO check what these do
vim.opt.formatoptions = vim.opt.formatoptions
  - 'a' -- Auto formatting is BAD.
  - 't' -- Don't auto format my code. I got linters for that.
  + 'c' -- In general, I like it when comments respect textwidth
  + 'q' -- Allow formatting comments w/ gq
  - 'o' -- O and o, don't continue comments
  + 'r' -- But do continue when pressing enter.
  + 'j' -- Auto-remove comments if possible.
  + 'n' -- indent with text, not with numbers (1. xxx\n  xxx)
  - '2' -- do not use the indent of the second line

local mapopts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>erc', ':vsp ~/.config/nvim.opt.vim<cr>', mapopts)
vim.api.nvim_set_keymap('n', '<leader>path', [[:echo expand('%:p')<cr>]], mapopts)

vim.api.nvim_set_keymap('n', '<leader>save', [[:w !sudo dd of=%<cr>]], mapopts)

vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('i', '<C-a>', '<Esc>I', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-e>', '<Esc>A', { noremap = true, silent = true })

vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]])

-- better way for this?
vim.cmd([[autocmd FileType make set noexpandtab]])

require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
  incremental_selection = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  context_commentstring = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
})
