-- Debug what's causing the completion popup
vim.api.nvim_create_user_command('DebugCompletion', function()
    print("=== Completion Debug Info ===")
    
    -- Check nvim-cmp status
    local ok, cmp = pcall(require, 'cmp')
    if ok then
        local config = cmp.get_config()
        print("nvim-cmp enabled: " .. tostring(config.enabled))
        print("nvim-cmp autocomplete: " .. tostring(config.completion and config.completion.autocomplete))
    end
    
    -- Check Augment variables
    print("\n=== Augment Settings ===")
    print("augment_autocomplete_enabled: " .. tostring(vim.g.augment_autocomplete_enabled))
    print("augment_enable_inline_completion: " .. tostring(vim.g.augment_enable_inline_completion))
    print("augment_disable_keymaps: " .. tostring(vim.g.augment_disable_keymaps))
    
    -- Check active autocommands
    print("\n=== Active Autocommands ===")
    print("CursorHoldI:")
    vim.cmd('verbose autocmd CursorHoldI')
    print("\nTextChangedI:")
    vim.cmd('verbose autocmd TextChangedI')
    
    -- Check completeopt setting
    print("\n=== Vim Settings ===")
    print("completeopt: " .. vim.o.completeopt)
    print("pumvisible: " .. vim.fn.pumvisible())
end, {})