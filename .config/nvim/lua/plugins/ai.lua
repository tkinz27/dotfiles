local gemini_api_key = os.getenv('GOOGLE_AI_API_KEY')
local provider = gemini_api_key and 'gemini' or 'copilot'

return {
  {
    'ggml-org/llama.vim',
    lazy = false,
    event = { 'InsertEnter' },
    init = function()
      -- configure llama server as needed
    end,
  },
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
      suggestion = {
        enabled = false,
        auto_trigger = true,
      },
      panel = {
        enabled = false,
      },
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
        },
        cmd = {
          adapter = 'gemini_cli',
        },
      },
      adapters = {
        acp = {
          gemini_cli = function()
            return require('codecompanion.adapters').extend('gemini_cli', {
              defaults = {
                auth_method = '',
              },
              env = {},
            })
          end,
        },
      },
    },
  },
}
