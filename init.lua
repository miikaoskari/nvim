-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading plugins so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Plugins (managed by vim.pack, see :help vim.pack)
vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-telescope/telescope.nvim", version = vim.version.range("*") },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-mini/mini.icons",   version = vim.version.range("*") },
    { src = "https://github.com/nvim-mini/mini.surround", version = vim.version.range("*") },
    { src = "https://github.com/nvim-mini/mini.pairs",    version = vim.version.range("*") },
    { src = "https://github.com/rebelot/kanagawa.nvim" },
    { src = "https://github.com/folke/zen-mode.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

vim.cmd.colorscheme("cforge")

require("mini.icons").setup({ style = "ascii" })
require("mini.surround").setup()
require("mini.pairs").setup()

require("oil").setup()
require('gitsigns').setup {
	signs = {
		add = { text = '+' }, ---@diagnostic disable-line: missing-fields
		change = { text = '~' }, ---@diagnostic disable-line: missing-fields
		delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
		topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
		changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
	},
	signs_staged_enable = false,
}

-- [[ LSP servers ]]
-- Configs come from nvim-lspconfig; servers must be installed locally and on $PATH.
vim.lsp.enable({ "clangd", "rust_analyzer" })

-- [[ Snippet Engine ]]
require("luasnip").setup {}

-- [[ Autocomplete Engine ]]
-- See `:help blink-cmp-config-keymap`
require("blink.cmp").setup {
    keymap = { preset = "default" },

    appearance = {
        nerd_font_variant = "mono",
    },

    completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
        default = { "lsp", "path", "snippets" },
    },

    snippets = { preset = "luasnip" },

    fuzzy = { implementation = "lua" },

    signature = { enabled = true },
}

-- Treesitter: install parsers, auto-enable highlight/folds/indent per filetype
require("nvim-treesitter").install({
    "lua", "vim", "vimdoc", "query",
    "bash", "markdown", "markdown_inline", "json", "yaml",
    "c", "cpp", "rust"
})

vim.opt.foldlevelstart = 99 -- don't start files folded

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo[0][0].foldmethod = "expr"
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

require("statusline").setup()

require("zen-mode").setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fc', function() builtin.colorscheme({ enable_preview = true }) end, { desc = 'Telescope colorschemes' })
vim.keymap.set('n', '<leader>fm', builtin.man_pages, { desc = 'Telescope man pages'})

-- **Navigation & Definitions**
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find References" })
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- **Code Actions & Formatting**
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
-- vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, { desc = "Format File" })

-- **Diagnostics (Errors & Warnings)**
-- No gutter icons: keep the sign column for gitsigns only. Errors/warnings
-- still show via underline and virtual text.
vim.diagnostic.config({ signs = false })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostic Popup" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Show Diagnostics List" })

vim.keymap.set("n", "<leader>fe", ":Oil<CR>", { desc = "File Explorer (Oil)" })

-- **Gitsigns (hunk nav/preview/stage)**
local gitsigns = require("gitsigns")
vim.keymap.set("n", "]c", function()
    if vim.wo.diff then return "]c" end
    vim.schedule(gitsigns.next_hunk)
    return "<Ignore>"
end, { expr = true, desc = "Next Hunk" })
vim.keymap.set("n", "[c", function()
    if vim.wo.diff then return "[c" end
    vim.schedule(gitsigns.prev_hunk)
    return "<Ignore>"
end, { expr = true, desc = "Previous Hunk" })
vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
vim.keymap.set("v", "<leader>hs", function() gitsigns.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Stage Hunk" })
vim.keymap.set("v", "<leader>hr", function() gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>hb", function() gitsigns.blame_line { full = true } end, { desc = "Blame Line" })
vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })
vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Line Blame" })

require("gitui").setup()

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.signcolumn = "yes"
