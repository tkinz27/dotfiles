require('config.options')
require('config.keymaps')
require('config.autocmds')

require('lazy.core.util').try(
function()
    require("tokyonight").load({
        transparent = true,
    })
end, {
    msg = "Could not load tokyonight",
    on_error = function(msg)
        require("lazy.core.util").error(msg)
        vim.cmd.colorscheme("habamax")
    end,
})
