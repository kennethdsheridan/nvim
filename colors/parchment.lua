-- Parchment - An extremely parchment-like colorscheme for Neovim
-- Colors inspired by aged manuscript paper and medieval ink
-- Optimized for high contrast and readability

local M = {}

-- Enhanced Parchment color palette with better contrast
local colors = {
    -- Background colors (aged parchment)
    bg0 = '#F4F1E8',        -- Main background - cream parchment
    bg1 = '#F0EBD8',        -- Slightly darker parchment
    bg2 = '#EBE4D1',        -- Even darker for contrast
    bg3 = '#E6DDCA',        -- Darkest background tone
    
    -- Foreground colors (dark ink on parchment) - ENHANCED CONTRAST
    fg0 = '#1A0E08',        -- Main text - very dark sepia (much darker)
    fg1 = '#2D1810',        -- Slightly lighter text
    fg2 = '#3C2415',        -- Even lighter
    fg3 = '#4A2E1A',        -- Lightest readable text
    
    -- Comment colors (faded but readable ink)
    comment = '#6B5339',    -- Darker aged brown comment (increased contrast)
    comment_light = '#8B7355', -- Lighter comment
    
    -- Syntax colors (dark medieval inks) - ALL DARKENED
    keyword = '#6B2C0A',    -- Much darker saddle brown - keywords
    string = '#A0522D',     -- Darker sienna - strings  
    number = '#8B1A1A',     -- Dark red - numbers
    func = '#4A2C14',       -- Very dark coffee - functions
    type = '#8B2500',       -- Dark rust - types
    constant = '#7A3F1D',   -- Dark sienna - constants
    variable = '#1A0E08',   -- Very dark sepia - variables
    
    -- Special colors
    error = '#660000',      -- Very dark red for errors
    warning = '#CC6600',    -- Dark orange for warnings
    info = '#6B2C0A',       -- Dark brown for info
    hint = '#6B5339',       -- Dark brown for hints
    
    -- UI colors
    selection = '#E6DDCA',  -- Selection background
    search = '#D4AF7A',     -- Search highlight (darker)
    cursor = '#1A0E08',     -- Cursor color
    line_nr = '#8B7355',    -- Line numbers
    
    -- Git colors (using darker parchment-appropriate tones)
    git_add = '#5D4A0F',    -- Dark gold
    git_change = '#A0522D', -- Dark peru
    git_delete = '#8B1A1A', -- Dark red
}

-- Helper function to set highlight groups
local function hi(group, opts)
    opts = opts or {}
    local cmd = 'highlight ' .. group
    if opts.fg then cmd = cmd .. ' guifg=' .. opts.fg end
    if opts.bg then cmd = cmd .. ' guibg=' .. opts.bg end
    if opts.style then cmd = cmd .. ' gui=' .. opts.style end
    if opts.sp then cmd = cmd .. ' guisp=' .. opts.sp end
    vim.cmd(cmd)
end

-- Apply the colorscheme
function M.setup()
    -- Reset colors
    vim.cmd('highlight clear')
    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end
    
    vim.g.colors_name = 'parchment'
    vim.o.background = 'light'
    
    -- Editor highlights
    hi('Normal', { fg = colors.fg0, bg = colors.bg0 })
    hi('NormalFloat', { fg = colors.fg0, bg = colors.bg1 })
    hi('NormalNC', { fg = colors.fg1, bg = colors.bg0 })
    
    hi('Cursor', { fg = colors.bg0, bg = colors.cursor })
    hi('CursorLine', { bg = colors.bg1 })
    hi('CursorColumn', { bg = colors.bg1 })
    hi('CursorLineNr', { fg = colors.fg0, bg = colors.bg1, style = 'bold' })
    
    hi('LineNr', { fg = colors.line_nr, bg = colors.bg0 })
    hi('SignColumn', { fg = colors.line_nr, bg = colors.bg0 })
    hi('FoldColumn', { fg = colors.line_nr, bg = colors.bg0 })
    
    hi('Visual', { bg = colors.selection })
    hi('VisualNOS', { bg = colors.selection })
    hi('Search', { bg = colors.search, style = 'bold' })
    hi('IncSearch', { fg = colors.bg0, bg = colors.keyword, style = 'bold' })
    
    hi('StatusLine', { fg = colors.fg0, bg = colors.bg2 })
    hi('StatusLineNC', { fg = colors.fg2, bg = colors.bg1 })
    hi('WildMenu', { fg = colors.bg0, bg = colors.keyword })
    
    hi('TabLine', { fg = colors.fg2, bg = colors.bg1 })
    hi('TabLineFill', { fg = colors.fg2, bg = colors.bg1 })
    hi('TabLineSel', { fg = colors.fg0, bg = colors.bg0, style = 'bold' })
    
    hi('VertSplit', { fg = colors.bg2, bg = colors.bg0 })
    hi('Folded', { fg = colors.comment, bg = colors.bg1 })
    hi('FoldedText', { fg = colors.comment, bg = colors.bg1 })
    
    -- Syntax highlighting
    hi('Comment', { fg = colors.comment, style = 'italic' })
    hi('CommentBold', { fg = colors.comment, style = 'bold' })
    
    hi('Constant', { fg = colors.constant })
    hi('String', { fg = colors.string })
    hi('Character', { fg = colors.string })
    hi('Number', { fg = colors.number })
    hi('Boolean', { fg = colors.number })
    hi('Float', { fg = colors.number })
    
    hi('Identifier', { fg = colors.variable })
    hi('Function', { fg = colors.func, style = 'bold' })
    
    hi('Statement', { fg = colors.keyword, style = 'bold' })
    hi('Conditional', { fg = colors.keyword, style = 'bold' })
    hi('Repeat', { fg = colors.keyword, style = 'bold' })
    hi('Label', { fg = colors.keyword, style = 'bold' })
    hi('Operator', { fg = colors.fg0 })
    hi('Keyword', { fg = colors.keyword, style = 'bold' })
    hi('Exception', { fg = colors.keyword, style = 'bold' })
    
    hi('PreProc', { fg = colors.type, style = 'bold' })
    hi('Include', { fg = colors.type, style = 'bold' })
    hi('Define', { fg = colors.type, style = 'bold' })
    hi('Macro', { fg = colors.type, style = 'bold' })
    hi('PreCondit', { fg = colors.type, style = 'bold' })
    
    hi('Type', { fg = colors.type, style = 'bold' })
    hi('StorageClass', { fg = colors.type, style = 'bold' })
    hi('Structure', { fg = colors.type, style = 'bold' })
    hi('Typedef', { fg = colors.type, style = 'bold' })
    
    hi('Special', { fg = colors.constant })
    hi('SpecialChar', { fg = colors.constant })
    hi('Tag', { fg = colors.constant })
    hi('Delimiter', { fg = colors.fg1 })
    hi('SpecialComment', { fg = colors.comment, style = 'bold' })
    hi('Debug', { fg = colors.constant })
    
    hi('Underlined', { style = 'underline' })
    hi('Ignore', { fg = colors.comment })
    hi('Error', { fg = colors.error, style = 'bold' })
    hi('Todo', { fg = colors.warning, bg = colors.bg1, style = 'bold' })
    
    -- Diagnostics
    hi('DiagnosticError', { fg = colors.error })
    hi('DiagnosticWarn', { fg = colors.warning })
    hi('DiagnosticInfo', { fg = colors.info })
    hi('DiagnosticHint', { fg = colors.hint })
    
    hi('DiagnosticSignError', { fg = colors.error, bg = colors.bg0 })
    hi('DiagnosticSignWarn', { fg = colors.warning, bg = colors.bg0 })
    hi('DiagnosticSignInfo', { fg = colors.info, bg = colors.bg0 })
    hi('DiagnosticSignHint', { fg = colors.hint, bg = colors.bg0 })
    
    hi('DiagnosticUnderlineError', { sp = colors.error, style = 'underline' })
    hi('DiagnosticUnderlineWarn', { sp = colors.warning, style = 'underline' })
    hi('DiagnosticUnderlineInfo', { sp = colors.info, style = 'underline' })
    hi('DiagnosticUnderlineHint', { sp = colors.hint, style = 'underline' })
    
    -- LSP
    hi('LspReferenceText', { bg = colors.bg2 })
    hi('LspReferenceRead', { bg = colors.bg2 })
    hi('LspReferenceWrite', { bg = colors.bg2 })
    
    -- Git
    hi('GitSignsAdd', { fg = colors.git_add, bg = colors.bg0 })
    hi('GitSignsChange', { fg = colors.git_change, bg = colors.bg0 })
    hi('GitSignsDelete', { fg = colors.git_delete, bg = colors.bg0 })
    
    hi('DiffAdd', { bg = colors.bg1, fg = colors.git_add })
    hi('DiffChange', { bg = colors.bg1, fg = colors.git_change })
    hi('DiffDelete', { bg = colors.bg1, fg = colors.git_delete })
    hi('DiffText', { bg = colors.bg2, fg = colors.git_change, style = 'bold' })
    
    -- Telescope
    hi('TelescopeNormal', { fg = colors.fg0, bg = colors.bg0 })
    hi('TelescopeBorder', { fg = colors.bg2, bg = colors.bg0 })
    hi('TelescopePromptBorder', { fg = colors.bg2, bg = colors.bg0 })
    hi('TelescopeResultsBorder', { fg = colors.bg2, bg = colors.bg0 })
    hi('TelescopePreviewBorder', { fg = colors.bg2, bg = colors.bg0 })
    hi('TelescopeSelection', { bg = colors.bg1 })
    hi('TelescopeSelectionCaret', { fg = colors.keyword, bg = colors.bg1 })
    hi('TelescopeMatching', { fg = colors.keyword, style = 'bold' })
    
    -- Tree-sitter
    hi('@comment', { fg = colors.comment, style = 'italic' })
    hi('@keyword', { fg = colors.keyword, style = 'bold' })
    hi('@string', { fg = colors.string })
    hi('@number', { fg = colors.number })
    hi('@boolean', { fg = colors.number })
    hi('@function', { fg = colors.func, style = 'bold' })
    hi('@type', { fg = colors.type, style = 'bold' })
    hi('@constant', { fg = colors.constant })
    hi('@variable', { fg = colors.variable })
    hi('@operator', { fg = colors.fg0 })
    hi('@punctuation', { fg = colors.fg1 })
    
    -- Pmenu (completion menu)
    hi('Pmenu', { fg = colors.fg0, bg = colors.bg1 })
    hi('PmenuSel', { fg = colors.bg0, bg = colors.keyword })
    hi('PmenuSbar', { bg = colors.bg2 })
    hi('PmenuThumb', { bg = colors.fg2 })
    
    -- Messages
    hi('ErrorMsg', { fg = colors.error, style = 'bold' })
    hi('WarningMsg', { fg = colors.warning, style = 'bold' })
    hi('MoreMsg', { fg = colors.info, style = 'bold' })
    hi('ModeMsg', { fg = colors.fg0, style = 'bold' })
    
    -- Spelling
    hi('SpellBad', { sp = colors.error, style = 'underline' })
    hi('SpellCap', { sp = colors.warning, style = 'underline' })
    hi('SpellLocal', { sp = colors.info, style = 'underline' })
    hi('SpellRare', { sp = colors.hint, style = 'underline' })
end

-- Function to get colors (for other plugins)
function M.colors()
    return colors
end

return M
