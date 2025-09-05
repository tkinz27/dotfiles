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
          theme = 'dark',
        },
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
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
