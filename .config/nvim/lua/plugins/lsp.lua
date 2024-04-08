return {
    {
        'williamboman/mason.nvim',
        config = true
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = ensure_installed
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.clangd.setup{}

            local wk = require('which-key')
            wk.register({
            }, {})

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
                local wk = require('which-key')
                wk.register({
                    ["[d"] = { vim.diagnostic.goto_prev, "Move to the previous diagnostic in the current buffer", opts },
                    ["]d"] = { vim.diagnostic.goto_next, "Move to the next diagnostic in the current buffer", opts },
                    g = {
                        D = { vim.lsp.buf.declaration, "Go to declaration", opts },
                        d = { vim.lsp.buf.definition, "Go to definition", opts },
                        i = { vim.lsp.buf.implementation, "List all implementations", opts},
                        r = { vim.lsp.buf.references, "List all references", opts },
                    },
                    K = { vim.lsp.buf.hover, "Hover information", opts },
                    ['<C-k>'] = { vim.lsp.buf.signature_help, "Signature information", opts },
                    ['<space>'] = {
                        e = { vim.diagnostic.open_float, "Show diagnostics in a floating window.", opts },
                        q = { vim.diagnostic.setloclist, "Add buffer diagnostics to the location list.", opts },
                        w = {
                            a = {
                                    vim.lsp.buf.add_workspace_folder,
                                    "Add the folder at path to the workspace folders.",
                                    opts
                            },
                            r = {
                                    vim.lsp.buf.remove_workspace_folder,
                                    "Remove the folder at path to the workspace folders.",
                                    opts
                            },
                            l = {
                                    function()
                                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                                    end,
                                    "List workspace folders.",
                                    opts
                            },
                        },
                        D = {
                                vim.lsp.buf.type_definition,
                                "Jumps to the definition of the type of the symbol",
                                opts
                        },
                        ['rn'] = { vim.lsp.buf.rename, "Rename all references", opts },
                        ['ca'] = { vim.lsp.buf.code_action, "Select a code action", opts, mode='v' },
                        f = { function() vim.lsp.buf.format { async = true } end, "Format", opts},
                    }
                })
                end,
            })
        end
    }
}
