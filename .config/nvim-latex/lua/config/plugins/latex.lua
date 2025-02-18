return {
    'lervag/vimtex',
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_compiler_method = 'latexmk'

        vim.g.vimtex_compiler_latexmk = {
            ['aux_dir'] = './.aux_dir',
            ['out_dir'] = './.out_dir',
        }

        vim.o.foldmethod = 'expr'
        vim.o.foldexpr = 'vimtex#fold#level(v:lnum)'
        vim.o.foldtext = 'vimtex#fold#text()'
        vim.o.foldlevel = 2

    end
}
