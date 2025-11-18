-- Early color initialization to ensure our theme is applied
local function apply_colors()
    -- Set background
    vim.o.background = "dark"
    
    -- Apply base highlights immediately
    vim.api.nvim_set_hl(0, "Normal", { bg = "#21262b", fg = "#e0e0e0" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1e23", fg = "#e0e0e0" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#21262b", fg = "#e0e0e0" })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370", bg = "#21262b" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "#21262b" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#4b5263", bg = "#21262b" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#21262b" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1a1e23", fg = "#4b5263" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2c313c" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bg = "#2c313c", bold = true })
end

-- Apply immediately
apply_colors()

-- Export for use elsewhere
return {
    apply_colors = apply_colors
}