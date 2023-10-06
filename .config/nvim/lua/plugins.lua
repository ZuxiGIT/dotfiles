local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
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
            require("setup.mason-lspconfig")
        end,
        dependencies = { 'williamboman/mason.nvim' }

    },
    -- LSP
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("setup.lsp")
        end,
        dependencies = { 'williamboman/mason-lspconfig.nvim' }
    },
    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("setup.treesitter")
        end
    },
    -- Text editing
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = true
    },
    -- Fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.3',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("setup.telescope")
        end
    },
    -- Devicons
    {
        'nvim-tree/nvim-web-devicons'
    },
    -- Colorscheme
    {
        'mhartington/oceanic-next',
        config = function()
            vim.cmd('colorscheme OceanicNext')
        end

    },
    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('setup.lualine')
        end
    }
}

require("lazy").setup(plugins)
