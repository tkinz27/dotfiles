return {

  -- github copilot
  {
    'zbirenbaum/copilot.lua',
    lazy = false,
    version = false,
    event = { 'InsertEnter' },
    opts = {
      filetypes = {
        ['*'] = true,
      },
      panel = {
        auto_refresh = true,
      },
      server_opts_overrides = {},
    },
    keys = {
      {
        '<leader>cc',
        function()
          require('copilot.panel').open({ position = 'bottom', ratio = 0.4 })
        end,
        mode = 'n',
        desc = 'Open Copilot panel',
      },
    },
    config = true,
  },

  -- auto completion
  {
    'saghen/blink.cmp',
    version = '*',
    event = 'InsertEnter',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      signature = { enabled = true },
    },
  },

  -- surround
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = true,
  },

  -- comments
  { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },
  {
    'echasnovski/mini.comment',
    event = 'VeryLazy',
    opts = {
      hooks = {
        pre = function()
          require('ts_context_commentstring.internal').update_commentstring({})
        end,
      },
    },
    config = function(_, opts)
      require('mini.comment').setup(opts)
    end,
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
