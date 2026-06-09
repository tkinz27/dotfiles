if vim.g.vscode then
else
  require('config.options')
  require('config.keymaps')
  require('config.autocmds')
  require('config.lazy')
  require('lazy').setup('plugins', {
    rocks = {
      enabled = false,
    },
    change_detection = {
      notify = false,
    },
  })
end
