return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        gopls = {
          cmd = { 'gopls', '-v', '-rpc.trace', '-logfile=/tmp/gopls.log' },
          settings = {
            gopls = {
              buildFlags = { '-tags=unit,lz4' },
              directoryFilters = {
                '-build',
                '-bazel-bin',
                '-bazel-out',
                '-bazel-testlogs',
              },
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              analyses = {
                unusedParams = true,
                ST1003 = false,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              semanticTokens = true,
            },
          },
        },
      },
      setup = {
        gopls = function(_, _)
          -- workaround for gopls not support semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          require('config.util').on_attach(function(client, _)
            if client.name == 'gopls' then
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenType = semantic.tokenType,
                    tokenModifies = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
          -- still call lspconfig.gopls.setup
          return false
        end,
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        go = { 'goimports', 'gofmt' },
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    optional = true,
    dependencies = {
      {
        'mason.nvim',
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, 'delve')
        end,
      },
    },
  },
}
