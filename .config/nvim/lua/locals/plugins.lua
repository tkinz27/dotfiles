
return require('packer').startup({function(use)
-- Packer can manage itself
use {
  'wbthomason/packer.nvim'
}

----------------------------------------
-- Appearance
----------------------------------------
use 'folke/tokyonight.nvim'
use 'marko-cerovac/material.nvim'

use {
  'hoob3rt/lualine.nvim',
  requires = {'kyazdani42/nvim-web-devicons', opt  = true},
}
use {
  'akinsho/nvim-bufferline.lua',
  requires = 'kyazdani42/nvim-web-devicons',
}

use {'lukas-reineke/indent-blankline.nvim'}
use 'machakann/vim-highlightedyank'

----------------------------------------
-- Navigation
----------------------------------------
use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons', }

use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }

use {
    'nvim-telescope/telescope-github.nvim',
    requires = 'nvim-telescope/telescope.nvim',
}

use {
    'nvim-telescope/telescope-media-files.nvim',
    requires = 'nvim-telescope/telescope.nvim',
}

-- use 'airblade/vim-rooter'
-- use 'yssl/QFEnter'

----------------------------------------
-- Text Manipulation
----------------------------------------
use 'tpope/vim-surround'
use 'justinmk/vim-sneak'

use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
}

use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
}

use {
    'nvim-treesitter/playground'
}

use {
    'romgrk/nvim-treesitter-context',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
        require('treesitter-context.config').setup{enable=true}
    end,
}

use {
    'p00f/nvim-ts-rainbow',
    requires = 'nvim-treesitter/nvim-treesitter',
}

use 'JoosepAlviste/nvim-ts-context-commentstring'

use {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
}

----------------------------------------
-- Git
----------------------------------------
use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
        require('gitsigns').setup()
    end
}

use 'f-person/git-blame.nvim'

use 'sindrets/diffview.nvim'
----------------------------------------
-- Languages
----------------------------------------
use 'neovim/nvim-lspconfig'
use 'nvim-lua/lsp_extensions.nvim'
use 'onsails/lspkind-nvim'

use 'hrsh7th/nvim-cmp'
use { 'hrsh7th/cmp-nvim-lsp', requires = {'hrsh7th/nvim-cmp'}}
use { 'hrsh7th/cmp-buffer', requires = {'hrsh7th/nvim-cmp'}}
use { 'hrsh7th/cmp-path', requires = {'hrsh7th/nvim-cmp'}}
use { 'hrsh7th/cmp-emoji', requires = {'hrsh7th/nvim-cmp'}}
use { 'hrsh7th/cmp-nvim-lua', requires = {'hrsh7th/nvim-cmp'}}
use { 'ray-x/cmp-treesitter', requires = {'hrsh7th/nvim-cmp'}}

use 'L3MON4D3/LuaSnip'
use { 'saadparwaiz1/cmp_luasnip', requires = {'hrsh7th/nvim-cmp', 'L3MON4D3/LuaSnip'}}

use 'mfussenegger/nvim-dap'
use {'rcarriga/nvim-dap-ui', requires = {'mfussengger/nvim-dap'}}

-- light build for code actions
use 'kosayoda/nvim-lightbulb'

-- :Bazel build //...
use { 'bazelbuild/vim-bazel', requires = 'google/vim-maktaba' }

use { 'cappyzawa/starlark.vim', ft = 'starlark' }
use { 'google/vim-jsonnet', ft = 'jsonnet' }
use { 'towolf/vim-helm', ft = 'helm' }
use { 'tsandall/vim-rego', ft = 'rego' }
use { 'cstrahan/vim-capnp', ft = 'capnp' }
use { 'uarun/vim-protobuf', ft = 'proto' }
use { 'mitsuhiko/vim-jinja', ft = 'jinja' }
use { 'mustache/vim-mustache-handlebars', ft = 'mustache' }
use {
    'hashivim/vim-terraform', ft = 'terraform',
    config = function()
        vim.g.terraform_fmt_on_save = '1'
        vim.g.terraform_fold_sections = '1'
        vim.g.terraform_align = '1'
    end
}
use { 'martinda/Jenkinsfile-vim-syntax', ft = 'Jenkinsfile' }
use { 'ekalinin/Dockerfile.vim', ft = 'dockerfile',
    config = function()
        vim.cmd [[au BufRead,BufNewFile Dockerfile set filetype=dockerfile]]
        vim.cmd [[au BufRead,BufNewFile Dockerfile* set filetype=dockerfile]]
    end
}

-- use {
--     'prettier/vim-prettier',
--     ft = {'javascript', 'typescript', 'css', 'less', 'scss',
--           'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'},
--     run = 'yarn install',
-- }

-- use {
--      'elzr/vim-json',
--      ft = 'json',
--      config = function()
--          vim.g.vim_json_syntax_conceal = '0'
--          vim.cmd [[autocmd FileType json setlocal foldmethod=syntax]]
--      end
--}

use { 'stephpy/vim-yaml', ft = 'yaml' }
use { 'pedrohdz/vim-yaml-folds', ft = 'yaml' }

----------------------------------------
-- Debug
----------------------------------------
use 'bfredl/nvim-luadev'

end,
config = {
    display = {
        open_fn = require('packer.util').float,
    },
}})
