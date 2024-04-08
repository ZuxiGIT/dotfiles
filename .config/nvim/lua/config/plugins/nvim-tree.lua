return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        init = function()
            -- disable netrw at the very start of your init.lua
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        config = function()
            local api = require('nvim-tree.api')

            require('which-key').register({
                ['<c-n>'] = {api.tree.toggle, "Toggle source tree"}
            }, {})
            require('nvim-tree').setup()
        end
    },
}
