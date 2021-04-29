local lspconfig = require 'lspconfig'

local snippets = require 'snippets'
snippets.use_suggested_mappings()

local on_attach_vim = function(client)
  require'completion'.on_attach(client)
end

lspconfig.gopls.setup{
  on_attach=on_attach_vim,
  cmd = {"gopls", "-vv", "-rpc.trace", "-logfile", "/tmp/gopls.log"},
  settings = {
    gopls = {
      analyses = {
        unusedParams = true,
        ST1003 = false,
      },
      directoryFilters = {
        "-build",
      },
      staticcheck = true,
      usePlaceholders = true,
      experimentalWorkspaceModule = true,
    },
  },
}

function goimports(timeoutms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    local method = "textDocument/codeAction"
    local resp = vim.lsp.buf_request_sync(0, method, params, timeoutms)
    if resp and resp[1] then
      local result = resp[1].result
      if result and result[1] then
        local edit = result[1].edit
        vim.lsp.util.apply_workspace_edit(edit)
      end
    end

    vim.lsp.buf.formatting_sync(nil, 1000)
end

vim.api.nvim_command("au BufWritePre *.go lua goimports(1000)")

lspconfig.tsserver.setup{
  on_attach=on_attach_vim,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.html.setup{
  capabilities=capabilities,
  on_attach=on_attach_vim,
}

lspconfig.rust_analyzer.setup{
  on_attach=on_attach_vim,
}

lspconfig.cmake.setup{
  on_attach=on_attach_vim,
}


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
  on_attach=on_attach_vim,
}

-- lspconfig.pyls.setup{}
lspconfig.pyright.setup{}

lspconfig.bashls.setup{
  on_attach=on_attach_vim,
}

lspconfig.terraformls.setup{
  on_attach=on_attach_vim;
  cmd={'terraform-ls', 'serve', '-log-file', '/tmp/terraform-ls.log'};
}


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      spacing = 4,
      prefix = "■",
    }
  }
)

