local dap = require("dap")

-- ui
require("setup.dap.ui")

-- debuggers
local lldb = require("setup.dap.adapters.lldb")

dap.adapters.lldb = lldb.adapter

dap.configurations.c = lldb.config
dap.configurations.cpp = lldb.config
