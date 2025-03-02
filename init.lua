-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- Load plugins
require("lazy").setup("plugins")

-- Keymap for reloading config
vim.keymap.set("n", "<leader>r", function()
    for name, _ in pairs(package.loaded) do
        if name:match("^user") or name:match("^plugins") then
            package.loaded[name] = nil
        end
    end
    vim.cmd("source $MYVIMRC")
    print("Neovim configuration reloaded!")
end, { desc = "Reload Neovim Config" })

vim.cmd([[
  aunmenu PopUp
  vnoremenu PopUp.Cut           "+x
  vnoremenu PopUp.Copy          "+y
  nnoremenu PopUp.Paste         "+gP
  inoremenu PopUp.Paste         <C-R>+
  cnoremenu PopUp.Paste         <C-R>+
  vnoremenu PopUp.Paste         "+P

  " LSP Actions in Right-Click Menu
  nnoremenu PopUp.Go\ to\ Definition :lua vim.lsp.buf.definition()<CR>
  nnoremenu PopUp.Find\ References   :lua vim.lsp.buf.references()<CR>
  nnoremenu PopUp.Hover\ Documentation :lua vim.lsp.buf.hover()<CR>
  nnoremenu PopUp.Rename\ Symbol      :lua vim.lsp.buf.rename()<CR>
  nnoremenu PopUp.Code\ Actions       :lua vim.lsp.buf.code_action()<CR>
]])

-- Keybindings
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set('n', '<leader><leader>', ":Telescope buffers<CR>", { desc = 'Find existing buffers' })
vim.keymap.set("n", "<leader>fe", ":Oil<CR>", { desc = "File Explorer (Oil)" })

-- Git
vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Git Blame Toggle" })

-- Buffer Management
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Close Buffer" })

-- Window Splits
vim.keymap.set("n", "<leader>ws", ":split<CR>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>wq", ":q<CR>", { desc = "Close Window" })

-- Surround
vim.keymap.set("n", "sa", "<cmd>lua require('mini.surround').add()<CR>", { desc = "Add Surround" })
vim.keymap.set("n", "sd", "<cmd>lua require('mini.surround').delete()<CR>", { desc = "Delete Surround" })
vim.keymap.set("n", "sr", "<cmd>lua require('mini.surround').replace()<CR>", { desc = "Replace Surround" })
vim.keymap.set("n", "sf", "<cmd>lua require('mini.surround').find()<CR>", { desc = "Find Surround" })
vim.keymap.set("n", "sn", "<cmd>lua require('mini.surround').find_nearest()<CR>", { desc = "Find Nearest Surround" })

-- Debugging (DAP)
vim.keymap.set("n", "<leader>xb", ":DapToggleBreakpoint<CR>", { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>xc", ":DapContinue<CR>", { desc = "Continue" })
vim.keymap.set("n", "<leader>xi", ":DapStepInto<CR>", { desc = "Step Into" })
vim.keymap.set("n", "<leader>xo", ":DapStepOver<CR>", { desc = "Step Over" })
vim.keymap.set("n", "<leader>xr", ":DapRestartFrame<CR>", { desc = "Restart Frame" })

