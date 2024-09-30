local utils = require('utils')
local nmap  = utils.nmap
local vmap  = utils.vmap
local map   = utils.map

return {
    -- {
    --     'tpope/vim-fugitive',
    -- },
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        on_attach = function(bufnr)
            local gs = require('gitsigns')

            nmap(']h', gs.next_hunk, 'Next hunk')
            nmap('[h', gs.prev_hunk, 'Prev hunk')

            nmap('<leader>hs', gs.stage_hunk, 'Stage hunk')
            vmap('<leader>hs', function ()
                gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, "Stage hunk")

            nmap('<leader>hr', gs.reset_hunk, 'Reset hunk')
            vmap('<leader>hr', function ()
                gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, "Reset hunk")

            nmap('<leader>hS', gs.stage_buffer, 'Stage buffer')
            nmap('<leader>hR', gs.reset_buffer, 'Reset buffer')

            nmap('<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
            nmap('<leader>hp', gs.preview_hunk, 'Preview hunk')

            nmap('<leader>hb', function()
                gs.blame_line({ full = true })
            end, "Blame line")
            nmap('<leader>hB', gs.toggle_current_line_blame, 'Toggle line blame')

            nmap('<leader>hd', gs.diffthis, 'Diff this')
            nmap('<leader>hD', function()
                gs.diffthis('~')
            end, 'Diff this ~')

            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Gitsigns select hunk')


        end,
    }
}
