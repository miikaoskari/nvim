-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- add your plugins here
        {
            "mason-org/mason-lspconfig.nvim",
            opts = {
                ensure_installed = { "lua_ls", "clangd", "yamlls", "pylsp" },
            },
            dependencies = {
                { "mason-org/mason.nvim", opts = {} },
                "neovim/nvim-lspconfig",
            },
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
        },
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.5',
            requires = { 'nvim-lua/plenary.nvim' }
        },
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "L3MON4D3/LuaSnip",
                {
                    'rafamadriz/friendly-snippets',
                    config = function()
                        require('luasnip.loaders.from_vscode').lazy_load()
                    end,
                },
            },
            config = function()
                -- See `:help cmp`
                local cmp = require 'cmp'
                local luasnip = require 'luasnip'
                luasnip.config.setup {}

                cmp.setup {
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },
                    completion = { completeopt = 'menu,menuone,noinsert' },

                    -- Please read `:help ins-completion`, it is really good!
                    mapping = cmp.mapping.preset.insert {
                        -- Select the [n]ext item
                        ['<C-n>'] = cmp.mapping.select_next_item(),
                        -- Select the [p]revious item
                        ['<C-p>'] = cmp.mapping.select_prev_item(),

                        -- Scroll the documentation window [b]ack / [f]orward
                        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-f>'] = cmp.mapping.scroll_docs(4),

                        -- Accept ([y]es) the completion.
                        --  This will auto-import if your LSP supports it.
                        --  This will expand snippets if the LSP sent a snippet.
                        ['<C-y>'] = cmp.mapping.confirm { select = true },

                        -- Manually trigger a completion from nvim-cmp.
                        --  Generally you don't need this, because nvim-cmp will display
                        --  completions whenever it has completion options available.
                        ['<C-Space>'] = cmp.mapping.complete {},

                        -- Think of <c-l> as moving to the right of your snippet expansion.
                        --  So if you have a snippet that's like:
                        --  function $name($args)
                        --    $body
                        --  end
                        --
                        -- <c-l> will move you to the right of each of the expansion locations.
                        -- <c-h> is similar, except moving you backwards.
                        ['<C-l>'] = cmp.mapping(function()
                            if luasnip.expand_or_locally_jumpable() then
                                luasnip.expand_or_jump()
                            end
                        end, { 'i', 's' }),
                        ['<C-h>'] = cmp.mapping(function()
                            if luasnip.locally_jumpable(-1) then
                                luasnip.jump(-1)
                            end
                        end, { 'i', 's' }),
                    },
                    sources = {
                        { name = 'nvim_lsp' },
                        { name = 'luasnip' },
                        { name = 'buffer' },
                        { name = 'path' },
                    },
                }
            end,
        },
        {
            'stevearc/oil.nvim',
            opts = {},
            dependencies = { { "nvim-mini/mini.icons", opts = {} } },
            lazy = false,
        },
        { 'nvim-mini/mini.tabline',    version = '*', opts = {} },
        { 'nvim-mini/mini.statusline', version = '*', opts = {} },
        { 'nvim-mini/mini.surround',   version = '*', opts = {} },
        { 'nvim-mini/mini.pairs',      version = '*', opts = {} },
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
            keys = {
                {
                    "<leader>?",
                    function()
                        require("which-key").show({ global = false })
                    end,
                    desc = "Buffer Local Keymaps (which-key)",
                },
            },
        },
        { 'rebelot/kanagawa.nvim', name = 'kanagawa', priority = 1000 },
        { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "kanagawa" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
})

vim.cmd.colorscheme "kanagawa"

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

-- **Hover & Documentation**
vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- **Code Actions & Formatting**
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
-- vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, { desc = "Format File" })

-- **Diagnostics (Errors & Warnings)**
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostic Popup" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Show Diagnostics List" })

vim.keymap.set("n", "<leader>fe", ":Oil<CR>", { desc = "File Explorer (Oil)" })

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.signcolumn = "yes"
