vim.opt.list = true
vim.opt.listchars:append("lead:⋅")
vim.opt.listchars:append("eol:↴")

return {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    config = function ()
        require('ibl').setup({
            scope = {
                show_start = false,
                show_end = false,
            },
            indent = {
                char = '┊',
                tab_char = '┊',
            },
        })
    end,
}
