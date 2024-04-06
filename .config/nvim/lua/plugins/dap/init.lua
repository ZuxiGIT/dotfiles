return {
    {
        "nvim-neotest/nvim-nio"
    },
    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap = require("dap")

            -- ui
            require("plugins.dap.ui")

            -- debuggers
            local lldb = require("plugins.dap.adapters.lldb")

            dap.adapters.lldb = lldb.adapter

            dap.configurations.c = lldb.config
            dap.configurations.cpp = lldb.config
        end,
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    },

    {
        'theHamsta/nvim-dap-virtual-text',
        dependencies = { 'mfussenegger/nvim-dap' },
    },
}
