
return require('packer').startup(function(use)
-- Packer can manage itself
use 'wbthomason/packer.nvim'

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
use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons', }

use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }

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
use 'justinmk/vim-sneak'

use {
    'terrortylor/nvim-comment',
    config = function()
        require('nvim_comment').setup {
            marker_padding = true,
            comment_empty = true,
            create_mappings = true,
            line_mapping = "gcc",
            operator_mapping = "gc",
        }
    end
}

use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
}

use {
    'p00f/nvim-ts-rainbow',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
        require('nvim-treesitter.configs').setup {
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = 1000,
            }
        }
    end
}

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
----------------------------------------
-- Languages
----------------------------------------
use 'neovim/nvim-lspconfig'
use 'nvim-lua/lsp_extensions.nvim'
use 'nvim-lua/completion-nvim'
use 'norcalli/snippets.nvim'
use 'ray-x/lsp_signature.nvim'

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

end)
