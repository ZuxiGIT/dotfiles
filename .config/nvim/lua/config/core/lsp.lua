-- redefine clangd launch cmd
vim.lsp.config('clangd', {
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy'
    }
})

-- add globals to lua lsp
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ";")
            },
            diagnostics = {
                globals = { 'vim', 'require' }
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            },
            hint = {
                enable = true,
                arrayIndex = "Enable",
                await = true,
                paramName = "All",
                paramType = true,
                semicolon = "Disable",
                setType = true,
            },
            telemetry = {
                enable = false
            }
        }
    }
})

local utils = require('utils')
local nmap  = utils.nmap
local map   = utils.map

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('documentSymbolProvider') then
            require('nvim-navic').attach(client, ev.buf)
        end

        -- completion
        -- if client:supports_method('textDocument/completion') then
        --     vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        -- end
        nmap('[d', function() vim.diagnostic.jump({ count = -1, float = true }) end,
            'Move to the previous diagnostic in the current buffer')
        nmap(']d', function() vim.diagnostic.jump({ count = 1, float = true }) end,
            'Move to the next diagnostic in the current buffer')
        nmap('gD', vim.lsp.buf.declaration, 'Go to declaration')
        nmap('gd', vim.lsp.buf.definition, 'Go to definition')
        nmap('gi', vim.lsp.buf.implementation, 'List all implementations')
        nmap('gr', vim.lsp.buf.references, 'List all references')

        nmap('H', vim.lsp.buf.hover, 'Hover information for word under cursor')
        nmap('<c-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.hover()<cr>', 'ctrl-click to hover info')
        nmap('K', vim.lsp.buf.signature_help, 'Signature information')
        nmap('<space>e', vim.diagnostic.open_float, 'Show diagnostics in a floating window.')
        nmap('<space>q', vim.diagnostic.setloclist, 'Add buffer diagnostics to the location list.')
        nmap('<space>D', vim.lsp.buf.type_definition, 'Jumps to the definition of the type of the symbol')
        nmap('<space>rn', vim.lsp.buf.rename, 'Rename all references')
        map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, 'Select a code action')
        nmap('<space>ft', function() vim.lsp.buf.format { async = true } end, 'Format code')

        nmap('<leader>fr', ':Telescope lsp_references layout_strategy=vertical<CR>', 'Find references')
        nmap('<leader>fd', ':Telescope lsp_definitions layout_strategy=vertical<CR>', 'Find definitions')
    end
})

vim.lsp.enable({
    'lua_ls',
    'clangd',
    'bashls',
    'ts_ls'
})
