-- Aerial.nvim setup for structure outline
-- Provides a sidebar showing functions, structs, classes, etc.

-- Since Aerial is now enabled in plugins.lua, we can use it directly
local aerial_ok, aerial = pcall(require, 'aerial')
if aerial_ok then
    -- The main configuration is in plugins.lua
    -- Here we just add the notification
    vim.notify("Aerial structure outline available: Press <leader>str to toggle", vim.log.levels.INFO)
end

-- Command to show structure outline keybindings
vim.api.nvim_create_user_command('StructureHelp', function()
    print("🗂️  Structure Outline Commands:")
    print("  <leader>str      - Toggle structure sidebar (functions, structs, classes)")
    print("  [a               - Jump to previous symbol")
    print("  ]a               - Jump to next symbol")
    print("")
    print("  Alternative commands:")
    print("  <leader>fs       - Find symbols with fuzzy search (Telescope)")
    print("  <leader>fu       - Find functions only (Telescope)")
    print("  <leader>o        - Show outline in Telescope")
end, { desc = "Show structure outline help" })

-- Alternative outline using LSP symbols (always available)
vim.api.nvim_create_user_command('Outline', function()
    vim.cmd('Telescope lsp_document_symbols')
end, { desc = "Show document outline using Telescope" })

vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = "Show document outline" })