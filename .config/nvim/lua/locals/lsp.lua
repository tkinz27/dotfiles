local common = require('locals.common')
local lspconfig = require('lspconfig')

-- diagnostic config
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = false,
  virtual_text = { spacing = 4, prefix = '■' },
  signs = true,
  update_in_insert = false,
})

-- signs
vim.fn.sign_define('LspDiagnosticsErrorSign', { text = '✗', texthl = 'LspDiagnosticsError' })
vim.fn.sign_define('LspDiagnosticsWarningSign', { text = '⚠', texthl = 'LspDiagnosticsWarning' })
vim.fn.sign_define('LspDiagnosticsInformationSign', { text = 'ⓘ', texthl = 'LspDiagnosticsInformation' })
vim.fn.sign_define('LspDiagnosticsHintSign', { text = '✓', texthl = 'LspDiagnosticsHint' })

-- icons
require('lspkind').init({
  with_text = true,
  preset = 'default',
})

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

-- completion config
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
    -- ['<Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif luasnip.expand_or_jumpable() then
    --     luasnip.expand_or_jump()
    --   elseif has_words_before() then
    --     cmp.complete()
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
    -- ['<S-Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   elseif luasnip.jumpable(-1) then
    --     luasnip.jump(-1)
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'treesitter' },
    { name = 'emoji' },
    { name = 'nvim_lua' },
  },
  formatting = {
    format = require('lspkind').cmp_format({
      with_text = true,
      menu = {
        nvim_lsp = '[LSP]',
        luasnip = '[LuaSnip]',
        path = '[Path]',
        treesitter = '[TS]',
        emoji = '[emoji]',
        nvim_lua = '[Lua]',
      },
    }),
  },
})

vim.cmd([[autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }]])
-- local snippets = require 'snippets'
-- snippets.use_suggested_mappings()

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities = require('cmp_nvim_lsp').update_capabilities(updated_capabilities)

local _attach = function(client, bufnr)
  -- require'completion'.on_attach(client)

  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  common.bmap('n', 'ca', [[<cmd>lua require('telescope.builtin').lsp_code_actions{}<cr>]])
  common.bmap('v', 'ca', [[<cmd>lua require('telescope.builtin').lsp_range_code_actions{}<cr>]])
  common.bmap('n', 'go', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]])
  common.bmap('n', 'gw', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>]])
  common.bmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
  common.bmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  common.bmap('n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references{}<cr>]])
  common.bmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
  common.bmap('n', '<c-K>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
  common.bmap('i', '<c-K>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
  common.bmap('n', 'dn', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>')
  common.bmap('n', 'dp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>')

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

  vim.api.nvim_set_current_dir(client.config.root_dir)

  if client.resolved_capabilities.document_formatting then
    vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]])
  end
end

local lsps = {
  'bashls',
  'terraformls',
  -- 'cmake',
  -- 'html',
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
  sources = {
    null_ls.builtins.formatting.stylua.with({
      extra_args = { '--config-path', vim.fn.expand('~/.config/stylua/stylua.toml') },
    }),
    null_ls.builtins.formatting.clang_format.with({
      filetypes = { 'c', 'cpp', 'proto' },
    }),
    null_ls.builtins.formatting.cmake_format,
    null_ls.builtins.formatting.prettier,
  },
})
------------------------------------------------------------
-- golang
------------------------------------------------------------
-- TODO check if we are in a bazel workspace and envvar
-- "GOPACKAGESDRIVER": "${workspaceFolder}/tools/gopackagesdriver.sh"
-- where gopackagesdriver == `exec bazel run -- @io_bazel_rules_go//go/tools/gopackagesdriver "${@}"`
lspconfig.gopls.setup({
  -- cmd = {"gopls", "-vv", "-rpc.trace", "-logfile", "/tmp/gopls.log"},
  settings = {
    gopls = {
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
      experimentalWorkspaceModule = true,
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
        vim.lsp.util.apply_workspace_edit(r.edit)
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
------------------------------------------------------------
-- python
------------------------------------------------------------
lspconfig.jedi_language_server.setup({
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
