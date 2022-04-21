vim.g.mapleader = ','

vim.g.do_filetype_lua = 1

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

vim.opt.updatetime = 700 -- time nvim will wait before executing things if cursor is not moving

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

vim.keymap.set('n', '<leader>path', [[:echo expand('%:p')<cr>]])

vim.keymap.set('n', '<leader>save', [[:w !sudo dd of=%<cr>]])

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set('i', '<C-a>', '<Esc>I')
vim.keymap.set('i', '<C-e>', '<Esc>A')

vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]])

-- better way for this?
vim.cmd([[autocmd FileType make set noexpandtab]])
