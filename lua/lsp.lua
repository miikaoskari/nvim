require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {"clangd", "pyright"},
}

local lspconfig = require("lspconfig")
lspconfig.clangd.setup {}
lspconfig.pyright.setup {}