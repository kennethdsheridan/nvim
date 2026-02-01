-- Folding configuration for markdown and other files
print("Loading folding configuration...")

-- First ensure treesitter is available
local has_treesitter = pcall(require, 'nvim-treesitter')

if has_treesitter then
    -- Enable folding using Treesitter expression
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
else
    -- Fallback to indent-based folding
    vim.opt.foldmethod = 'indent'
    print("Treesitter not available, using indent-based folding")
end

-- Don't fold by default when opening files
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Set the fold column width (shows fold indicators in the gutter)
vim.opt.foldcolumn = '1'

-- Better fold text
vim.opt.fillchars = { fold = ' ' }
vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]

-- Markdown-specific folding settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "md" },
    callback = function()
        print("Setting up markdown folding...")
        
        -- Try treesitter first
        if has_treesitter then
            vim.opt_local.foldmethod = 'expr'
            vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
        else
            -- Fallback to markdown-specific expression
            vim.opt_local.foldmethod = 'expr'
            vim.opt_local.foldexpr = 'MarkdownFold()'
        end
        
        vim.opt_local.foldenable = true
        vim.opt_local.foldlevel = 99
        
        -- Define custom markdown folding function
        vim.cmd([[
            function! MarkdownFold()
                let line = getline(v:lnum)
                
                " Headers
                if line =~# '^#\+ '
                    return '>' . (matchend(line, '^#\+ ') - 1)
                endif
                
                " Code blocks
                if line =~# '^```'
                    if getline(v:lnum - 1) !~# '^```'
                        return 'a1'
                    else
                        return 's1'
                    endif
                endif
                
                return '='
            endfunction
        ]])
        
        print("Markdown folding enabled - use zR to unfold all, zM to fold all")
    end,
})

-- Define the fold commands explicitly
vim.cmd([[
    " Basic fold commands
    command! FoldAll normal! zM
    command! UnfoldAll normal! zR
    command! FoldToggle normal! za
]])

-- Keymaps for folding
local opts = { noremap = true, silent = true }

-- Use lowercase commands (these are the standard vim fold commands)
vim.keymap.set("n", "zr", "zr", opts) -- reduce folding (open one level)
vim.keymap.set("n", "zm", "zm", opts) -- more folding (close one level)
vim.keymap.set("n", "za", "za", opts) -- toggle fold
vim.keymap.set("n", "zo", "zo", opts) -- open fold
vim.keymap.set("n", "zc", "zc", opts) -- close fold
vim.keymap.set("n", "zR", "zR", opts) -- open all folds
vim.keymap.set("n", "zM", "zM", opts) -- close all folds

-- Alternative keymaps with leader
vim.keymap.set("n", "<leader>zr", ":UnfoldAll<CR>", { desc = "Unfold all" })
vim.keymap.set("n", "<leader>zm", ":FoldAll<CR>", { desc = "Fold all" })
vim.keymap.set("n", "<leader>za", ":FoldToggle<CR>", { desc = "Toggle fold" })

print("Folding configuration loaded successfully")
print("Commands available: :FoldAll, :UnfoldAll, :FoldToggle")
print("Keys: zR (unfold all), zM (fold all), za (toggle), zo (open), zc (close)")
