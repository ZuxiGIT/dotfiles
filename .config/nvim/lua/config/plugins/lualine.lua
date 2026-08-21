local utils = require('utils')

local MAX_FILE_SIZE = 1024 * 1024

local trailing_whitespaces = function()
    if utils.is_large_file(0, MAX_FILE_SIZE) then
        return ''
    end

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
