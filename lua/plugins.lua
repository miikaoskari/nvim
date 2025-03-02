return {
    -- Lazy manages itself
    { "folke/lazy.nvim" },

    -- Colorscheme
    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.cmd("colorscheme kanagawa-wave")
        end
    },

    -- LSP Config
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- Common on_attach function (Keybinds & Settings)
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, noremap = true, silent = true }

                -- **Navigation & Definitions**
                vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
                vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
                vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find References" })
                vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
                vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
                vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

                -- **Hover & Documentation**
                vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)      -- Show hover docs
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts) -- Signature help

                -- **Code Actions & Formatting**
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)                           -- Show code actions
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)                                -- Rename symbol
                vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts) -- Format file

                -- **Diagnostics (Errors & Warnings)**
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)         -- Previous diagnostic
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)         -- Next diagnostic
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts) -- Show diagnostic popup
                vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts) -- Show diagnostics list
            end

            -- LSP Servers
            local servers = {
                clangd = {},        -- C/C++
                pyright = {},       -- Python
                rust_analyzer = {}, -- Rust
                lua_ls = {          -- Lua config
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } }, -- Recognize `vim` as a global variable
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                        },
                    },
                },
                ts_ls = {},   -- JavaScript/TypeScript
                asm_lsp = {}, -- Assembly LSP
            }

            -- Set up all servers
            for server, config in pairs(servers) do
                lspconfig[server].setup(vim.tbl_deep_extend("force", {
                    on_attach = on_attach,
                    capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Enable autocompletion
                }, config))
            end
        end,
    },

    -- Copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<M-y>",
                    accept_word = false,
                    accept_line = false,
                    next = "<M-n>",
                    prev = "<M-p>",
                    dismiss = "<M-x>",
                },
            },
            panel = { enabled = true },
        },
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = { "zbirenbaum/copilot.lua" },
        opts = {},
        cmd = { "CopilotChat" }
    },

    -- Autocompletion
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

    -- Debugging (DAP)
    { "mfussenegger/nvim-dap" },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require("dapui").setup()
        end
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "cpp", "python", "rust", "lua", "javascript", "typescript" },
                highlight = { enable = true }
            })
        end
    },

    -- Mason
    {
        "williamboman/mason.nvim",
        opts = {}
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls", "pyright", "rust_analyzer", "clangd", "ts_ls" },
            automatic_installation = true,
        },
    },

    -- File manager (Oil.nvim)
    {
        'stevearc/oil.nvim',
        opts = {}, -- This passes an empty config table (can be filled with settings)

        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },

        -- Lazy loading is not recommended
        lazy = false,
    },

    -- Fuzzy Finder (Telescope)
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup()

            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')
        end
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },

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

    -- mini.nvim pack
    {
        "echasnovski/mini.nvim",
        config = function()
            require("mini.statusline").setup()
            require('mini.statusline').setup {
                use_icons = vim.g.have_nerd_font,
                content = {
                    -- Add a custom section to display the current tab or space count
                    active = function()
                        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                        local git = MiniStatusline.section_git({ trunc_width = 75 })
                        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
                        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
                        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
                        local location = MiniStatusline.section_location({ trunc_width = 75 })

                        -- Custom section to display tab or space count
                        local tabwidth = vim.bo.expandtab and "Spaces: " .. vim.bo.shiftwidth or
                            "Tab: " .. vim.bo.tabstop

                        return MiniStatusline.combine_groups({
                            { hl = mode_hl,                 strings = { mode } },
                            { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
                            '%<', -- Mark general truncate point
                            { hl = 'MiniStatuslineFilename', strings = { filename } },
                            '%=', -- End left alignment
                            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo, tabwidth } },
                            { hl = mode_hl,                  strings = { location } },
                        })
                    end,
                },
            }
            require("mini.cursorword").setup()
            require("mini.pairs").setup()
            require("mini.surround").setup()
        end
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },

    {
        "mg979/vim-visual-multi",
        branch = "master"
    },
}
