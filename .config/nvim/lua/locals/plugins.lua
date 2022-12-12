return require('packer').startup({
  function(use)
    -- Packer can manage itself
    use({
      'wbthomason/packer.nvim',
    })

    ----------------------------------------
    -- Appearance
    ----------------------------------------
    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end,
    })

    use('folke/tokyonight.nvim')

    use({
      'hoob3rt/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      -- config = require('plugins.configs.lualine'),
    })
    use({
      'akinsho/nvim-bufferline.lua',
      requires = 'kyazdani42/nvim-web-devicons',
    })

    use({ 'lukas-reineke/indent-blankline.nvim' })
    use('machakann/vim-highlightedyank')

    use({
      'rcarriga/nvim-notify',
      config = function()
        require('notify').setup({
          background_color = '#000000',
          background_colour = '#000000',
        })
        vim.notify = require('notify')
      end,
    })

    -- use({
    --     'folke/which-key.nvim',
    --     config = function()
    --         require('which-key').setup{}
    --     end,
    -- })

    ----------------------------------------
    -- Navigation
    ----------------------------------------
    use({
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require('nvim-tree').setup({
          update_cwd = true,
        })
      end,
    })

    use({
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
        'nvim-telescope/telescope-github.nvim',
        'nvim-telescope/telescope-media-files.nvim',
        'nvim-telescope/telescope-project.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
      },
    })

    ----------------------------------------
    -- Text Manipulation
    ----------------------------------------
    use('tpope/vim-surround')
    use('justinmk/vim-sneak')

    use({
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    })

    -- use({
    --   'nvim-treesitter/nvim-treesitter',
    --   run = ':TSUpdate',
    --   requires = {
    --     -- 'romgrk/nvim-treesitter-context',
    --     'p00f/nvim-ts-rainbow',
    --     'JoosepAlviste/nvim-ts-context-commentstring',
    --     'RRethy/nvim-treesitter-textsubjects',
    --     'windwp/nvim-ts-autotag',
    --   },
    --   config = require('plugins.configs.treesitter'),
    -- })

    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    use({ 'windwp/nvim-ts-autotag', requires = 'nvim-treesitter/nvim-treesitter' })
    use({ 'romgrk/nvim-treesitter-context', requires = 'nvim-treesitter/nvim-treesitter' })
    use({ 'RRethy/nvim-treesitter-textsubjects', requires = 'nvim-treesitter/nvim-treesitter' })
    use({ 'JoosepAlviste/nvim-ts-context-commentstring', requires = 'nvim-treesitter/nvim-treesitter' })

    -- use({
    --   'nvim-treesitter/playground',
    --   cmd = 'TSPlaygroundToggle',
    -- })

    ----------------------------------------
    -- Git
    ----------------------------------------
    use({
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('gitsigns').setup()
      end,
    })

    use('f-person/git-blame.nvim')

    use('sindrets/diffview.nvim')

    use({
      'pwntester/octo.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function()
        require('octo').setup({})
      end,
    })

    ----------------------------------------
    -- Languages
    ----------------------------------------
    use('neovim/nvim-lspconfig')
    use('nvim-lua/lsp_extensions.nvim')
    use('https://git.sr.ht/~whynothugo/lsp_lines.nvim')

    use({
      'zbirenbaum/copilot.lua',
      event = 'VimEnter',
      config = function()
        vim.defer_fn(function()
          require('copilot').setup({
            filetypes = {
              ['*'] = true,
            },
          })
        end, 100)
      end,
    })

    use({
      'zbirenbaum/copilot-cmp',
      after = { 'copilot.lua' },
      config = function()
        require('copilot_cmp').setup({
          method = 'getCompletionsCycling',
        })
      end,
    })

    use({
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-nvim-lsp-document-symbol',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-emoji',
        'hrsh7th/cmp-nvim-lua',
        'ray-x/cmp-treesitter',
        'onsails/lspkind-nvim',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
      },
      -- config = require('plugins.configs.cmp'),
    })

    use({ 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' } })

    use('b0o/schemastore.nvim')

    use('mfussenegger/nvim-dap')
    use('rcarriga/nvim-dap-ui')
    use('theHamsta/nvim-dap-virtual-text')
    use('nvim-telescope/telescope-dap.nvim')

    -- light build for code actions
    use('kosayoda/nvim-lightbulb')

    use({ 'jose-elias-alvarez/nvim-lsp-ts-utils', requires = { 'neovim/nvim-lspconfig' } })
    use({ 'ray-x/go.nvim', requires = { 'ray-x/guihua.lua' } })

    -- :Bazel build //...
    use({ 'bazelbuild/vim-bazel', requires = 'google/vim-maktaba' })

    use({ 'cappyzawa/starlark.vim', ft = 'starlark' })
    use({ 'google/vim-jsonnet', ft = 'jsonnet' })
    use({ 'towolf/vim-helm', ft = 'helm' })
    use({ 'tsandall/vim-rego', ft = 'rego' })
    use({ 'cstrahan/vim-capnp', ft = 'capnp' })
    use({ 'uarun/vim-protobuf', ft = 'proto' })
    use({ 'mitsuhiko/vim-jinja', ft = 'jinja' })
    use({ 'mustache/vim-mustache-handlebars', ft = 'mustache' })
    use({
      'hashivim/vim-terraform',
      ft = 'terraform',
      config = function()
        vim.g.terraform_fmt_on_save = '1'
        vim.g.terraform_fold_sections = '1'
        vim.g.terraform_align = '1'
      end,
    })
    use({ 'martinda/Jenkinsfile-vim-syntax', ft = 'Jenkinsfile' })
    use({
      'ekalinin/Dockerfile.vim',
      ft = 'dockerfile',
      config = function()
        vim.cmd([[au BufRead,BufNewFile Dockerfile set filetype=dockerfile]])
        vim.cmd([[au BufRead,BufNewFile Dockerfile* set filetype=dockerfile]])
      end,
    })

    use({
      'norcalli/nvim-terminal.lua',
      ft = 'terminal',
      config = function()
        require('terminal').setup()
      end,
    })

    ----------------------------------------
    -- Terminal
    ----------------------------------------
    use({
      'akinsho/toggleterm.nvim',
      config = function()
        require('toggleterm').setup({
          open_mapping = [[<c-\>]],
          direction = 'float',
          float_opts = {
            border = 'curved',
          },
        })
      end,
    })
    ----------------------------------------
    -- Debug
    ----------------------------------------
    use('bfredl/nvim-luadev')
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
  },
})
