return {
    'nvim-treesitter/nvim-treesitter',
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "c", "lua", "vim", "vimdoc",
                "cpp", "ruby", "python", "cmake",
                "bash"
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
