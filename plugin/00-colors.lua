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
    
    -- Beautiful hover window styling
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1e23", fg = "#e0e0e0" })  -- Darker than main background
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1a1e23", fg = "#4b5263" })
    vim.api.nvim_set_hl(0, "FloatTitle", { bg = "#1a1e23", fg = "#69b7f0", bold = true })
    
    -- LSP hover specific highlights for better readability
    vim.api.nvim_set_hl(0, "LspInfoBorder", { bg = "#1a1e23", fg = "#4b5263" })
    
    -- Markdown styling in hover docs
    vim.api.nvim_set_hl(0, "@markup.heading", { fg = "#69b7f0", bold = true })
    vim.api.nvim_set_hl(0, "@markup.strong", { fg = "#e06c75", bold = true })
    vim.api.nvim_set_hl(0, "@markup.italic", { fg = "#89ca78", italic = true })
    vim.api.nvim_set_hl(0, "@markup.raw", { bg = "#2c313c", fg = "#d19a66" })
    vim.api.nvim_set_hl(0, "@markup.raw.block", { bg = "#2c313c", fg = "#d19a66" })
    vim.api.nvim_set_hl(0, "@markup.link", { fg = "#46d9d9", underline = true })
    vim.api.nvim_set_hl(0, "@markup.list", { fg = "#69b7f0" })
    
    -- Code blocks in documentation
    vim.api.nvim_set_hl(0, "@lsp.type.class", { fg = "#46d9d9", bold = true })
    vim.api.nvim_set_hl(0, "@lsp.type.function", { fg = "#69b7f0" })
    vim.api.nvim_set_hl(0, "@lsp.type.method", { fg = "#69b7f0" })
    vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = "#f0b752" })
    vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "#d0d0d0" })
    vim.api.nvim_set_hl(0, "@lsp.type.keyword", { fg = "#e06c75", bold = true })
end

-- Apply colors multiple times to ensure they stick
-- Immediately when this file loads
ColorMyPencils()

-- After a tiny delay
vim.defer_fn(function()
    ColorMyPencils()
end, 1)

-- When UI is ready
vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        ColorMyPencils()
    end,
})

-- When Vim fully enters
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.schedule(function()
            ColorMyPencils()
        end)
    end,
})

-- After colorscheme changes (in case another plugin overrides)
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.defer_fn(function()
            -- Reapply our custom highlights
            vim.api.nvim_set_hl(0, "Normal", { bg = "#21262b", fg = "#e0e0e0" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1e23", fg = "#e0e0e0" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "#21262b", fg = "#e0e0e0" })
            vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370", bg = "#21262b" })
            vim.api.nvim_set_hl(0, "SignColumn", { bg = "#21262b" })
            vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#21262b" })
        end, 1)
    end,
})