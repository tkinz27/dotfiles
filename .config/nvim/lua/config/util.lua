local M = {}

M.lsp = {}

function M.opts(name)
  local plugin = require('lazy.core.config').plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require('lazy.core.plugin')
  return Plugin.values(plugin, 'opts', false)
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.lsp.on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

M.lsp._supports_method = {}

---@param method string
---@param fn fun(client:vim.lsp.Client, buffer)
function M.lsp.on_supports_method(method, fn)
  M.lsp._supports_method[method] = M.lsp._supports_method[method] or setmetatable({}, { __mode = 'k' })
  return vim.api.nvim_create_autocmd('User', {
    pattern = 'LspSupportsMethod',
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

---@return _.lspconfig.options
function M.lsp.get_config(server)
  local configs = require('lspconfig.configs')
  return rawget(configs, server)
end

function M.lsp.is_enabled(server)
  local c = M.lsp.get_config(server)
  return c and c.enabled ~= false
end

function M.has(plugin)
  return require('lazy.core.config').spec.plugins[plugin] ~= nil
end

-- returns a function that calls telescope.
-- Useful for the keys mapping passed to plugin specs
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    require('telescope.builtin')[builtin](opts)
  end
end

-- fallback root patterns
M.root_patterns = { '.git', 'lua' }

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= '' and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if r and path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  local Config = require('lazy.core.config')
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

return M
