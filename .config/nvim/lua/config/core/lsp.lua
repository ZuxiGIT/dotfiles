-- get cmp capabilities if available
local function get_capabilities()
  local ok, cmp_nvim_lsp_module = pcall(require, 'cmp_nvim_lsp')
  if ok and cmp_nvim_lsp_module then
    return cmp_nvim_lsp_module.default_capabilities()
  end
  return {}
end

local lsp_capabilities = get_capabilities()

-- redefine clangd launch cmd
vim.lsp.config('clangd', {
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy'
    },
    capabilities = lsp_capabilities
})

-- add globals to lua lsp
vim.lsp.config('lua_ls', {
    capabilities = lsp_capabilities,
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

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('documentSymbolProvider') then
            require('nvim-navic').attach(client, ev.buf)
        end

        local utils = require('utils')
        local nmap  = utils.nmap
        local map   = utils.map
        local lsp_opts = { buffer = ev.buf, silent = true }

        nmap('gd', vim.lsp.buf.definition, 'Go to definition', lsp_opts)

        nmap('H', vim.lsp.buf.hover, 'Hover information for word under cursor', lsp_opts)
        nmap('K', vim.lsp.buf.signature_help, 'Signature information', lsp_opts)
        nmap('<space>e', vim.diagnostic.open_float, 'Show diagnostics in a floating window.', lsp_opts)
        nmap('<space>q', vim.diagnostic.setloclist, 'Add buffer diagnostics to the location list.', lsp_opts)
        nmap('<space>D', vim.lsp.buf.type_definition, 'Jumps to the definition of the type of the symbol', lsp_opts)
        nmap('<space>rn', vim.lsp.buf.rename, 'Rename all references', lsp_opts)
        map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, 'Select a code action', lsp_opts)
        nmap('<space>ft', function() vim.lsp.buf.format { async = true } end, 'Format code', lsp_opts)

        nmap('<leader>fr', ':Telescope lsp_references layout_strategy=vertical<CR>', 'Find references', lsp_opts)
        nmap('<leader>fd', ':Telescope lsp_definitions layout_strategy=vertical<CR>', 'Find definitions', lsp_opts)
    end
})

local shared_config_servers = { 'bashls', 'ts_ls', 'pylsp', 'perlnavigator' }

for _, server in ipairs(shared_config_servers) do
    vim.lsp.config(server, {
        capabilities = lsp_capabilities
    })
end

vim.lsp.enable(vim.list_extend({ 'lua_ls', 'clangd' }, shared_config_servers))

