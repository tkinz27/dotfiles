return {
  -- auto completion
  {
    'saghen/blink.cmp',
    version = '*',
    event = 'InsertEnter',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'giuxtaposition/blink-cmp-copilot',
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
        menu = {
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
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot', 'emoji', 'dictionary' },
        providers = {
          copilot = {
            name = 'Copilot',
            module = 'blink-cmp-copilot',
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = 'Copilot'
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            opts = { insert = true },
          },
          -- https://github.com/Kaiser-Yang/blink-cmp-dictionary
          -- In macOS to get started with a dictionary:
          -- cp /usr/share/dict/words ~/github/dotfiles-latest/dictionaries
          dictionary = {
            module = 'blink-cmp-dictionary',
            name = 'Dict',
            score_offset = 20, -- the higher the number, the higher the priority
            enabled = true,
            max_items = 8,
            min_keyword_length = 3,
            opts = {
              get_command = {
                'rg', -- make sure this command is available in your system
                '--color=never',
                '--no-line-number',
                '--no-messages',
                '--no-filename',
                '--ignore-case',
                '--',
                '${prefix}', -- this will be replaced by the result of 'get_prefix' function
                vim.fn.expand('/usr/share/dict/words'), -- where you dictionary is
              },
              documentation = {
                enable = true, -- enable documentation to show the definition of the word
                get_command = {
                  -- For the word definitions feature
                  -- make sure "wn" is available in your system
                  -- brew install wordnet
                  'wn',
                  '${word}', -- this will be replaced by the word to search
                  '-over',
                },
              },
            },
          },
        },
      },
    },
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
