return {
  -- auto completion
  {
    'saghen/blink.cmp',
    version = '*',
    event = 'InsertEnter',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'fang2hou/blink-copilot',
      'moyiz/blink-emoji.nvim',
      'Kaiser-Yang/blink-cmp-dictionary',
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        keyword = {
          range = 'full',
        },
        menu = {
          auto_show = false,
          draw = {
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind', gap = 1 },
            },
          },
        },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'copilot', 'emoji' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          copilot = {
            name = 'Copilot',
            module = 'blink-copilot',
            async = true,
            score_offset = 100,
          },
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            opts = { insert = true },
          },
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          require('copilot.suggestion').dismiss()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
    opts_extend = {
      'sources.default',
      'appearance.kind_icons',
    },
  },

  -- surround
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = true,
  },

  -- comments
  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  -- better text-objects
  {
    'echasnovski/mini.ai',
    keys = {
      { 'a', mode = { 'x', 'o' } },
      { 'i', mode = { 'x', 'o' } },
    },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        init = function()
          -- no need to load the plugin, since we only need its queries
          require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
        end,
      },
    },
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
        },
      }
    end,
    config = function(_, opts)
      local ai = require('mini.ai')
      ai.setup(opts)
    end,
  },
}
