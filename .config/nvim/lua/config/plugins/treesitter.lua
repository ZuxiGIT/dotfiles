local utils = require('utils')
local nmap  = utils.nmap

return {
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            local configs = require('nvim-treesitter.configs')

            configs.setup({
                ensure_installed = {
                    'c', 'lua', 'vim', 'vimdoc',
                    'cpp', 'ruby', 'python', 'cmake',
                    'bash'
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<cr>',
                        node_incremental = '<cr>',
                        node_decremental = '<bs>',
                    },
                },
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            nmap(']c', function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end, 'Jump to treesitter context', {silent = true})
        end,
    }
}
