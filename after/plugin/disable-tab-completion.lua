-- Disable all Tab completions after all plugins have loaded
-- This needs to run AFTER Augment sets up its mappings

-- Run immediately
local function disable_tab()
    -- Force unmap Tab
    vim.cmd('silent! iunmap <Tab>')
    
    -- Map Tab to insert a literal tab character
    vim.cmd('inoremap <Tab> <Tab>')
end

-- Run on startup
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.defer_fn(disable_tab, 100)  -- Wait 100ms for plugins to load
    end
})

-- Also run when entering insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = disable_tab
})

-- Disable immediately for current session
disable_tab()