local utils = require('utils')
local nmap  = utils.nmap
local vmap  = utils.vmap

return {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    config = function()
        require('diffview').setup()
        nmap('<leader>gh', function() vim.cmd.DiffviewFileHistory('%') end, 'View Git history for current file')
        vmap('<leader>gh', '<cmd>DiffviewFileHistory<cr>', 'View Git history for selected range')
        nmap('<leader>go', function() vim.cmd.DiffviewOpen('HEAD^') end, 'View diff for last commit')
        nmap('<leader>gc', vim.cmd.DiffviewClose, 'Close Diffview tab')
    end,
}
