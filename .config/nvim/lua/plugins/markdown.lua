return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
  {
    '3rd/diagram.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      {
        '3rd/image.nvim',
        opts = {
          integrations = {
            markdown = {
              enabled = true,
              download_remote_images = true,
            },
          },
        },
      },
    },
    opts = {
      renderer_options = {
        mermaid = {
          background = 'transparent',
          theme = 'dark',
          cli_args = { '-p', vim.fn.expand('~/.config/mmdc/puppeteer-config.json') },
        },
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      code = {
        sign = false,
        width = 'block',
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
    },
    ft = { 'markdown', 'norg', 'rmd', 'org', 'Avante' },
    cmd = { 'RenderMarkdown' },
  },
}
