-- floaterminal.lua

local M = {}

--- Creates a floating window, optionally at a given size.
-- @param opts table with optional 'width' and 'height' keys
function M.create_floating_window(opts)
    opts = opts or {}

    -- Default to 80% of the screen if no width/height is specified
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    -- Calculate center coordinates
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create a new, empty (scratch) buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Window configuration
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded", -- You can set this to "single", "double", etc.
    }

    -- Create the floating window and enter it
    local win = vim.api.nvim_open_win(buf, true, win_config)

    return buf, win
end

return M

