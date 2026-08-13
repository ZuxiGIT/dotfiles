local utils = require('utils')
local nmap  = utils.nmap

return {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
        require('nvim-tree').setup()

        local api = require('nvim-tree.api')

        nmap('<C-n>', api.tree.toggle, "Toggle file explorer")
        nmap('<leader>ef', function()
            api.tree.toggle({ find_file = true, focus = true, })
        end, "Toggle file explorer on current file")
        nmap('<leader>ec', api.tree.collapse_all, "Collapse file explorer")
        nmap('<leader>er', api.tree.reload, "Refresh file explorer")
    end
}
