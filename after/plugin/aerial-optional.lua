-- Optional Aerial.nvim setup
-- Aerial is disabled by default to avoid keymap conflicts
-- Use these commands to enable it when needed

-- Command to enable Aerial for current session
vim.api.nvim_create_user_command('AerialEnable', function()
    -- Load Aerial plugin
    local ok, aerial = pcall(require, 'aerial')
    if not ok then
        vim.notify("❌ Aerial plugin not available. Enable it in plugins.lua first.", vim.log.levels.ERROR)
        return
    end
    
    -- Setup Aerial with safe keybindings
    aerial.setup({
        backends = { "lsp", "treesitter", "markdown" },
        show_guides = true,
        layout = {
            width = 30,
            placement = "edge",
        },
        on_attach = function(bufnr)
            -- Safe keybindings that don't conflict
            vim.keymap.set("n", "<leader>ao", "<cmd>AerialOpen<CR>", { buffer = bufnr, desc = "Aerial: Open outline" })
            vim.keymap.set("n", "<leader>ac", "<cmd>AerialClose<CR>", { buffer = bufnr, desc = "Aerial: Close outline" })
            vim.keymap.set("n", "<leader>at", "<cmd>AerialToggle<CR>", { buffer = bufnr, desc = "Aerial: Toggle outline" })
            vim.keymap.set("n", "<leader>an", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Aerial: Next symbol" })
            vim.keymap.set("n", "<leader>ap", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Aerial: Previous symbol" })
        end,
    })
    
    vim.notify("✅ Aerial enabled! Use <leader>at to toggle outline", vim.log.levels.INFO)
end, { desc = "Enable Aerial code outline plugin" })

-- Command to show Aerial keybindings
vim.api.nvim_create_user_command('AerialHelp', function()
    print("🗂️  Aerial Code Outline Commands:")
    print("  :AerialEnable    - Enable Aerial for this session")
    print("  <leader>ao       - Open outline")
    print("  <leader>ac       - Close outline") 
    print("  <leader>at       - Toggle outline")
    print("  <leader>an       - Next symbol")
    print("  <leader>ap       - Previous symbol")
    print("")
    print("💡 To enable permanently, set enabled = true in plugins.lua")
end, { desc = "Show Aerial help" })

-- Alternative outline using LSP symbols (always available)
vim.api.nvim_create_user_command('Outline', function()
    vim.cmd('Telescope lsp_document_symbols')
end, { desc = "Show document outline using Telescope" })

vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = "Show document outline" })