local ensure_installed = {
  'bash',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'gotmpl',
  'helm',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'nickel',
  'python',
  'query',
  'regex',
  'rust',
  'sql',
  'tsx',
  'typescript',
  'vim',
  'yaml',
}

local function start_treesitter(args)
  if vim.bo[args.buf].buftype ~= '' then
    return
  end

  local filetype = vim.bo[args.buf].filetype
  local lang = vim.treesitter.language.get_lang(filetype)
  if not lang then
    return
  end

  local ok, loaded = pcall(vim.treesitter.language.add, lang)
  if ok and loaded then
    pcall(vim.treesitter.start, args.buf, lang)
  end
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Shrink selection', mode = 'x' },
    },
    ---@type TSConfig
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      install_dir = vim.fn.stdpath('data') .. '/site',
      ensure_installed = ensure_installed,
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user_treesitter', { clear = true }),
        pattern = '*',
        callback = start_treesitter,
      })
    end,
    config = function(_, opts)
      local ts = require('nvim-treesitter')

      -- The new nvim-treesitter on 'main' branch exports setup() from the top-level.
      -- Fallback to 'nvim-treesitter.configs' for compatibility if needed.
      local setup = ts.setup or require('nvim-treesitter.configs').setup
      setup(opts)

      -- Automatic installation of parsers if on 'main' branch
      if ts.setup then
        local installed = require('nvim-treesitter.config').get_installed()
        local missing = vim.tbl_filter(function(p)
          return not vim.tbl_contains(installed, p)
        end, opts.ensure_installed)

        if #missing > 0 then
          ts.install(missing)
        end
      end
    end,
  },
}
