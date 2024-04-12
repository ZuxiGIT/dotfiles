return {
    'tpope/vim-fugitive',
    config = function()
        local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { desc = desc})
        end

        map('n', '<leader>gb', ':Git blame<CR>', 'Git blame')
        map('n', '<leader>gs', ':Git status<CR>', 'Git status')
        map('n', '<leader>G', ':Git<CR>', 'Git')

    end
}
