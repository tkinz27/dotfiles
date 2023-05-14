vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildignore = '*.o,*~,*.pyc,*/tmp/*,*.zip'
vim.opt.completeopt = 'menu,menuone,noselect' -- 'menuone,noinsert,noselect'
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
vim.opt.mouse = 'a'

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
