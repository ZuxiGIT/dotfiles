local utils = require('utils')
local nmap  = utils.nmap
local map  = utils.map

local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, bufnr)
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = bufnr }
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    nmap('[d', vim.diagnostic.goto_prev, 'Move to the previous diagnostic in the current buffer', opts)
    nmap(']d', vim.diagnostic.goto_next, 'Move to the next diagnostic in the current buffer', opts)
    nmap('gd', vim.lsp.buf.definition, 'Go to definition', opts)
    nmap('gr', vim.lsp.buf.references, 'List all references', opts)

    nmap('K', vim.lsp.buf.hover, 'Hover information for word under cursor', opts)
    nmap('<c-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.hover()<cr>', 'ctrl-click to hover info')
    nmap('I', vim.lsp.buf.signature_help, 'Signature information', opts)
    nmap('<space>e', vim.diagnostic.open_float, 'Show diagnostics in a floating window.', opts)
    nmap('<space>q', vim.diagnostic.setloclist, 'Add buffer diagnostics to the location list.', opts)
    nmap('<space>rn', vim.lsp.buf.rename, 'Rename all references', opts)
    nmap('<space>ft', function() vim.lsp.buf.format { async = true } end, 'Format code', opts)

    nmap('<leader>fr', ':Telescope lsp_references {layout_strategy=\'vertical\'}<CR>', 'Find references')
    nmap('<leader>fd', ':Telescope lsp_definitions {layout_strategy=\'vertical\'}<CR>', 'Find definitions')
end

local mason_handlers = {
    function (server_name) -- default handler (optional)
        local lspconfig = require('lspconfig')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
}

return {
    {
        'williamboman/mason.nvim',
        config = true
    },
    {
        'j-hui/fidget.nvim',
        config = true,
    },
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                }),
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-l>"] = cmp.mapping.confirm({ select = true }),
                }),
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'SmiteshP/nvim-navic',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/nvim-cmp',
            'j-hui/fidget.nvim',
        },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'texlab'
                }
            })
            require('mason-lspconfig').setup_handlers(mason_handlers)
        end
    }
}
