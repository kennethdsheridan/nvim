-- ColorMyPencils is defined in plugin/00-colors.lua
-- This file just contains additional configuration
local function setup_additional_highlights()
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
    
    -- Custom highlight groups for a relaxed dark theme with good contrast
    -- Dark background with brighter text for better readability
    vim.api.nvim_set_hl(0, "Normal", { bg = "#21262b", fg = "#e0e0e0" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#21262b", fg = "#e0e0e0" })
    
    -- Enhanced contrast syntax highlighting for dark background
    vim.api.nvim_set_hl(0, "Statement", { fg = "#69b7f0", bold = true })  -- Keywords in brighter blue
    vim.api.nvim_set_hl(0, "Function", { fg = "#69b7f0" })               -- Functions in brighter blue
    vim.api.nvim_set_hl(0, "Keyword", { fg = "#69b7f0", bold = true })   -- Keywords in brighter blue
    
    -- Better contrast for variables and identifiers
    vim.api.nvim_set_hl(0, "Identifier", { fg = "#d0d0d0" })             -- Variables in light gray
    vim.api.nvim_set_hl(0, "@variable", { fg = "#d0d0d0" })              -- TreeSitter variables
    vim.api.nvim_set_hl(0, "@parameter", { fg = "#f0b752" })             -- Function parameters in warm yellow
    vim.api.nvim_set_hl(0, "@field", { fg = "#d0d0d0" })                 -- Object fields
    vim.api.nvim_set_hl(0, "@property", { fg = "#d0d0d0" })              -- Properties
    
    -- Strings and literals in brighter green for contrast
    vim.api.nvim_set_hl(0, "String", { fg = "#89ca78" })
    vim.api.nvim_set_hl(0, "@string", { fg = "#89ca78" })
    
    -- Comments in warmer gray (easier on eyes but still readable)
    vim.api.nvim_set_hl(0, "Comment", { fg = "#6b737f", italic = true })
    vim.api.nvim_set_hl(0, "@comment", { fg = "#6b737f", italic = true })
    
    -- Numbers and constants in brighter purple
    vim.api.nvim_set_hl(0, "Number", { fg = "#d19a66" })  -- Warm orange for numbers
    vim.api.nvim_set_hl(0, "Constant", { fg = "#e06c75" })  -- Soft red for constants
    vim.api.nvim_set_hl(0, "@constant", { fg = "#e06c75" })
    vim.api.nvim_set_hl(0, "Boolean", { fg = "#d19a66" })
    
    -- Types in brighter cyan
    vim.api.nvim_set_hl(0, "Type", { fg = "#46d9d9" })
    vim.api.nvim_set_hl(0, "@type", { fg = "#46d9d9" })
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = "#46d9d9" })
    
    -- Operators and delimiters
    vim.api.nvim_set_hl(0, "Operator", { fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "Delimiter", { fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "@operator", { fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "@punctuation", { fg = "#abb2bf" })
    
    -- Line numbers and UI elements
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370", bg = "#21262b" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2c313c" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#abb2bf", bg = "#2c313c", bold = true })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "#21262b" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#3e4452", bg = "#21262b" })
    
    -- Status line
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#3e4452", fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#353b45", fg = "#5c6370" })
    
    -- Visual selection
    vim.api.nvim_set_hl(0, "Visual", { bg = "#3e4452" })
    
    -- Additional UI elements with better contrast
    vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#21262b" })  -- Hide ~ at end of buffer
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "#2c313c", fg = "#e0e0e0" })  -- Popup menu
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#3e4452", fg = "#ffffff" })  -- Selected item in popup
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#21262b", fg = "#4b5263" })  -- Floating window borders (brighter)
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#21262b", fg = "#e0e0e0" })  -- Non-current windows
    vim.api.nvim_set_hl(0, "TabLine", { bg = "#21262b", fg = "#c0c0c0" })  -- Tab line
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#21262b" })  -- Tab line fill
    vim.api.nvim_set_hl(0, "TabLineSel", { bg = "#2c313c", fg = "#ffffff" })  -- Selected tab
    
    -- Search highlighting
    vim.api.nvim_set_hl(0, "Search", { bg = "#3e5f7e", fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "IncSearch", { bg = "#61afef", fg = "#282c34" })
    
    -- Diagnostic colors
    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#e06c75" })
    vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#e5c07b" })
    vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#61afef" })
    vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#98c379" })
    
    -- Additional treesitter highlights
    vim.api.nvim_set_hl(0, "@function.call", { fg = "#87ceeb" })
    vim.api.nvim_set_hl(0, "@method", { fg = "#87ceeb" })
    vim.api.nvim_set_hl(0, "@method.call", { fg = "#87ceeb" })
    vim.api.nvim_set_hl(0, "@namespace", { fg = "#56b6c2" })
    vim.api.nvim_set_hl(0, "@constructor", { fg = "#56b6c2" })
end

setup_additional_highlights()

-- The main ColorMyPencils function is in plugin/00-colors.lua and runs automatically

-- Command to easily switch themes
vim.api.nvim_create_user_command('Theme', function(opts)
    local theme = opts.args ~= '' and opts.args or 'everforest'
    ColorMyPencils(theme)
end, {
    nargs = '?',
    complete = function()
        return {
            'everforest', 'gruvbox', 'tokyonight-moon',
            'catppuccin-latte', 'catppuccin-mocha', 'catppuccin-frappe', 'catppuccin-macchiato',
            'nord'
        }
    end,
    desc = 'Switch theme with custom highlights'
})
