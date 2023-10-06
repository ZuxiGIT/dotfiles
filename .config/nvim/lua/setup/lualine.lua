local options = {
    theme = 'onedark'
}

local trailing_whitespaces = function()
    local space = vim.fn.search([[\s\+$]], 'nwc')
    return space ~= 0 and "TW:"..space or ""
end

local sections = {
    lualine_c = {
        { 'filename', path = 3 }
    },
    lualine_z = {
        'location',
        trailing_whitespaces
    }
}

require('lualine').setup({ options = options, sections = sections })
