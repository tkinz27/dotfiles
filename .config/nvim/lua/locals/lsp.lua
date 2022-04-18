local lspconfig = require('lspconfig')

-- diagnostic config
-- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = { spacing = 4, prefix = '■' },
--   signs = true,
--   update_in_insert = false,
-- })

-- signs
vim.fn.sign_define('LspDiagnosticsErrorSign', { text = '✗', texthl = 'LspDiagnosticsError' })
vim.fn.sign_define('LspDiagnosticsWarningSign', { text = '⚠', texthl = 'LspDiagnosticsWarning' })
vim.fn.sign_define('LspDiagnosticsInformationSign', { text = 'ⓘ', texthl = 'LspDiagnosticsInformation' })
vim.fn.sign_define('LspDiagnosticsHintSign', { text = '✓', texthl = 'LspDiagnosticsHint' })

-- completion config
local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
  }, {
    { name = 'path' },
    -- { name = 'treesitter' },
    { name = 'emoji' },
    { name = 'nvim_lua' },
    { name = 'buffer', keyword_length = 5 },
  }),
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol_text',
      menu = {
        nvim_lsp = '[lsp]',
        luasnip = '[snip]',
        path = '[path]',
        treesitter = '[tree]',
        emoji = '[emoji]',
        nvim_lua = '[vimapi]',
        buffer = '[buf]',
      },
    }),
  },
  experimental = {
    ghost_text = true,
  },
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp-git' },
  }, {
    { name = 'buffer' },
  }),
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
      { name = 'nvim_lsp_document_symbol' },
  }, {
    { name = 'buffer' },
  }),
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities = require('cmp_nvim_lsp').update_capabilities(updated_capabilities)

local _attach = function(client, bufnr)
  local ts = require('telescope.builtin')
  vim.keymap.set('n', 'ca', ts.lsp_code_actions, { buffer = bufnr })
  vim.keymap.set('v', 'ca', ts.lsp_range_code_actions, { buffer = bufnr })
  vim.keymap.set('n', 'go', ts.lsp_document_symbols, { buffer = bufnr })
  vim.keymap.set('n', 'gw', ts.lsp_workspace_symbols, { buffer = bufnr })
  vim.keymap.set('n', 'gr', ts.lsp_references, { buffer = bufnr })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set('n', '<c-K>', vim.lsp.buf.signature_help, { buffer = bufnr })
  vim.keymap.set('i', '<c-K>', vim.lsp.buf.signature_help, { buffer = bufnr })

  vim.keymap.set('n', 'dn', vim.diagnostic.goto_next, { buffer = bufnr })
  vim.keymap.set('n', 'dp', vim.diagnostic.goto_prev, { buffer = bufnr })

  vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])

  -- Set autocommands conditional on server capabilities
  if client.resolved_capabilities.document_highlight then
    vim.cmd([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]])
  end

  if client.resolved_capabilities.document_formatting then
    vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]])
  end
end

local lsps = {
  'bashls',
  'terraformls',
  -- 'cmake',
  'html',
  'cssls',
}
for _, s in ipairs(lsps) do
  lspconfig[s].setup({
    on_attach = _attach,
    capabilities = updated_capabilities,
  })
end

------------------------------------------------------------
-- null-ls - miscelaneous
------------------------------------------------------------
local null_ls = require('null-ls')
null_ls.setup({
  on_attach = _attach,
  sources = {
    null_ls.builtins.formatting.stylua.with({
      extra_args = { '--config-path', vim.fn.expand('~/.config/stylua/stylua.toml') },
    }),
    null_ls.builtins.formatting.clang_format.with({
      filetypes = { 'c', 'cpp', 'proto' },
    }),
    null_ls.builtins.formatting.cmake_format,
    null_ls.builtins.formatting.prettier.with({
      extra_args = { '--ignore-path', vim.fn.expand('~/.prettierignore') },
    }),
  },
})
------------------------------------------------------------
-- golang
------------------------------------------------------------
-- TODO check if we are in a bazel workspace and envvar
-- "GOPACKAGESDRIVER": "${workspaceFolder}/tools/gopackagesdriver.sh"
-- where gopackagesdriver == `exec bazel run -- @io_bazel_rules_go//go/tools/gopackagesdriver "${@}"`
lspconfig.gopls.setup({
  cmd = { 'gopls', '-vv', '-rpc.trace', '-logfile', '/tmp/gopls.log' },
  settings = {
    gopls = {
      buildFlags = { '-tags=unit' },
      analyses = {
        unusedParams = true,
        ST1003 = false,
      },
      directoryFilters = {
        '-build',
        '-bazel-bin',
        '-bazel-out',
        '-bazel-testlogs',
      },
      staticcheck = true,
      usePlaceholders = true,
      experimentalWorkspaceModule = false,
      experimentalPostfixCompletions = true,
    },
  },
  on_attach = _attach,
  capabilities = updated_capabilities,
})

function GoImports(timeoutms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { 'source.organizeImports' } }

  local method = 'textDocument/codeAction'
  local result = vim.lsp.buf_request_sync(0, method, params, timeoutms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, 'utf-8')
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end

  vim.lsp.buf.formatting_sync(nil, timeoutms)
end
vim.api.nvim_command('au BufWritePre *.go lua GoImports(10000)')

------------------------------------------------------------
-- tsserver
------------------------------------------------------------
lspconfig.tsserver.setup({
  init_options = require('nvim-lsp-ts-utils').init_options,
  on_attach = function(client, bufnr)
    local ts_utils = require('nvim-lsp-ts-utils')
    ts_utils.setup({
      eslint_bin = 'eslint_d',
      -- eslint_enable_diagnostics = true,
      -- eslint_enable_code_actions = true,
      -- enable_import_on_completion = true,
      formatter = 'prettier',
    })
    ts_utils.setup_client(client)
    _attach(client, bufnr)

    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end,
  capabilities = updated_capabilities,
})

lspconfig.jsonls.setup({
  on_attach = _attach,
  capabilities = updated_capabilities,
  settings = {
    schemas = require('schemastore').json.schemas(),
  },
})

lspconfig.yamlls.setup({
  on_attach = _attach,
  capabilities = updated_capabilities,
})
------------------------------------------------------------
-- python
------------------------------------------------------------
lspconfig.pyright.setup({
  on_attach = _attach,
  capabilities = updated_capabilities,
})

------------------------------------------------------------
-- lua
------------------------------------------------------------
local system_name
if vim.fn.has('mac') == 1 then
  system_name = 'macOS'
elseif vim.fn.has('unix') == 1 then
  system_name = 'Linux'
else
  print('Unsupported system for sumneko')
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local sumneko_root_path = vim.fn.expand('~/code/github.com/sumneko/lua-language-server')
local sumneko_binary = sumneko_root_path .. '/bin/' .. system_name .. '/lua-language-server'

lspconfig.sumneko_lua.setup({
  cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = _attach,
  capabilities = updated_capabilities,
})

------------------------------------------------------------
-- rust
------------------------------------------------------------
lspconfig.rust_analyzer.setup({
  on_attach = _attach,
  capabilities = updated_capabilities,
  settings = {
    ['rust-analyzer'] = {
      assist = {
        importMergeBehavior = 'last',
        importPrefix = 'by_self',
      },
      cargo = {
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
})
