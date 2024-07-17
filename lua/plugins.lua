require("lazy").setup({
    -- git
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "lewis6991/gitsigns.nvim",

    -- file tree
    "nvim-tree/nvim-tree.lua",
    -- telescope
    {
        "nvim-telescope/telescope.nvim", tag = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    -- lsp
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "zbirenbaum/copilot.lua",
        },
    },
    -- cmp
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "zbirenbaum/copilot-cmp",
        },
    },
    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
    },
}, {})
