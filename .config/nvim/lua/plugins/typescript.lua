local tsgo_cmd = vim.fn.stdpath('data') .. '/typescript-native-preview/node_modules/.bin/tsgo'

local function root_dir(bufnr, on_dir)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local root = vim.fs.root(name, {
    'tsconfig.json',
    'jsconfig.json',
    'package.json',
    '.git',
  })

  if root then
    on_dir(root)
  end
end

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
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        ['javascript'] = { 'prettier' },
        ['javascriptreact'] = { 'prettier' },
        ['typescript'] = { 'prettier' },
        ['typescriptreact'] = { 'prettier' },
        ['vue'] = { 'prettier' },
        ['css'] = { 'prettier' },
        ['scss'] = { 'prettier' },
        ['less'] = { 'prettier' },
        ['html'] = { 'prettier' },
        ['json'] = { 'prettier' },
        ['jsonc'] = { 'prettier' },
        ['yaml'] = { 'prettier' },
        ['markdown'] = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
        ['graphql'] = { 'prettier' },
        ['handlebars'] = { 'prettier' },
      },
    },
  },

  -- correctly setup lspconfig
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tsgo = {
          mason = false,
          cmd = { tsgo_cmd, '--lsp', '--stdio' },
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
          root_dir = root_dir,
        },
      },
    },
  },
}
