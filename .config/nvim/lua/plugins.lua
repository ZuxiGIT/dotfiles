local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- LSP support
    {
        'williamboman/mason.nvim',
        config = true
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('setup.mason-lspconfig')
        end,
        dependencies = { 'williamboman/mason.nvim' }

    },
    -- LSP
    {
        'neovim/nvim-lspconfig',
        config = function()
            require('setup.lsp')
        end,
        dependencies = { 'williamboman/mason-lspconfig.nvim' }
    },
    -- Syntax highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('setup.treesitter')
        end
    },
    -- Text editing
    {
        'kylechui/nvim-surround',
        version = '*', -- Use for stability; omit to use `main` branch for the latest features
        event = 'VeryLazy',
        config = true
    },
    -- Fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.3',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('setup.telescope')
        end
    },
    -- Devicons
    {
        'nvim-tree/nvim-web-devicons'
    },
    -- Colorscheme
    -- {
    --     'mhartington/oceanic-next',
    --     config = function()
    --         vim.cmd('colorscheme OceanicNext')
    --     end

    -- },
    {
        'navarasu/onedark.nvim',
        config = function()
            require('onedark').setup({ style = 'warmer' })
            require('onedark').load()
        end
    },
    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('setup.lualine')
        end
    },
    -- DAP
    {
        "nvim-neotest/nvim-nio"
    },
    {
        'mfussenegger/nvim-dap',
        config = function()
            require('setup.dap')
        end,
    },

    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
        config = function() require('dapui').setup() end
    },

    {
        'theHamsta/nvim-dap-virtual-text',
        dependencies = { 'mfussenegger/nvim-dap' },
        config = true
    },
    -- Nvim tree
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        init = function()
            -- disable netrw at the very start of your init.lua
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        config = function()
            require('setup.nvim-tree')
        end
    },
    -- which-key
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function()
            require('setup.which-key')
        end
    },
    -- Fugitive
    {
        'tpope/vim-fugitive',
    },
    {
        'lewis6991/gitsigns.nvim',
        config = true
    }
}

require('lazy').setup(plugins)
