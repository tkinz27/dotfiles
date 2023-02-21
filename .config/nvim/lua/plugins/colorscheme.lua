return {
  {
    'folke/tokyonight.nvim',
    opts = {
      style = 'moon',
      transparent = true,
    },
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
}
