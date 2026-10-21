local function has_helm_chart(path)
  local dir = vim.fs.dirname(path)
  if not dir then
    return false
  end

  return #vim.fs.find('Chart.yaml', { path = dir, upward = true, type = 'file' }) > 0
end

local function helm_template_filetype(path)
  if has_helm_chart(path) then
    return 'helm'
  end
end

local function helm_values_filetype(path)
  if has_helm_chart(path) then
    return 'yaml.helm-values'
  end
end

local function extend_unique(list, values)
  for _, value in ipairs(values) do
    if not vim.tbl_contains(list, value) then
      list[#list + 1] = value
    end
  end
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    init = function()
      vim.filetype.add({
        pattern = {
          ['.*/templates/.*%.ya?ml'] = { helm_template_filetype, { priority = 20 } },
          ['.*/templates/.*%.ya?ml%.gotmpl'] = { helm_template_filetype, { priority = 20 } },
          ['.*/templates/.*%.tpl'] = { helm_template_filetype, { priority = 20 } },
          ['.*/values[^/]*%.ya?ml'] = { helm_values_filetype, { priority = 10 } },
        },
      })

      vim.treesitter.language.register('yaml', 'yaml.helm-values')
    end,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      extend_unique(opts.ensure_installed, { 'gotmpl', 'helm' })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        helm_ls = {},
      },
    },
  },
}
