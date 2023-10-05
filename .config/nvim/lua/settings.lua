vim.cmd('unmap Y')

local set = vim.opt

set.colorcolumn = "80"
set.cursorline = true
set.number = true
set.relativenumber = true

-- Tabs
set.tabstop = 4
set.shiftwidth = 4
set.smarttab = true
set.expandtab = true    -- Put tabs as spaces
set.softtabstop = 4     -- 4 spaces in tab
set.autoindent = true

-- Mouse

set.mousehide = true
set.mouse = "a" 

-- Misc
set.wrap = true
set.linebreak = true

set.fileencodings="utf8,cp1251"
set.ruler = true
