return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        buf_ls = {},
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        proto = { 'clang_format' },
      },
    },
  },
}
