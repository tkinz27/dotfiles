return {
  {
    'esmuellert/codediff.nvim',
    cmd = { 'CodeDiff' },
    opts = {
      diff = {
        layout = 'inline',
      },
      explorer = {
        view_mode = 'tree',
      },
      history = {
        view_mode = 'tree',
      },
    },
  },

  {
    'georgeguimaraes/review.nvim',
    version = '*',
    dependencies = {
      'esmuellert/codediff.nvim',
      'MunifTanjim/nui.nvim',
    },
    cmd = { 'Review' },
    keys = {
      { '<leader>r', '<cmd>Review<cr>', desc = 'Review changes' },
      { '<leader>R', '<cmd>Review commits<cr>', desc = 'Review commits' },
    },
    opts = {},
    build = function(plugin)
      local patch = vim.fn.stdpath('config') .. '/patches/review.nvim-pathref-compat.patch'
      if vim.fn.filereadable(patch) ~= 1 then
        return
      end

      vim.fn.system({ 'git', '-C', plugin.dir, 'apply', '--check', patch })
      if vim.v.shell_error == 0 then
        vim.fn.system({ 'git', '-C', plugin.dir, 'apply', patch })
      end
    end,
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
