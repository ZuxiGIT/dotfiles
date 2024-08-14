local utils = require('utils')
local nmap  = utils.nmap

return {
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    config = function()
        local lspconfig = require('lspconfig')
        lspconfig.clangd.setup{}

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }

                nmap('[d', vim.diagnostic.goto_prev, 'Move to the previous diagnostic in the current buffer', opts)
                nmap(']d', vim.diagnostic.goto_next, 'Move to the next diagnostic in the current buffer', opts)
                nmap('gD', vim.lsp.buf.declaration, 'Go to declaration', opts)
                nmap('gd', vim.lsp.buf.definition, 'Go to definition', opts)
                nmap('gi', vim.lsp.buf.implementation, 'List all implementations', opts)
                nmap('gr', vim.lsp.buf.references, 'List all references', opts)

                nmap('K', vim.lsp.buf.hover, 'Hover information', opts)
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature information', opts)
                nmap('<space>e', vim.diagnostic.open_float, 'Show diagnostics in a floating window.', opts)
                nmap('<space>q', vim.diagnostic.setloclist, 'Add buffer diagnostics to the location list.', opts)
                nmap('<space>D', vim.lsp.buf.type_definition, 'Jumps to the definition of the type of the symbol', opts)
                nmap('<space>rn', vim.lsp.buf.rename, 'Rename all references', opts)
                map({'n', 'v'}, '<space>ca', vim.lsp.buf.code_action, 'Select a code action', opts)
                nmap('<space>ft', function() vim.lsp.buf.format { async = true } end, 'Format', opts)

                nmap('<leader>fr', ":Telescope lsp_references {layout_strategy='vertical'}<CR>", 'Find references')
                nmap('<leader>fd', ":Telescope lsp_definitions {layout_strategy='vertical'}<CR>", 'Find definitions')

        end,
        })
    end
}
