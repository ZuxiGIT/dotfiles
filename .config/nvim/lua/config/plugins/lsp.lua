return {
    {
        'williamboman/mason.nvim',
        config = true
    },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        opts = {
            ensure_installed = {
                'bashls',
                'clangd',
                'lua_ls',
                'perlnavigator',
                'pylsp',
                'ts_ls',
            },
            automatic_enable = false,
        },
    },
    {
        'j-hui/fidget.nvim',
        config = true
    },
    {
        'SmiteshP/nvim-navic',
        config = true
    },
    {
        'neovim/nvim-lspconfig',
        config = false
    }
}
