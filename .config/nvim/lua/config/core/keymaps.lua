local utils = require('utils')
local nmap  = utils.nmap
local imap  = utils.imap
local cmap  = utils.tmap

imap("jk", "<ESC>", "Exit insert mode with jk")
cmap("jk", "<ESC>", "Exit insert mode with jk")
nmap("<space>nh", ":nohl<CR>", "Clear search highlights")

-- increment/decrement numbers
nmap("<space>+", "<C-a>", "Increment number") -- increment
nmap("<space>-", "<C-x>", "Decrement number") -- decrement

-- window management
nmap("<space>sv", "<C-w>v", "Split window vertically")    -- split window vertically
nmap("<space>sh", "<C-w>s", "Split window horizontally")  -- split window horizontally
nmap("<space>se", "<C-w>=", "Make splits equal size")     -- make split windows equal width & height
nmap("<space>sx", "<cmd>close<CR>", "Close current split")-- close current split window

nmap("<space>to", "<cmd>tabonly<CR>", "Close all tabs except the active one")  -- close all tabs except the active one
nmap("<space>te", "<cmd>tabnew<CR>", "Open new tab")          -- open new tab
nmap("<space>tx", "<cmd>tabclose<CR>", "Close current tab")   -- close current tab
nmap("<space>tn", "<cmd>tabn<CR>", "Go to next tab")          --  go to next tab
nmap("<space>tp", "<cmd>tabp<CR>", "Go to previous tab")      --  go to previous tab
nmap("<space>tf", "<cmd>tabnew %<CR>", "Open current buffer in new tab") --  move current buffer to new tab
