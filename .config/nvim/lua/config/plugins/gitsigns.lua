local utils = require('utils')
local nmap  = utils.nmap
local vmap  = utils.vmap
local map   = utils.map

return {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        on_attach = function(bufnr)
            local gs = require('gitsigns')
            local opts = { buffer = bufnr }

            nmap(']h', gs.next_hunk, 'Next hunk', opts)
            nmap('[h', gs.prev_hunk, 'Previous hunk', opts)

            nmap('<leader>hs', gs.stage_hunk, 'Stage hunk', opts)
            vmap('<leader>hs', function ()
                gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, 'Stage hunk', opts)

            nmap('<leader>hr', gs.reset_hunk, 'Reset hunk', opts)
            vmap('<leader>hr', function ()
                gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, 'Reset hunk', opts)

            nmap('<leader>hS', gs.stage_buffer, 'Stage buffer', opts)
            nmap('<leader>hR', gs.reset_buffer, 'Reset buffer', opts)

            nmap('<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk', opts)
            nmap('<leader>hp', gs.preview_hunk, 'Preview hunk', opts)

            nmap('<leader>hb', function()
                gs.blame_line({ full = true })
            end, 'Blame line', opts)
            nmap('<leader>hB', gs.toggle_current_line_blame, 'Toggle line blame', opts)

            nmap('<leader>hd', gs.diffthis, 'Diff this', opts)
            nmap('<leader>hD', function()
                gs.diffthis('~')
            end, 'Diff this ~', opts)

            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Gitsigns select hunk', opts)
        end,
    }
}
