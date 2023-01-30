local Util = require('lazy.core.util')

local M = {}

M.autoformat = true

M.lsp_custom_format = {}

function M.toggle()
  M.autoformat = not M.autoformat
  if M.autoformat then
    Util.info('Enabled format on save', { title = 'Format' })
  else
    Util.warn('Disabled format on save', { title = 'Format' })
  end
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING') > 0

  vim.lsp.buf.format(vim.tbl_deep_extend('force', {
    bufnr = buf,
    filter = function(client)
      if have_nls then
        return client.name == 'null-ls'
      end
      if M.lsp_custom_format[client.name] ~= nil then
        -- filter out lsp servers that have a different custom formating
        return false
      end
      return client.name ~= 'null-ls'
    end,
  }, require('config.util').opts('nvim-lspconfig').format or {}))
end

function M.on_attach(client, buf)
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat.' .. buf, {}),
      buffer = buf,
      callback = function()
        if M.autoformat then
          local custom_format = M.lsp_custom_format[client.name]
          if custom_format ~= nil then
            custom_format(buf)
          else
            M.format()
          end
        end
      end,
      desc = 'Format on save',
    })
  end
end

return M
