vim.g.mapleader = ','

vim.o.wildmenu = true
vim.o.wildmode = 'longest:full,full'
vim.o.wildignore = '*.o,*~,*.pyc,*/tmp/*,*.zip'
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess..'c'
vim.o.inccommand = "nosplit"

vim.o.incsearch = true
vim.o.ignorecase = true -- ignore case when searching
vim.o.smartcase = true -- unless there are caps in search
vim.wo.cursorline = true -- highlight current line
vim.o.scrolloff = 10
vim.wo.scrolloff = 10

-- tabs
vim.wo.wrap = true
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.softtabstop = 4
vim.bo.softtabstop = 4

vim.o.backup = false
vim.o.writebackup = false
vim.bo.swapfile = false

-- vim.o.diffopt = vim.o.diffopt .. 'vertical' -- TODO doesn't work
vim.o.mouse = 'n'

--[[
-- TODO looks cool from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/options.lua
vim.o.formatoptions = vim.o.formatoptions
                    - 'a'     -- Auto formatting is BAD.
                    - 't'     -- Don't auto format my code. I got linters for that.
                    + 'c'     -- In general, I like it when comments respect textwidth
                    + 'q'     -- Allow formatting comments w/ gq
                    - 'o'     -- O and o, don't continue comments
                    + 'r'     -- But do continue when pressing enter.
                    + 'n'     -- Indent past the formatlistpat, not underneath it.
                    + 'j'     -- Auto-remove comments if possible.
                    - '2'     -- I'm not in gradeschool anymore
]]--

local mapopts = {noremap=true, silent=true}
vim.api.nvim_set_keymap('n', '<leader>erc', ':vsp ~/.config/nvim/init.vim<cr>', mapopts)
vim.api.nvim_set_keymap('n', '<leader>path', [[:echo expand('%:p')<cr>]], mapopts)

vim.api.nvim_set_keymap('n', '<leader>save', [[:w !sudo dd of=%<cr>]], mapopts)

vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], {noremap=true, silent=true})

vim.api.nvim_set_keymap('i', '<C-a>', '<Esc>I', {noremap=true, silent=true})
vim.api.nvim_set_keymap('i', '<C-e>', '<Esc>A', {noremap=true, silent=true})

vim.cmd [[autocmd BufWritePre * :%s/\s\+$//e]]

-- better way for this?
vim.cmd [[autocmd FileType make set noexpandtab]]
