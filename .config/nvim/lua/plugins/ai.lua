return {
  {
    'ggml-org/llama.vim',
    lazy = false,
    event = { 'InsertEnter' },
    init = function()
      vim.g.llama_config = vim.tbl_deep_extend('force', vim.g.llama_config or {}, {
        enable_at_startup = false,
      })
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      {
        '<leader>aa',
        '<cmd>CodeCompanionActions<cr>',
        mode = { 'n', 'v' },
        desc = 'CodeCompanionActions',
      },
      {
        '<leader>a',
        '<cmd>CodeCompanionChat Toggle<cr>',
        mode = { 'n', 'v' },
        desc = 'CodeCompanionChat Toggle',
      },
      {
        'ga',
        '<cmd>CodeCompanionChat Add<cr>',
        mode = { 'v' },
        desc = 'CodeCompanionChat Add',
      },
    },
    opts = {
      interactions = {
        chat = {
          adapter = 'codex',
        },
      },
      adapters = {
        acp = {
          codex = function()
            return require('codecompanion.adapters').extend('codex', {
              defaults = {
                auth_method = 'chat-gpt',
              },
              env = {},
            })
          end,
        },
      },
    },
  },
  {
    'mason-org/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'codex-acp' })
    end,
  },
}
