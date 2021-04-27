require('nvim-treesitter.configs').setup {
    highlight = { enable = true },
    indent = { enable = true },
}

vim.o.termguicolors = true
vim.o.background = 'dark'

vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_sidebars = {
    "qf", "vista_kind", "terminal", "packer", "NvimTree",
}

vim.cmd[[colorscheme tokyonight]]

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

vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_current_context = true
