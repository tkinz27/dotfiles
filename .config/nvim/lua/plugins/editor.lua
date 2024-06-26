local Util = require('config.util')

return {
  -- file explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    keys = {
      {
        '<leader>fe',
        function()
          require('neo-tree.command').execute({ toggle = true, dir = require('config.util').get_root() })
        end,
        desc = 'Explorer NeoTree (root dir)',
      },
      { '<leader>fE', '<cmd>Neotree toggle<CR>', desc = 'Explorer NeoTree (cwd)' },
      { '<leader>e',  '<leader>fe',              desc = 'Explorer NeoTree (root dir)', remap = true },
      { '<leader>E',  '<leader>fE',              desc = 'Explorer NeoTree (cwd)',      remap = true },
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
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'Outline' },
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
        icon = {
          folder_empty = '󰜌',
          folder_empty_open = '󰜌',
        },
        git_status = {
          symbols = {
            renamed = '󰁕',
            unstaged = '󰄱',
          },
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
    'windwp/nvim-spectre',
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false, -- telescope did only one release, so use HEAD for now
    keys = {
      { '<leader>erc',     Util.telescope('find_files', { cwd = '~/.config/nvim' }), desc = 'Edit configuration' },
      { '<leader>,',       '<cmd>Telescope buffers show_all_buffers=true<cr>',       desc = 'Switch Buffer' },
      { '<leader>/',       Util.telescope('live_grep'),                              desc = 'Find in Files (Grep)' },
      { '<leader>:',       '<cmd>Telescope command_history<cr>',                     desc = 'Command History' },
      { '<leader><space>', Util.telescope('find_files'),                             desc = 'Find Files (root dir)' },
      { '<leader>fF',      Util.telescope('find_files', { cwd = false }),            desc = 'Find Files (cwd)' },
      { '<leader>fb',      '<cmd>Telescope buffers<cr>',                             desc = 'Buffers' },
      { '<leader>ff',      Util.telescope('find_files'),                             desc = 'Find Files (root dir)' },
      { '<leader>fr',      '<cmd>Telescope oldfiles<cr>',                            desc = 'Recent' },
      { '<leader>gc',      '<cmd>Telescope git_commits<CR>',                         desc = 'commits' },
      { '<leader>gs',      '<cmd>Telescope git_status<CR>',                          desc = 'status' },
      { '<leader>sC',      '<cmd>Telescope commands<cr>',                            desc = 'Commands' },
      { '<leader>sG',      Util.telescope('live_grep', { cwd = false }),             desc = 'Grep (cwd)' },
      { '<leader>sM',      '<cmd>Telescope man_pages<cr>',                           desc = 'Man Pages' },
      { '<leader>sa',      '<cmd>Telescope autocommands<cr>',                        desc = 'Auto Commands' },
      { '<leader>sb',      '<cmd>Telescope current_buffer_fuzzy_find<cr>',           desc = 'Buffer' },
      { '<leader>sc',      '<cmd>Telescope command_history<cr>',                     desc = 'Command History' },
      { '<leader>sg',      Util.telescope('live_grep'),                              desc = 'Grep (root dir)' },
      { '<leader>sh',      '<cmd>Telescope help_tags<cr>',                           desc = 'Help Pages' },
      { '<leader>sH',      '<cmd>Telescope highlights<cr>',                          desc = 'Search Highlight Groups' },
      { '<leader>sk',      '<cmd>Telescope keymaps<cr>',                             desc = 'Key Maps' },
      { '<leader>sm',      '<cmd>Telescope marks<cr>',                               desc = 'Jump to Mark' },
      { '<leader>so',      '<cmd>Telescope vim_options<cr>',                         desc = 'Options' },
      { '<leader>st',      '<cmd>Telescope builtin<cr>',                             desc = 'Telescope' },
      { '<leader>sw',      '<cmd>Telescope grep_string<cr>',                         desc = 'Grep word' },
      {
        '<leader>ss',
        Util.telescope('lsp_document_symbols', {
          symbols = {
            'Class',
            'Function',
            'Method',
            'Constructor',
            'Interface',
            'Module',
            'Struct',
            'Trait',
            'Field',
            'Property',
          },
        }),
        desc = 'Goto Symbol',
      },
    },
    opts = {
      defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
        mappings = {
          i = {
            ['<c-r>'] = function(...)
              return require('trouble.providers.telescope').open_with_trouble(...)
            end,
            ['<C-i>'] = function()
              Util.telescope('find_files', { no_ignore = true })()
            end,
            ['<C-h>'] = function()
              Util.telescope('find_files', { hidden = true })()
            end,
            ['<C-Down>'] = function(...)
              return require('telescope.actions').cycle_history_next(...)
            end,
            ['<C-Up>'] = function(...)
              return require('telescope.actions').cycle_history_prev(...)
            end,
            ['<c-j>'] = function(...)
              return require('telescope.actions').move_selection_next(...)
            end,
            ['<c-k>'] = function(...)
              return require('telescope.actions').move_selection_previous(...)
            end,
            ['<c-n>'] = function(...)
              return require('telescope.actions').preview_scrolling_down(...)
            end,
            ['<c-p>'] = function(...)
              return require('telescope.actions').preview_scrolling_up(...)
            end,
          },
        },
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
    opts = {
      plugins = { spelling = true },
      key_labels = { ['<leader>'] = 'SPC' },
    },
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
      wk.register({
        mode = { 'n', 'v' },
        ['g'] = { name = '+goto' },
        [']'] = { name = '+next' },
        ['['] = { name = '+prev' },
        ['<leader><tab>'] = { name = '+tabs' },
        ['<leader>b'] = { name = '+buffer' },
        ['<leader>c'] = { name = '+code' },
        ['<leader>f'] = { name = '+file/find' },
        ['<leader>g'] = { name = '+git' },
        ['<leader>gh'] = { name = '+hunks' },
        ['<leader>q'] = { name = '+quit/session' },
        ['<leader>s'] = { name = '+search' },
        ['<leader>sn'] = { name = '+noice' },
        ['<leader>u'] = { name = '+ui' },
        ['<leader>w'] = { name = '+windows' },
        ['<leader>x'] = { name = '+diagnostics/quickfix' },
      })
    end,
  },

  -- git signs
  {
    'lewis6991/gitsigns.nvim',
    branch = 'main',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
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

  -- references
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { delay = 200 },
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
    -- stylua: ignore
    keys = {
      { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
      { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
    },
  },

  -- better diagnostics list and others
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
    keys = {
      { '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>',  desc = 'Document Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
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
