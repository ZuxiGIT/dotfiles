local ensure_installed = {
    "clangd", "lua_ls"
}

require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
