local M = {}

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

local function set_global_keymaps(client, bufnr)
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

function M.on_attach(client, bufnr)
  set_global_keymaps(client, bufnr)
end

return M
