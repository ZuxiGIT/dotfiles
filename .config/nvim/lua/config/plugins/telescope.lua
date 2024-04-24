return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-live-grep-args.nvim'
    },
    config = function()
        local builtin = require('telescope.builtin')
        local actions = require('telescope.actions')
        local live_grep_args = require('telescope').load_extension('live_grep_args')


        local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { desc = desc})
        end

        map('n', '<leader>ff', builtin.find_files, 'Find file')

        map('n', '<leader>fg', function ()
            live_grep_args.live_grep_args({ layout_strategy = 'vertical' })
        end, 'Find string')

        map('n', '<leader>fb', builtin.buffers, 'Find buffers')

        map('n', '<leader>fh', function ()
            builtin.help_tags({ layout_strategy = 'vertical' })
        end, 'Find string in help tags')

        map('n', '<leader>fs', function ()
            builtin.grep_string({ layout_strategy = 'vertical' })
        end, 'Find string under cursor')

        require('telescope').setup({
            defaults = {
                path_display = { 'smart' },
                mappings = {
                    i = {
                        ['<C-k>'] = actions.move_selection_previous,
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
                    }
                }
            }
        })
    end
}
