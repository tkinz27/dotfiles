return {
  {
    'esmuellert/codediff.nvim',
    cmd = { 'CodeDiff' },
    opts = {
      explorer = {
        view_mode = 'tree',
      },
      history = {
        view_mode = 'tree',
      },
    },
  },

  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    opts = {},
  },
  {
    'Almo7aya/openingh.nvim',
    keys = {
      { '<leader>gf', ':OpenInGHFile <CR>', desc = 'Open file in GitHub.' },
      { '<leader>gf', ':OpenInGHFileLines <CR>', mode = 'v', desc = 'Open file range in GitHub' },
    },
  },
}
