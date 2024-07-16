vim.g.mapleader = " "
vim.g.maplocalleader = " "

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})

local tree = require('nvim-tree.api')
vim.keymap.set('n', '<leader>ee', tree.tree.toggle, {})

--local cmp = require('cmp')
--vim.keymap.set('i', '<Tab>', cmp.mapping.select_next_item(), { expr = true })


