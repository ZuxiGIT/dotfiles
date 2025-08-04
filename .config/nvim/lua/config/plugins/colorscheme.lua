-- return {
--     'navarasu/onedark.nvim',
--     config = function()
--         require('onedark').setup({ style = 'warmer' })
--         require('onedark').load()
--     end
-- }

return {
    'ellisonleao/gruvbox.nvim',
    priority = 1000 ,
    config = function()
        vim.o.background = "dark" -- or "light" for light mode
        vim.cmd([[colorscheme gruvbox]])
    end,
}
