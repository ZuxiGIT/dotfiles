local utils = require('utils')
local nmap  = utils.nmap

return {
    'tpope/vim-fugitive',
    config = function()
        nmap('<leader>gb', ':Git blame<CR>',  'Git blame')
        nmap('<leader>gs', ':Git status<CR>', 'Git status')
        nmap('<leader>G',  ':Git<CR>',        'Git')

    end
}
