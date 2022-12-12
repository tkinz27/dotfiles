local lspconfig = require('lspconfig')

-- signs
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- diagnostics
vim.diagnostic.config({
  virtual_text = true,
  -- show signs
  signs = { active = signs },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})
vim.keymap.set('n', 'dn', vim.diagnostic.goto_next)
vim.keymap.set('n', 'dp', vim.diagnostic.goto_prev)
vim.keymap.set('n', 'dq', vim.diagnostic.setloclist)
vim.keymap.set('n', 'de', vim.diagnostic.open_float)

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp_keymaps = function(bufnr)
  local ts = require('telescope.builtin')
  -- vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Find LSP Code Actions' })
  -- vim.keymap.set('v', 'ca', vim.lsp.buf.range_code_action, { buffer = bufnr, desc = 'Find LSP Code Actions [range]' })
  vim.keymap.set('n', 'go', ts.lsp_document_symbols, { buffer = bufnr, desc = 'Find LSP Document Symbols' })
  vim.keymap.set('n', 'gw', ts.lsp_workspace_symbols, { buffer = bufnr, desc = 'Find LSP Workspace Symbols' })
  vim.keymap.set('n', 'gr', ts.lsp_references, { buffer = bufnr, desc = 'Find LSP References' })
  vim.keymap.set('n', 'gi', ts.lsp_implementations, { buffer = bufnr, desc = 'Find LSP Implementations' })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Goto LSP Definition' })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Goto LSP Declaration' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Show LSP Hover' })
  vim.keymap.set('n', '<c-K>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Show LSP Signature Help' })
  vim.keymap.set('i', '<c-K>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Show LSP Signature Help' })
end

local lsp_formatting_filter = {}
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return not lsp_formatting_filter[client.name]
    end,
    bufnr = bufnr,
  })
end

local lspformatting_augroup = vim.api.nvim_create_augroup('LspFormatting', {})

local on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)

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

  if client.supports_method('textDocument/formatting') then
    -- vim.notify('Formatting enabled for ' .. client.name, 'info')
    vim.api.nvim_clear_autocmds({ group = lspformatting_augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lspformatting_augroup,
      buffer = bufnr,
      desc = 'LSP format on write',
      callback = function()
        lsp_formatting(bufnr)
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
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
  },
})
------------------------------------------------------------
-- golang
------------------------------------------------------------
require('go').setup({
  lsp_cfg = false,
  dap_debug = true,
  luasnip = true,
})

-- TODO check if we are in a bazel workspace and envvar
-- "GOPACKAGESDRIVER": "${workspaceFolder}/tools/gopackagesdriver.sh"
-- where gopackagesdriver == `exec bazel run -- @io_bazel_rules_go//go/tools/gopackagesdriver "${@}"`
lspconfig.gopls.setup({
  -- cmd = { 'gopls', '-vv', '-rpc.trace', '-logfile', '/tmp/gopls.log' },
  settings = {
    gopls = {
      buildFlags = { '-tags=unit' },
      analyses = {
        unusedParams = true,
        ST1003 = false,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      directoryFilters = {
        '-build',
        '-bazel-bin',
        '-bazel-out',
        '-bazel-testlogs',
      },
      staticcheck = true,
      usePlaceholders = true,
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

  vim.lsp.buf.format()
end
vim.api.nvim_command('au BufWritePre *.go lua GoImports(10000)')

------------------------------------------------------------
-- tsserver
------------------------------------------------------------
lspconfig.tsserver.setup({
  init_options = require('nvim-lsp-ts-utils').init_options,
  on_attach = function(client, bufnr)
    lsp_formatting_filter[client.name] = true
    local ts_utils = require('nvim-lsp-ts-utils')
    ts_utils.setup({
      eslint_bin = 'eslint_d',
      -- eslint_enable_diagnostics = true,
      -- eslint_enable_code_actions = true,
      -- enable_import_on_completion = true,
      formatter = 'prettier',
    })
    ts_utils.setup_client(client)

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
  on_attach = function(client, bufnr)
    lsp_formatting_filter[client.name] = true
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  settings = {
    python = {
      analyses = {
        -- diagnosticMode = 'openFilesOnly',
      },
    },
  },
})

-- lspconfig.pyre.setup({
--   on_attach = function(client, bufnr)
--     lsp_formatting_filter[client.name] = true
--     on_attach(client, bufnr)
--   end,
--   capabilities = capabilities,
-- })

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
