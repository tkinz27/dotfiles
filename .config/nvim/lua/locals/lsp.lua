local lspconfig = require 'lspconfig'

-- diagnostic config
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        virtual_text = {spacing = 4, prefix = "■"},
        signs = true,
        update_in_insert = false,
    }
)

-- signs
vim.fn.sign_define("LspDiagnosticsErrorSign", {text="✗", texthl="LspDiagnosticsError"})
vim.fn.sign_define("LspDiagnosticsWarningSign", {text="⚠", texthl="LspDiagnosticsWarning"})
vim.fn.sign_define("LspDiagnosticsInformationSign", {text="ⓘ", texthl="LspDiagnosticsInformation"})
vim.fn.sign_define("LspDiagnosticsHintSign", {text="✓", texthl="LspDiagnosticsHint"})

-- icons
require('lspkind').init({
    with_text = true,
    preset = 'default',
})

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
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
        format = function(entry, vim_item)
            vim_item.kind = require('lspkind').presets.default[vim_item.kind] .. " " .. vim_item.kind
            return vim_item
        end,
    },
})

vim.cmd[[autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }]]
-- local snippets = require 'snippets'
-- snippets.use_suggested_mappings()

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities = require('cmp_nvim_lsp').update_capabilities(updated_capabilities)

local _attach = function(client)
    -- require'completion'.on_attach(client)

    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

    local nmap = function(k, v)
        local o = {noremap=true, silent=true}
        vim.api.nvim_buf_set_keymap(0, 'n', k, v, o)
    end
    local imap = function(k, v)
        local o = {noremap=true, silent=true}
        vim.api.nvim_buf_set_keymap(0, 'i', k, v, o)
    end
    local vmap = function(k, v)
        local o = {noremap=true, silent=true}
        vim.api.nvim_buf_set_keymap(0, 'v', k, v, o)
    end
    nmap('ca', [[<cmd>lua require('telescope.builtin').lsp_code_actions{}<cr>]])
    vmap('ca', [[<cmd>lua require('telescope.builtin').lsp_range_code_actions{}<cr>]])
    nmap('go', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]])
    nmap('gw', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>]])
    nmap('gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    nmap('gr', [[<cmd>lua require('telescope.builtin').lsp_references{}<cr>]])
    nmap('K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    nmap('<c-K>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    imap('<c-K>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    nmap('dn', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>')
    nmap('dp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>')

    -- Set autocommands conditional on server capabilities
    if client.resolved_capabilities.document_highlight then
        vim.cmd [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]]
    end

    vim.api.nvim_set_current_dir(client.config.root_dir)
end

local lsps = {
    "tsserver",
    "bashls",
    "terraformls",
    "cmake",
    "html",
}
for _, s in ipairs(lsps) do
    lspconfig[s].setup {
        on_attach = _attach,
        capabilities = updated_capabilities,
    }
end

------------------------------------------------------------
-- golang
------------------------------------------------------------
-- TODO check if we are in a bazel workspace and envvar
-- "GOPACKAGESDRIVER": "${workspaceFolder}/tools/gopackagesdriver.sh"
-- where gopackagesdriver == `exec bazel run -- @io_bazel_rules_go//go/tools/gopackagesdriver "${@}"`
lspconfig.gopls.setup{
  -- cmd = {"gopls", "-vv", "-rpc.trace", "-logfile", "/tmp/gopls.log"},
  settings = {
    gopls = {
      analyses = {
        unusedParams = true,
        ST1003 = false,
      },
      directoryFilters = {
        "-build",
        "-bazel-bin",
        "-bazel-out",
        "-bazel-testlogs",
      },
      staticcheck = true,
      usePlaceholders = true,
      experimentalWorkspaceModule = true,
    },
  },
  on_attach=_attach,
  capabilities=updated_capabilities,
}

function GoImports(timeoutms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}

    local method = "textDocument/codeAction"
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
vim.api.nvim_command("au BufWritePre *.go lua GoImports(10000)")

------------------------------------------------------------
-- python
------------------------------------------------------------
lspconfig.jedi_language_server.setup{
  on_attach=_attach,
  capabilities=updated_capabilities,
}

------------------------------------------------------------
-- lua
------------------------------------------------------------
local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
else
    print("Unsupported system for sumneko")
end

local sumneko_root_path = vim.fn.expand("~/code/github.com/sumneko/lua-language-server")
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

lspconfig.sumneko_lua.setup{
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
        runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
        },
        diagnostics = {
            globals = {'vim'},
        },
        workspace = {
            library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            },
        },
        telemetry = {
            enable = false
        },
    },
  },
  on_attach=_attach,
  capabilities=updated_capabilities,
}

------------------------------------------------------------
-- rust
------------------------------------------------------------
lspconfig.rust_analyzer.setup {
    on_attach=_attach,
    capabilities=updated_capabilities,
    settings = {
        ["rust-analyzer"] = {
            assist= {
                importMergeBehavior = "last",
                importPrefix = "by_self",
            },
            cargo =  {
                loadOutDirsFromCheck = true,
            },
            procMacro = {
                enable = true,
            },
        },
    },
}
