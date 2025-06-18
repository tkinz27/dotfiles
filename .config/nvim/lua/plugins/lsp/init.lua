local icons = require('config.icons')
local Util = require('config.util')

return {
  -- lspconfig
  {
    'neovim/nvim-lspconfig',
    branch = 'master',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_lines = { current_line = true },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
          },
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = { 'vue' },
      },

      codelens = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
          -- didChangeWatchedFiles = {
          --   dynamicRegistration = false,
          -- },
        },
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        terraformls = {},
        bashls = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be  lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {},
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      Util.lsp.on_attach(function(client, buffer)
        require('plugins.lsp.keymaps').on_attach(client, buffer)
      end)

      -- inlay hints
      if opts.inlay_hints.enabled then
        Util.lsp.on_supports_method('textDocument/inlayHint', function(client, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ''
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        Util.lsp.on_supports_method('textDocument/codeLens', function(client, buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local capabilities =
        vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), opts.capabilities or {})

      local function setup(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup['*'] then
          if opts.setup['*'](server, server_opts) then
            return
          end
        end
        require('lspconfig')[server].setup(server_opts)
      end

      local mlsp = require('mason-lspconfig')
      local all_mslp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
    end,
  },

  -- cmdline tools and lsp servers
  { 'mason-org/mason-lspconfig.nvim', version = '^1.0.0' },
  {

    'mason-org/mason.nvim',
    version = '^1.0.0',
    cmd = 'Mason',
    keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
    build = ':MasonUpdate',
    opts = {
      ensure_installed = {
        -- python
        'ruff',
        'debugpy',
        -- golang
        'delve',
        'gomodifytags',
        'goimports',
        -- lua
        'stylua',
        -- sh
        'shellcheck',
        'shellharden',
        -- typescript/javascript
        'prettier',
        -- others
        'buildifier',
        'commitlint',
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')
      mr:on('package:install:success', function()
        vim.defer_fn(function()
          require('lazy.core.handler.event').trigger({
            event = 'FileType',
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
