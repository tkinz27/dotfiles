-- setup packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  execute('packadd packer.nvim')
end

require('locals.plugins')
require('locals.defaults')
require('locals.treesitter')
require('locals.telescope')
require('locals.lsp')
require('plugins.configs.cmp')
require('plugins.configs.lualine')
require('locals.debug')
require('locals.appearance')
