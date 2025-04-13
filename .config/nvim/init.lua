if vim.g.vscode then
else
  require('config.options')
  require('config.keymaps')
  require('config.autocmds')
  require('config.lazy')
  require('lazy').setup('plugins', {
    change_detection = {
      notify = false,
    },
  })
end
