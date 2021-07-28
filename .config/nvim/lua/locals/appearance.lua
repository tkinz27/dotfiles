vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_context_patterns = {
    'class', 'function', 'method', '^if', '^while',
    '^for', '^object', '^table', 'block', 'arguments',
    'func_literal', 'block',
}

vim.o.termguicolors = true
vim.o.background = 'dark'

-- for tokyonight
vim.g.tokyonight_style = "storm"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_sidebars = {
    "qf", "vista_kind", "terminal", "packer", "NvimTree",
}

-- for material
vim.g.material_style = 'deep ocean'
vim.g.materiaL_contrast = true
vim.g.material_borders = true
vim.g.material_disable_background = true

require('lualine').setup{
    options = {
        theme = 'tokyonight',
    }
}

require('bufferline').setup{
    options = {
        numbers = 'buffer_id',
        diagnostics = 'nvim_lsp',
    }
}

vim.cmd[[colorscheme tokyonight]]

