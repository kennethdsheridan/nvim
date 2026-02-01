-- Toggle between Tab completion modes
-- Use :TabCompleteOn to enable Tab for completions
-- Use :TabCompleteOff to use Tab for literal tabs

local tab_complete_enabled = true

local function enable_tab_completion()
    local cmp_ok, cmp = pcall(require, 'cmp')
    if not cmp_ok then
        vim.notify("nvim-cmp not available", vim.log.levels.WARN)
        return
    end
    
    -- Enable Tab for completion
    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
        })
    })
    
    tab_complete_enabled = true
    vim.notify("Tab completion enabled", vim.log.levels.INFO)
end

local function disable_tab_completion()
    -- Map Tab to literal tab
    vim.cmd('silent! iunmap <Tab>')
    vim.cmd('silent! iunmap <S-Tab>')
    vim.cmd('inoremap <Tab> <Tab>')
    vim.cmd('inoremap <S-Tab> <C-d>')  -- Shift-Tab for unindent
    
    tab_complete_enabled = false
    vim.notify("Tab completion disabled (literal tabs)", vim.log.levels.INFO)
end

-- Create user commands
vim.api.nvim_create_user_command('TabCompleteOn', enable_tab_completion, { desc = "Enable Tab for completion" })
vim.api.nvim_create_user_command('TabCompleteOff', disable_tab_completion, { desc = "Use Tab for literal tabs" })
vim.api.nvim_create_user_command('TabCompleteToggle', function()
    if tab_complete_enabled then
        disable_tab_completion()
    else
        enable_tab_completion()
    end
end, { desc = "Toggle Tab completion mode" })

-- Add keybinding for quick toggle
vim.keymap.set('n', '<leader>tc', ':TabCompleteToggle<CR>', { desc = "Toggle Tab completion" })