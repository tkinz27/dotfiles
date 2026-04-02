return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Shrink selection', mode = 'x' },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        'bash',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'nickel',
        'python',
        'query',
        'regex',
        'rust',
        'sql',
        'tsx',
        'typescript',
        'vim',
        'yaml',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      local ts = require('nvim-treesitter')

      -- The new nvim-treesitter on 'main' branch exports setup() from the top-level.
      -- Fallback to 'nvim-treesitter.configs' for compatibility if needed.
      local setup = ts.setup or require('nvim-treesitter.configs').setup
      setup(opts)

      -- Automatic installation of parsers if on 'main' branch
      if ts.setup and opts.ensure_installed then
        local installed = require('nvim-treesitter.config').get_installed()
        local missing = vim.tbl_filter(function(p)
          return not vim.tbl_contains(installed, p)
        end, opts.ensure_installed)

        if #missing > 0 then
          ts.install(missing)
        end
      end
    end,
  },
}
