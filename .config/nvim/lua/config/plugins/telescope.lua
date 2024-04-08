return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            local wk = require('which-key')

            local wk_opts = { prefix = '<leader>' }
            local wk_mappings = {
                f = {
                    name = '[F]ind',
                    f = { builtin.find_files,       '[f]ile'},
                    g = { function () builtin.live_grep({ layout_strategy = 'vertical' }) end,  'pattern (live [g]rep)'},
                    b = { builtin.buffers,          '[b]uffers'},
                    h = { function () builtin.help_tags({ layout_strategy = 'vertical' }) end,  '[h]elp tags'},
                    s = { builtin.grep_string,      '[s]tring'},
                    r = { builtin.lsp_references,   '[r]eferences'},
                    d = { builtin.lsp_definitions,  '[d]efinitions'},
                },
                g = {
                    name = '[G]it',
                    s = { builtin.git_status,   '[s]tatus'},
                    c = { builtin.git_commits,  '[c]ommits'},
                }
            }
            wk.register(wk_mappings, wk_opts)
            require('telescope').setup({})
        end
    },
}
