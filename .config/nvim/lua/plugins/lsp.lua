local function set_km(opts)
  local mode = opts.mode or 'n'
  local bufnr = opts.bufnr or 0
  local expr = opts.expr or false

  if opts.cmd == nil then
    vim.notify('LSP: No command provided for keymap: ' .. opts.key, vim.log.levels.WARN)
  end

  vim.keymap.set(mode, opts.key, opts.cmd, {
    expr = expr,
    buffer = bufnr,
    noremap = true,
    silent = true,
    desc = opts.desc,
  })
end

local function set_lsp_keymaps(client, bufnr)
  set_km({
    key = '<leader>cl',
    cmd = function()
      Snacks.picker.lsp_config()
    end,
    desc = 'Lsp Info',
    bufnr = bufnr,
  })

  if client:supports_method('textDocument/declaration') then
    set_km({ key = 'gd', cmd = vim.lsp.buf.definition, desc = 'Goto Definition', bufnr = bufnr })
  end

  set_km({ key = 'gy', cmd = vim.lsp.buf.type_definition, desc = 'Goto T[y]pe Definition', bufnr = bufnr })
  set_km({ key = 'gD', cmd = vim.lsp.buf.declaration, desc = 'Goto Declaration', bufnr = bufnr })

  -- set_km({key =  { key = "gri", cmd = "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation", bufnr = bufnr })
  -- set_km({key =  { key = "grr", cmd = "<cmd>Telescope lsp_references<cr>", desc = "References", bufnr = bufnr })
  set_km({ key = 'K', cmd = vim.lsp.buf.hover, desc = 'Hover', bufnr = bufnr })
  if client:supports_method('textDocument/signatureHelp') then
    set_km({ key = 'gK', cmd = vim.lsp.buf.signature_help, desc = 'Signature Help', bufnr = bufnr })
    set_km({ key = '<c-s>', cmd = vim.lsp.buf.signature_help, mode = 'i', desc = 'Signature Help', bufnr = bufnr })
  end
end

local lsp_attach = function(args)
  local buffer = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then
    return
  end

  set_lsp_keymaps(client, buffer)

  if client:supports_method('textDocument/codeLens') then
    vim.lsp.codelens.refresh({ bufnr = buffer })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = buffer,
      callback = vim.lsp.codelens.refresh,
    })
  end
end

local spec = {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason-lspconfig.nvim',
    { 'mason-org/mason.nvim', opts = {} },
  },
}

spec.opts = {
  servers = {
    terraformls = {},
    bashls = {},
  },
}

spec.config = function(_, opts)
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_lines = { current_line = true },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = ' ',
        [vim.diagnostic.severity.WARN] = ' ',
        [vim.diagnostic.severity.HINT] = ' ',
        [vim.diagnostic.severity.INFO] = ' ',
      },
    },
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
    callback = lsp_attach,
  })

  local ensure_installed = {}
  local servers = opts.servers or {}
  for server, server_opts in pairs(servers) do
    if server_opts then
      vim.lsp.config(server, server_opts)
      vim.lsp.enable(server)
    end
    ensure_installed[#ensure_installed + 1] = server
  end
  require('mason-lspconfig').setup({
    ensure_installed = ensure_installed,
    automatic_installation = true,
  })
end

return spec
