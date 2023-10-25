return {

  -- add typescript to treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'typescript', 'tsx' })
      end
    end,
  },

  -- formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "prettier" },
        ["javascriptreact"] = { "prettier" },
        ["typescript"] = { "prettier" },
        ["typescriptreact"] = { "prettier" },
        ["vue"] = { "prettier" },
        ["css"] = { "prettier" },
        ["scss"] = { "prettier" },
        ["less"] = { "prettier" },
        ["html"] = { "prettier" },
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
        ["yaml"] = { "prettier" },
        ["markdown"] = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        ["graphql"] = { "prettier" },
        ["handlebars"] = { "prettier" },
      },
    },
  },

  -- correctly setup lspconfig
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'jose-elias-alvarez/typescript.nvim' },
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {},
      },
      setup = {
        tsserver = function(_, opts)
          require('config.util').on_attach(function(client, buffer)
            if client.name == 'tsserver' then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports",
                { buffer = buffer, desc = "Organize Imports" })
              vim.keymap.set('n', '<leader>cR', 'TypescriptRenameFile', { desc = 'Rename File', buffer = buffer })
            end
          end)
          require('typescript').setup({ server = opts })
          return true
        end,
      },
    },
  },
}
