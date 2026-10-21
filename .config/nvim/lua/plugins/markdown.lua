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
          max_height_window_percentage = 75,
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
          scale = 2,
          cli_args = {
            '-p', vim.fn.expand('~/.config/mmdc/puppeteer-config.json'),
            '--size', '1200',
          },
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
