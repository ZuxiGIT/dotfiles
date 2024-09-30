local utils = require('utils')
local nmap  = utils.nmap

return {
    'rcarriga/nvim-notify',
    config = function()
        vim.notify = require('notify')
        nmap('<leader>?', ':Telescope notify<cr>', 'Show notifications')
    end,
}
