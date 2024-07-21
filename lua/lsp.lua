require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {"clangd", "pyright", "rust_analyzer", "lua_ls", "tsserver"}
}

local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.clangd.setup {
  capabilities = capabilities,
}
lspconfig.pyright.setup {
  capabilities = capabilities,
}

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
}

lspconfig.lua_ls.setup {
  capabilities = capabilities,
}

lspconfig.tsserver.setup {
  capabilities = capabilities,
}

