
vim.o.wildmenu = true
vim.o.wildmode = 'longest,list,full'
vim.o.wildignore = '*.o,*~,*.pyc,*/tmp/*,*.zip'
vim.o.wildoptions = 'pum'

vim.o.incsearch = true
vim.o.ignorecase = true -- ignore case when searching
vim.o.smartcase = true -- unless there are caps in search
vim.o.cursorline = true -- highlight current line
vim.o.scrolloff = 10

-- tabs
vim.o.wrap = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

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
