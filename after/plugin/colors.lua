function ColorMyPencils(color)
    color = color or "everforest"

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
    
    -- Custom highlight groups for a relaxed dark theme
    -- Dark background with light text
    vim.api.nvim_set_hl(0, "Normal", { bg = "#323338", fg = "#d4d4d4" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#323232", fg = "#d4d4d4" })
    
    -- Light syntax highlighting for dark background
    vim.api.nvim_set_hl(0, "Statement", { fg = "#87ceeb", bold = true })  -- Keywords in light blue
    vim.api.nvim_set_hl(0, "Function", { fg = "#87ceeb" })               -- Functions in light blue
    vim.api.nvim_set_hl(0, "Keyword", { fg = "#87ceeb", bold = true })   -- Keywords in light blue
    
    -- Light gray for variables and identifiers
    vim.api.nvim_set_hl(0, "Identifier", { fg = "#b8b8b8" })             -- Variables in light gray
    vim.api.nvim_set_hl(0, "@variable", { fg = "#b8b8b8" })              -- TreeSitter variables
    vim.api.nvim_set_hl(0, "@parameter", { fg = "#b8b8b8" })             -- Function parameters
    vim.api.nvim_set_hl(0, "@field", { fg = "#b8b8b8" })                 -- Object fields
    vim.api.nvim_set_hl(0, "@property", { fg = "#b8b8b8" })              -- Properties
    
    -- Strings and literals in soft green
    vim.api.nvim_set_hl(0, "String", { fg = "#98c379" })
    vim.api.nvim_set_hl(0, "@string", { fg = "#98c379" })
    
    -- Comments in medium gray
    vim.api.nvim_set_hl(0, "Comment", { fg = "#7f7f7f", italic = true })
    vim.api.nvim_set_hl(0, "@comment", { fg = "#7f7f7f", italic = true })
    
    -- Numbers and constants in soft purple
    vim.api.nvim_set_hl(0, "Number", { fg = "#c678dd" })
    vim.api.nvim_set_hl(0, "Constant", { fg = "#c678dd" })
    vim.api.nvim_set_hl(0, "@constant", { fg = "#c678dd" })
    vim.api.nvim_set_hl(0, "Boolean", { fg = "#c678dd" })
    
    -- Types in soft cyan
    vim.api.nvim_set_hl(0, "Type", { fg = "#56b6c2" })
    vim.api.nvim_set_hl(0, "@type", { fg = "#56b6c2" })
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = "#56b6c2" })
    
    -- Operators and delimiters
    vim.api.nvim_set_hl(0, "Operator", { fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "Delimiter", { fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "@operator", { fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "@punctuation", { fg = "#abb2bf" })
    
    -- Line numbers and UI elements
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370", bg = "#323338" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#363636" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#abb2bf", bg = "#363636", bold = true })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "#323338" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#3e4452", bg = "#323338" })
    
    -- Status line
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#3e4452", fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#353b45", fg = "#5c6370" })
    
    -- Visual selection
    vim.api.nvim_set_hl(0, "Visual", { bg = "#3e4452" })
    
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
