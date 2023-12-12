return {
  {
    'nvim-neotest/neotest',
    version = '*',
    dependencies = {
      'nvim-neotest/neotest-go',
      'nvim-neotest/neotest-python',
    },
    keys = {
      {
        '<leader>ta',
        function()
          require('neotest').run.attach()
        end,
        desc = 'Run test andattach',
      },
      {
        '<leader>tf',
        function()
          require('neotest').run.run(vim.fn.expand('%'))
        end,
        desc = 'Run tests in file',
      },
      {
        '<leader>tr',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run the nearest test',
      },
      {
        '<leader>td',
        function()
          require('neotest').run.run({ strategy = 'dap' })
        end,
        desc = 'Run the test with debugger',
      },
      {
        '<leader>to',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = 'Open test logs',
      },
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace('neotest')
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      require('neotest').setup({
        adapters = {
          require('neotest-python'),
          require('neotest-go')({
            experimental = {
              test_table = true,
            },
            args = { '-count=1', '-v' },
          }),
        },
      })
    end,
  },
}
