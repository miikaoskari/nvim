local M = {}

function M.open()
    -- Calculate dimensions for the floating window
    local width = vim.o.columns
    local height = vim.o.lines
    local win_width = math.ceil(width * 0.9)
    local win_height = math.ceil(height * 0.9)
    local row = math.ceil((height - win_height) / 2) - 1
    local col = math.ceil((width - win_width) / 2)

    -- Create a scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Open the floating window
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " GitUI ",
        title_pos = "center",
    })

    -- Run gitui in a terminal inside the buffer
    vim.fn.termopen("gitui", {
        on_exit = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
            if vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end,
    })

    -- Start in terminal insert mode
    vim.cmd("startinsert")
end

function M.setup()
    vim.keymap.set("n", "<leader>gg", M.open, { desc = "Open GitUI (Floating)" })
end

return M
