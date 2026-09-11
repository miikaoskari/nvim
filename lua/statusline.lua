local M = {}

local mode_names = {
    n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK",
    c = "COMMAND", R = "REPLACE", t = "TERMINAL", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK",
}

local mode_highlights = {
    n = "StatuslineModeNormal",
    i = "StatuslineModeInsert",
    v = "StatuslineModeVisual", V = "StatuslineModeVisual", ["\22"] = "StatuslineModeVisual",
    c = "StatuslineModeCommand",
    R = "StatuslineModeReplace",
    t = "StatuslineModeTerminal",
    s = "StatuslineModeVisual", S = "StatuslineModeVisual", ["\19"] = "StatuslineModeVisual",
}

-- Colors picked to match the kanagawa colorscheme.
local mode_colors = {
    StatuslineModeNormal = "#7e9cd8",
    StatuslineModeInsert = "#98bb6c",
    StatuslineModeVisual = "#957fb8",
    StatuslineModeCommand = "#e6c384",
    StatuslineModeReplace = "#c34043",
    StatuslineModeTerminal = "#ff9e3b",
}

local function set_highlights()
    for group, color in pairs(mode_colors) do
        vim.api.nvim_set_hl(0, group, { fg = "#1f1f28", bg = color, bold = true })
    end
end

local fileformat_names = {
    unix = "LF",
    dos = "CRLF",
    mac = "CR",
}

local function indent_info()
    local width = vim.bo.shiftwidth > 0 and vim.bo.shiftwidth or vim.bo.tabstop
    return (vim.bo.expandtab and "Spaces:" or "Tabs:") .. width
end

local function diagnostics()
    local counts = vim.diagnostic.count(0)
    local err = counts[vim.diagnostic.severity.ERROR] or 0
    local warn = counts[vim.diagnostic.severity.WARN] or 0
    local parts = {}
    if err > 0 then table.insert(parts, "E:" .. err) end
    if warn > 0 then table.insert(parts, "W:" .. warn) end
    return #parts > 0 and (table.concat(parts, " ") .. " │ ") or ""
end

function M.render()
    local mode_code = vim.fn.mode()
    local mode = mode_names[mode_code] or mode_code
    local hl = mode_highlights[mode_code] or "StatuslineModeNormal"
    local filename = vim.fn.expand("%:t")
    if filename == "" then filename = "[No Name]" end
    filename = filename:gsub("%%", "%%%%")
    local modified = vim.bo.modified and " [+]" or ""
    local readonly = vim.bo.readonly and " [RO]" or ""
    local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "none"
    local fileformat = fileformat_names[vim.bo.fileformat] or vim.bo.fileformat

    return table.concat({
        "%#", hl, "# ", mode, " %* │ ", filename, modified, readonly,
        "%=",
        diagnostics(),
        filetype, " │ ", fileformat, " │ ", indent_info(), " │ %l:%c │ %p%% ",
    })
end

function M.setup()
    _G.Statusline = M.render
    set_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
    vim.opt.laststatus = 3
    vim.opt.statusline = "%!v:lua.Statusline()"
end

return M
