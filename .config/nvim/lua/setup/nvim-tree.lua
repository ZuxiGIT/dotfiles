local api = require('nvim-tree.api')
local set = vim.keymap.set

set('n', '<C-n>', api.tree.toggle)

require('nvim-tree').setup()
