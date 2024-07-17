local ts = require("nvim-treesitter.configs")

ts.setup {
    build = ":TSUpdate",
    ensure_installed = { "python", "c", "cpp", "lua", "bash", "json", "yaml", "html", "css", "javascript", "typescript", "rust", "go", "java" },
    auto_install = true,
    highlight = {
        enable = true,
    },
}
