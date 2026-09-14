return {
  -- Add Rust & related to treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'ron', 'rust', 'toml' })
      end
    end,
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- Ensure mason installs the server
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust.
              checkOnSave = true,
              check = {
                command = 'clippy',
                extraArgs = { '--no-deps' },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ['napi-derive'] = { 'napi' },
                  ['async-recursion'] = { 'async_recursion' },
                },
              },
              -- Avoid stale unresolvedReference tokens after cache priming.
              semanticHighlighting = {
                nonStandardTokens = false,
              },
            },
          },
        },
        tombi = {},
      },
    },
  },

  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      'rouge8/neotest-rust',
    },
    opts = {
      adapters = {
        ['neotest-rust'] = {},
      },
    },
  },
}
