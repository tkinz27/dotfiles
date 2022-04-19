local lspconfig = require('lspconfig')

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
    ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jumpable()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
    { name = 'nvim_lua' },
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

vim.keymap.set('n', 'dn', vim.diagnostic.goto_next)
vim.keymap.set('n', 'dp', vim.diagnostic.goto_prev)
vim.keymap.set('n', 'dq', vim.diagnostic.setloclist)
vim.keymap.set('n', 'de', vim.diagnostic.open_float)

local on_attach = function(client, bufnr)
  local ts = require('telescope.builtin')
  vim.keymap.set('n', 'ca', ts.lsp_code_actions, { buffer = bufnr, desc = 'Find LSP Code Actions' })
  vim.keymap.set('v', 'ca', ts.lsp_range_code_actions, { buffer = bufnr, desc = 'Find LSP Code Actions [range]' })
  vim.keymap.set('n', 'go', ts.lsp_document_symbols, { buffer = bufnr, desc = 'Find LSP Document Symbols' })
  vim.keymap.set('n', 'gw', ts.lsp_workspace_symbols, { buffer = bufnr, desc = 'Find LSP Workspace Symbols' })
  vim.keymap.set('n', 'gr', ts.lsp_references, { buffer = bufnr, desc = 'Find LSP References' })
  vim.keymap.set('n', 'gi', ts.lsp_implementations, { buffer = bufnr, desc = 'Find LSP Implementations' })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Goto LSP Definition' })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Goto LSP Declaration' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Show LSP Hover' })
  vim.keymap.set('n', '<c-K>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Show LSP Signature Help' })
  vim.keymap.set('i', '<c-K>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Show LSP Signature Help' })

  -- Set autocommands conditional on server capabilities
  if client.server_capabilities.documentHighlightProvider then
    local lsp_doc_highlight = vim.api.nvim_create_augroup('LSPDocumentHighlight', {})
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = lsp_doc_highlight })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = bufnr,
      group = lsp_doc_highlight,
      desc = 'LSP Document Highlight',
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      buffer = bufnr,
      group = lsp_doc_highlight,
      desc = 'LSP Document Highlight Clear',
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.notify('Formatting enabled for ' .. client.name, 'info')
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      desc = 'LSP format on write',
      callback = function()
        local util = require('vim.lsp.util')
        local params = util.make_formatting_params({})
        client.request_sync('textDocument/formatting', params, 10000, bufnr)
      end,
    })
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
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

------------------------------------------------------------
-- null-ls - miscelaneous
------------------------------------------------------------
local null_ls = require('null-ls')
null_ls.setup({
  on_attach = on_attach,
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
  on_attach = on_attach,
  capabilities = capabilities,
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

    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
})

lspconfig.jsonls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    schemas = require('schemastore').json.schemas(),
  },
})

lspconfig.yamlls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
------------------------------------------------------------
-- python
------------------------------------------------------------
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
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
  on_attach = on_attach,
  capabilities = capabilities,
})

------------------------------------------------------------
-- rust
------------------------------------------------------------
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
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
