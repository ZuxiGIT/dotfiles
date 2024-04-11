return {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
        local api = require('nvim-tree.api')
        require('nvim-tree').setup()

        local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map('n', '<C-n>', api.tree.toggle, "Toggle file explorer")
        map('n', '<leader>ef', function()
            api.tree.toggle({ find_file = true, focus = true, })
        end, "Toggle file explorer on current file")
        map('n', '<leader>ec', api.tree.collapse_all, "Collapse file explorer")
        map('n', '<leader>er', api.tree.reload, "Refresh file explorer")
    end
}
