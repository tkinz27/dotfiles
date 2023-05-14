vim.keymap.set('n', '<leader>path', [[:echo expand('%:p')<cr>]])

vim.keymap.set('n', '<leader>save', [[:w !sudo dd of=%<cr>]])

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set('i', '<C-a>', '<Esc>I')
vim.keymap.set('i', '<C-e>', '<Esc>A')

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- lazy
vim.keymap.set('n', '<leader>l', '<cmd>:Lazy<cr>', { desc = 'Lazy' })

-- profiling
vim.keymap.set('n', '<F2>', function()
  if vim.g.profiler_running then
    require('plenary.profile').stop()
    vim.g.profile_running = false
  else
    require('plenary.profile').start('nvim-profile.log', { flame = true })
    vim.g.profiler_running = true
  end
end, { desc = 'Start profiling' })
