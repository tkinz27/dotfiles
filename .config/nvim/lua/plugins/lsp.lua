local lsp_attach = function(args)
  local buffer = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then
    return
  end

  if client:supports_method('textDocument/codeLens') then
    vim.lsp.codelens.enable(true, { bufnr = buffer })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = buffer,
      callback = function()
        vim.lsp.codelens.enable(true, { bufnr = buffer })
      end,
    })
  end
end

local function ensure_mason_packages(packages)
  if type(packages) ~= 'table' or vim.tbl_isempty(packages) then
    return
  end

  local registry = require('mason-registry')
  for _, name in ipairs(packages) do
    local ok, package = pcall(registry.get_package, name)
    if not ok then
      vim.notify('Mason package not found: ' .. name, vim.log.levels.WARN)
    elseif not package:is_installed() and not package:is_installing() then
      package:install()
    end
  end
end

local function setup_mason(_, opts)
  local mason_opts = vim.deepcopy(opts)
  mason_opts.ensure_installed = nil

  require('mason').setup(mason_opts)
  if #vim.api.nvim_list_uis() == 0 then
    return
  end

  ensure_mason_packages(opts.ensure_installed)
end

local spec = {
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    'mason-org/mason-lspconfig.nvim',
    { 'mason-org/mason.nvim', opts = {}, config = setup_mason },
  },
}

spec.opts = {
  servers = {
    terraformls = {},
    bashls = {},
  },
}

spec.config = function(_, opts)
  vim.lsp.log.set_level('error')
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
  local setup = opts.setup or {}
  local servers = opts.servers or {}
  for server, server_opts in pairs(servers) do
    if server_opts then
      local install_with_mason = server_opts.mason ~= false
      server_opts = vim.deepcopy(server_opts)
      server_opts.mason = nil
      server_opts.keys = nil
      server_opts.capabilities = server_opts.capabilities or {}

      local setup_server = setup[server] or setup['*']
      local handled = setup_server and setup_server(server, server_opts)
      if not handled then
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end
      if install_with_mason then
        ensure_installed[#ensure_installed + 1] = server
      end
    end
  end
  require('mason-lspconfig').setup({
    ensure_installed = ensure_installed,
    automatic_installation = true,
  })
end

return spec
