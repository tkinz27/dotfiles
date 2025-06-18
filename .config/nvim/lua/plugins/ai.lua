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
    'azorng/goose.nvim',
    event = 'VeryLazy',
    lazy = false,
    keys = {
      {
        '<leader>GG',
        function()
          require('goose.api').toggle()
        end,
        desc = 'Toggle Goose',
      },
      {
        '<leader>Gi',
        function()
          require('goose.api').open_input()
        end,
        desc = 'Goose open',
      },
      {
        '<leader>GI',
        function()
          require('goose.api').open_input_new_session()
        end,
        desc = 'Goose open new with new session',
      },
      {
        '<leader>Gt',
        function()
          require('goose.api').toggle_focus()
        end,
        desc = 'Goose toggle focus',
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          anti_conceal = { enabled = false },
        },
      },
      opts = {},
      config = function(_, opts)
        require('goose').setup(opts)
      end,
    },
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    enabled = false,
    opts = {
      provider = 'gemini',
      gemini = {
        model = 'gemini-2.0-flash-thinking-exp-01-21',
      },
      vendors = {
        ---@type AvanteProvider
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua',
    },
  },
}
