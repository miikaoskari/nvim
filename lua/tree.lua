return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>ee', ':Neotree toggle<CR>', desc = 'Toggle tr[ee]', silent = true },
    { '<leader>ef', ':Neotree toggle float<CR>', desc = 'Toggle tr[e]e [f]loat', silent = true },
    { '<leader>er', ':Neotree toggle right<CR>', desc = 'Toggle tr[e]e [r]ight', silent = true },
    { '<leader>el', ':Neotree toggle right<CR>', desc = 'Toggle tr[e]e [l]eft', silent = true },
  },
  opts = {
    use_libuv_file_watcher = true,
    follow_current_file = {
      enable = true,
    },
    filesystem = {
      window = {
        mappings = {
        },
      },
    },
  },
}
