local M = {}

-- Single persistent terminal: the buffer (and its shell) survives hiding the window
local state = { buf = nil, win = nil }

local function open_float(buf)
    -- Calculate dimensions for the floating window
    local width = vim.o.columns
    local height = vim.o.lines
    local win_width = math.ceil(width * 0.9)
    local win_height = math.ceil(height * 0.9)
    local row = math.ceil((height - win_height) / 2) - 1
    local col = math.ceil((width - win_width) / 2)

    return vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " Terminal ",
        title_pos = "center",
    })
end

function M.close()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_hide(state.win)
    end
    state.win = nil
end

function M.toggle()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        M.close()
        return
    end

    local new_term = not (state.buf and vim.api.nvim_buf_is_valid(state.buf))
    if new_term then
        -- Unlisted buffer so the terminal doesn't show up in :ls / Telescope buffers
        state.buf = vim.api.nvim_create_buf(false, true)
    end

    state.win = open_float(state.buf)

    if new_term then
        -- Run the user's shell; when it exits, clean up so the next toggle starts fresh
        vim.fn.termopen(vim.o.shell, {
            on_exit = function()
                M.close()
                if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
                    vim.api.nvim_buf_delete(state.buf, { force = true })
                end
                state.buf = nil
            end,
        })
        vim.keymap.set("t", "<C-q>", M.close, { buffer = state.buf, desc = "Close Floating Terminal" })
    end

    -- Start in terminal insert mode
    vim.cmd("startinsert")
end

function M.setup()
    vim.keymap.set("n", "<leader>tt", M.toggle, { desc = "Toggle Floating Terminal" })
end

return M
