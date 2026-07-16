vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

local python3_host_prog = vim.fn.expand('~/.local/share/nvim-python/bin/python')
if vim.fn.executable(python3_host_prog) == 1 then
  vim.g.python3_host_prog = python3_host_prog
end

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

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- TODO looks cool from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/options.lua
-- TODO check what these do
vim.opt.formatoptions:remove('a') -- Auto formatting is BAD.
vim.opt.formatoptions:remove('t') -- Don't auto format my code. I got linters for that.
vim.opt.formatoptions:append('c') -- In general, I like it when comments respect textwidth
vim.opt.formatoptions:append('q') -- Allow formatting comments w/ gq
vim.opt.formatoptions:remove('o') -- O and o, don't continue comments
vim.opt.formatoptions:append('r') -- But do continue when pressing enter.
vim.opt.formatoptions:append('j') -- Auto-remove comments if possible.
vim.opt.formatoptions:append('n') -- indent with text, not with numbers (1. xxx\n  xxx)
vim.opt.formatoptions:remove('2') -- do not use the indent of the second line
