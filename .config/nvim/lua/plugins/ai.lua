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
      },
      panel = {
        enabled = false,
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
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = 'gemini',
      gemini = {
        model = 'gemini-2.0-flash-exp',
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
