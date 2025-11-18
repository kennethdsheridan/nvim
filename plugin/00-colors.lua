-- This file loads early in the plugin directory to ensure colors are set

-- Define ColorMyPencils globally
_G.ColorMyPencils = function(color)
    color = color or "kanagawa"

    -- Handle catppuccin specially
    if color == "catppuccin" or color:find("catppuccin") then
        vim.o.background = "dark"
        local flavour = color:match("catppuccin%-(%w+)") or "latte"
        require("catppuccin").setup({ flavour = flavour })
        vim.cmd.colorscheme("catppuccin")
        return
    end

    -- Handle nord specially
    if color == "nord" then
        vim.o.background = "dark"
        vim.cmd.colorscheme("nord")
        return
    end

    -- Set dark background for other themes
    vim.o.background = "dark"

    -- Apply colorscheme
    vim.cmd.colorscheme(color)
    
    -- Custom highlight groups with #21262b background and better contrast
    -- Main text - brighter for better contrast without eye strain
    vim.api.nvim_set_hl(0, "Normal", { bg = "#21262b", fg = "#e0e0e0" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#21262b", fg = "#e0e0e0" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#21262b", fg = "#e0e0e0" })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370", bg = "#21262b" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "#21262b" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#4b5263", bg = "#21262b" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#21262b" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#21262b", fg = "#4b5263" })
    
    -- Enhanced syntax colors for better readability
    vim.api.nvim_set_hl(0, "Statement", { fg = "#69b7f0", bold = true })
    vim.api.nvim_set_hl(0, "Function", { fg = "#69b7f0" })
    vim.api.nvim_set_hl(0, "Keyword", { fg = "#69b7f0", bold = true })
    vim.api.nvim_set_hl(0, "String", { fg = "#89ca78" })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#6b737f", italic = true })
    vim.api.nvim_set_hl(0, "Number", { fg = "#d19a66" })
    vim.api.nvim_set_hl(0, "Constant", { fg = "#e06c75" })
    vim.api.nvim_set_hl(0, "Type", { fg = "#46d9d9" })
    vim.api.nvim_set_hl(0, "Identifier", { fg = "#d0d0d0" })
    
    -- Better cursor visibility
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2c313c" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bg = "#2c313c", bold = true })
end

-- Apply immediately when Neovim starts
vim.api.nvim_create_autocmd({"VimEnter", "UIEnter"}, {
    once = true,
    callback = function()
        -- Small delay to ensure all plugins are loaded
        vim.defer_fn(function()
            ColorMyPencils()
        end, 10)
    end,
    desc = "Apply custom colors on startup"
})

-- Also apply immediately for when this file is sourced
vim.defer_fn(function()
    ColorMyPencils()
end, 0)