return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'ninja', 'python', 'rst', 'toml' })
      end
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        ['python'] = function(bufnr)
          local absolute_filepath = vim.fn.expand('#' .. bufnr .. ':p')
          if absolute_filepath:find('shining_software', 1, true) then
            vim.notify('Disabling autoformat for shining_software project', vim.log.levels.WARN)
            vim.b.disable_autoformat = true
            return {}
          end
          return { 'ruff_organize_imports', 'ruff_format' }
        end,
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    keys = {
      {
        '<leader>co',
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { 'source.organizeImports' },
              diagnostics = {},
            },
          })
        end,
        desc = 'Organize Imports',
        ft = 'python',
      },
    },
    opts = {
      servers = {
        ty = {},
        ruff = {},
      },
    },
  },
  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      'nvim-neotest/neotest-python',
    },
    opts = {
      adapters = {
        ['neotest-python'] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },
  {
    'linux-cultist/venv-selector.nvim',
    cmd = 'VenvSelect',
    opts = function(_, opts)
      if require('config.util').has('nvim-dap-python') then
        opts.dap_enabled = true
      end
      return vim.tbl_deep_extend('force', opts, {
        name = {
          'venv',
          '.venv',
          'env',
          '.env',
        },
      })
    end,
    keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv' } },
  },
}
