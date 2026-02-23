return {
  {
    'ggml-org/llama.vim',
    lazy = false,
    event = { 'InsertEnter' },
    init = function()
      -- configure llama server as needed
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
        '<C-a>',
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
      strategies = {
        chat = {
          adapter = 'gemini_cli',
        },
        inline = {
          adapter = 'gemini_cli',
          keymaps = {
            accept_change = {
              modes = { n = 'ga' },
              description = 'Accept the suggested change',
            },
            reject_change = {
              modes = { n = 'gr' },
              opts = { nowait = true },
              description = 'Reject the suggested change',
            },
          },
        },
        cmd = {
          adapter = 'gemini_cli',
        },
      },
      adapters = {
        gemini_cli = function()
          return require('codecompanion.adapters').extend('gemini_cli', {
            defaults = {
              auth_method = 'vertex-ai',
            },
            env = {},
          })
        end,
      },
    },
  },
}
