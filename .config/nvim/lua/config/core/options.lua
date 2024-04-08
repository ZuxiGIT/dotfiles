vim.cmd('unmap Y')
vim.cmd('let g:netrw_listtyle = 3')

local set = vim.opt

set.colorcolumn = "120"
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
set.swapfile = false
set.hlsearch = false
