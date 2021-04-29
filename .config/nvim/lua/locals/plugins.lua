
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
  }

  ----------------------------------------
  -- Appearance
  ----------------------------------------
  use 'folke/tokyonight.nvim'

  use {
      'hoob3rt/lualine.nvim',
      requires = {'kyazdani42/nvim-web-devicons', opt  = true},
  }
  use {
      'akinsho/nvim-bufferline.lua',
      requires = 'kyazdani42/nvim-web-devicons',
  }

  use {'lukas-reineke/indent-blankline.nvim', branch='lua'}
  use 'machakann/vim-highlightedyank'

  ----------------------------------------
  -- Navigation
  ----------------------------------------
  use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  use {
    'nvim-telescope/telescope-github.nvim',
    requires = 'nvim-telescope/telescope.nvim',
  }

  -- use 'airblade/vim-rooter'
  -- use 'yssl/QFEnter'

  ----------------------------------------
  -- Text Manipulation
  ----------------------------------------
  use 'tpope/vim-surround'

  ----------------------------------------
  -- Languages
  ----------------------------------------
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'norcalli/snippets.nvim'
  use 'liuchengxu/vista.vim'

  use { 'cappyzawa/starlark.vim', ft = 'starlark' }

end)
