require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {"clangd", "pyright", "rust_analyzer", "lua_ls"}
}

local lspconfig = require("lspconfig")
lspconfig.clangd.setup {}
lspconfig.pyright.setup {}
