local Util = require('config.util')

return {
  -- lspconfig
  {
    'neovim/nvim-lspconfig',
    branch = 'master',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'folke/neoconf.nvim',
        cmd = 'Neoconf',
        opts = {
          import = { vscode = false },
        },
        config = true,
      },
      { 'folke/neodev.nvim', opts = { experimental = { pathStrict = true } } },
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, source = 'if_many', prefix = '●' },
        severity_sort = true,
      },
      -- Automatically format on save
      autoformat = true,
      inlay_hints = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = false,
          },
        },
      },
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overriden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        terraformls = {},
        bashls = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be  lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- load vscode options if available
      if Util.has('neoconf.nvim') then
        local plugin = require('lazy.core.config').spec.plugins['neoconf.nvim']
        require('neoconf').setup(require('lazy.core.plugin').values(plugin, 'opts', false))
      end

      Util.on_attach(function(client, buffer)
        require('plugins.lsp.keymaps').on_attach(client, buffer)
      end)

      -- diagnostics
      for name, icon in pairs(require('config.icons').diagnostics) do
        name = 'DiagnosticSign' .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
      end

      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
      if opts.inlay_hints.enabled and inlay_hint then
        Util.on_attach(function(client, buffer)
          if client.server_capabilities.inlayHintProvider then
            inlay_hint(buffer, true)
          end
        end)
      end

      if type(opts.diagnostics.virtual_text) == 'table' and opts.diagnostics.virtual_text.prefix == 'icons' then
        opts.diagnostics.virtual_text.prefix = vim.fn.has('nvim-0.10.0') == 0 and '● '
          or function(diagnostic)
            local icons = require('config.icons').diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.serverity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(),
        opts.capabilities or {}
      )

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

  -- -- formatters
  -- {
  --   'nvimtools/none-ls.nvim',
  --   event = 'BufReadPre',
  --   dependencies = { 'mason.nvim' },
  --   opts = function()
  --     local nls = require('null-ls')
  --     return {
  --       sources = {
  --         nls.builtins.formatting.stylua.with({
  --           extra_args = { '--config-path', vim.fn.expand('~/.config/stylua/stylua.toml') },
  --         }),
  --
  --         nls.builtins.formatting.clang_format.with({
  --           filetypes = { 'c', 'cpp', 'proto' },
  --         }),
  --         nls.builtins.formatting.cmake_format,
  --
  --         nls.builtins.formatting.prettier.with({
  --           extra_args = { '--ignore-path', vim.fn.expand('~/.prettierignore') },
  --         }),
  --
  --         nls.builtins.formatting.goimports,
  --
  --         -- nls.builtins.formatting.buf,
  --         nls.builtins.diagnostics.buf,
  --
  --         nls.builtins.diagnostics.shellcheck,
  --
  --         nls.builtins.formatting.terraform_fmt,
  --
  --         nls.builtins.diagnostics.ruff,
  --         nls.builtins.formatting.ruff,
  --         -- nls.builtins.formatting.black,
  --
  --         nls.builtins.formatting.buildifier,
  --         nls.builtins.diagnostics.buildifier,
  --       },
  --     }
  --   end,
  -- },

  -- cmdline tools and lsp servers
  {

    'williamboman/mason.nvim',
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
