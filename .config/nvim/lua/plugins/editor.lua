local Util = require('config.util')

return {
  -- file explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = 'Neotree',
    keys = {
      {
        '<leader>e',
        function()
          require('neo-tree.command').execute({ toggle = true, dir = require('config.util').get_root() })
        end,
        desc = 'Explorer NeoTree (root dir)',
      },
      { '<leader>E', '<cmd>Neotree toggle<CR>', desc = 'Explorer NeoTree (cwd)' },
      {
        '<leader>eg',
        function()
          require('neo-tree.command').execute({ source = 'git_status', toggle = true })
        end,
        desc = 'Git Explorer',
      },
      {
        '<leader>eb',
        function()
          require('neo-tree.command').execute({ source = 'buffers', toggle = true })
        end,
        desc = 'Buffer Explorer',
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require('neo-tree')
        end
      end
    end,
    opts = {
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
      },
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)
      vim.api.nvim_create_autocmd('TermClose', {
        pattern = '*lazygit',
        callback = function()
          if package.loaded['neo-tree.sources.git_status'] then
            require('neo-tree.sources.git_status').refresh()
          end
        end,
      })
    end,
  },

  -- search/replace in multiple files
  {
    'MagicDuck/grug-far.nvim',
    opts = { headerMaxWidth = 80 },
    cmd = 'GrugFar',
    keys = {
      {
        '<leader>sr',
        function()
          local grug = require('grug-far')
          local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
            },
          })
        end,
        mode = { 'n', 'v' },
        desc = 'Search and Replace',
      },
    },
  },

  -- easily jump to any location and enhanced f/t motions for Leap
  {
    'ggandor/leap.nvim',
    event = 'VeryLazy',
    dependencies = { { 'ggandor/flit.nvim', opts = { labeled_modes = 'nv' } } },
    config = function(_, opts)
      local leap = require('leap')
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
    end,
  },

  -- which-key
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts_extend = { 'spec' },
    opts = {
      spec = {
        {
          mode = { 'n', 'v' },
          { '<leader><tab>', group = 'tabs' },
          { '<leader>c', group = 'code' },
          { '<leader>f', group = 'file/find' },
          { '<leader>g', group = 'git' },
          { '<leader>gh', group = 'hunks' },
          { '<leader>q', group = 'quit/session' },
          { '<leader>s', group = 'search' },
          { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
          { '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
          { '[', group = 'prev' },
          { ']', group = 'next' },
          { 'g', group = 'goto' },
          { 'gs', group = 'surround' },
          { 'z', group = 'fold' },
          {
            '<leader>b',
            group = 'buffer',
            expand = function()
              return require('which-key.extras').expand.buf()
            end,
          },
          {
            '<leader>w',
            group = 'windows',
            proxy = '<c-w>',
            expand = function()
              return require('which-key.extras').expand.win()
            end,
          },
          -- better descriptions
          { 'gx', desc = 'Open with system app' },
        },
      },
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Keymaps (which-key)',
      },
      {
        '<c-w><space>',
        function()
          require('which-key').show({ kyes = '<c-w>', loop = true })
        end,
        desc = 'Window Hydra Mode (which-key)',
      },
    },
  },

  -- git signs
  {
    'lewis6991/gitsigns.nvim',
    branch = 'main',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      current_line_blame = true,
      current_line_blame_opts = { delay = 1000, virt_text_priority = 100, virt_text = true, virt_text_pos = 'eol' },
      debug_mode = true,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame")
        map("n", "<leader>ghB", gs.toggle_current_line_blame, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewToggleFiles' },
  },

  -- better diagnostics list and others
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    opts = {
      modes = {
        lsp = {
          win = { position = 'right' },
        },
      },
    },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cS', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP references/definitions/... (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous Trouble/Quickfix Item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Next Trouble/Quickfix Item',
      },
    },
  },

  -- todo comments
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",          function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",          function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt",  "<cmd>TodoTrouble<cr>",                              desc = "Todo Trouble" },
      { "<leader>xtt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo Trouble" },
      { "<leader>xT",  "<cmd>TodoTelescope<cr>",                            desc = "Todo Telescope" },
    },
  },
}
