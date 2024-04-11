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
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { desc = desc})
                end
                local opts = { buffer = ev.buf }

                map('n', '[d', vim.diagnostic.goto_prev, 'Move to the previous diagnostic in the current buffer', opts)
                map('n', ']d', vim.diagnostic.goto_next, 'Move to the next diagnostic in the current buffer', opts)
                map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration', opts)
                map('n', 'gd', vim.lsp.buf.definition, 'Go to definition', opts)
                map('n', 'gi', vim.lsp.buf.implementation, 'List all implementations', opts)
                map('n', 'gr', vim.lsp.buf.references, 'List all references', opts)

                map('n', 'K', vim.lsp.buf.hover, 'Hover information', opts)
                map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature information', opts)
                map('n', '<space>e', vim.diagnostic.open_float, 'Show diagnostics in a floating window.', opts)
                map('n', '<space>q', vim.diagnostic.setloclist, 'Add buffer diagnostics to the location list.', opts)
                map('n', '<space>D', vim.lsp.buf.type_definition, 'Jumps to the definition of the type of the symbol', opts)
                map('n', '<space>rn', vim.lsp.buf.rename, 'Rename all references', opts)
                map({'n', 'v'}, '<space>ca', vim.lsp.buf.code_action, 'Select a code action', opts)
                map('n', '<space>ft', function() vim.lsp.buf.format { async = true } end, 'Format', opts)
        end,
        })
    end
}
