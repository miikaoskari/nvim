require("copilot").setup()
require("copilot_cmp").setup()

local cmp = require("cmp")

cmp.setup({
    sources = {
      { name = "nvim_lsp" },
      { name = "buffer"},
      { name = "path" },
      { name = "copilot"},
    },
    mapping = cmp.mapping.preset.insert({
        -- C = control

        -- Select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        ['<CR>'] = cmp.mapping.confirm {
            select = true
        },
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item()
    })
})
