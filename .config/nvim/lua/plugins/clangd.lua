return {

  -- add c/c++ to treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'c', 'cpp' })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'p00f/clangd_extensions.nvim',
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        clangd = {
          filetypes = { 'c', 'cpp' },
        },
      },
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { 'utf-16' }
          require('clangd_extensions').setup({
            server = opts,
            extensions = {
              ast = {
                --These require codicons (https://github.com/microsoft/vscode-codicons)
                role_icons = {
                  type = '',
                  declaration = '',
                  expression = '',
                  specifier = '',
                  statement = '',
                  ['template argument'] = '',
                },

                kind_icons = {
                  Compound = '',
                  Recovery = '',
                  TranslationUnit = '',
                  PackExpansion = '',
                  TemplateTypeParm = '',
                  TemplateTemplateParm = '',
                  TemplateParamObject = '',
                },
              },
            },
          })
          return true
        end,
      },
    },
  },
}
