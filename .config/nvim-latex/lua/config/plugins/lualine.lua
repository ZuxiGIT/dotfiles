local trailing_whitespaces = function()
    local space = vim.fn.search([[\s\+$]], 'nwc')
    return space ~= 0 and "TW:"..space or ""
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local navic = require('nvim-navic')
        local options = {
            theme = 'onedark'
        }

        local sections = {
            lualine_c = {
                { 'filename', path = 3 }
            },
            lualine_z = {
                'location',
                trailing_whitespaces
            }
        }

        local winbar = {
            lualine_c = {
                { function() return navic.get_location() end, cond = function() return navic.is_available() end }
            }
        }

        require('lualine').setup({ options = options, sections = sections, winbar = winbar})
    end
}
