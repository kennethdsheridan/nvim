-- Load the lsp-zero library which provides easier configuration for Neovim LSP
local lsp = require('lsp-zero')

-- Preset configuration recommended by lsp-zero, optimizing default settings
lsp.preset("recommended")

-- Ensure the specified language servers are installed
lsp.ensure_installed({
    'tsserver',    -- TypeScript server
    'eslint',      -- ESLint for JavaScript
    'sumneko_lua', -- Lua language server
    'rust_analyzer'-- Rust language server
})

-- Load the cmp (completion) module for auto-completion features
local cmp = require('cmp')

-- set cmp.sources
cmp.setup {
    sources = {
        { name = "buffer "},
        { name = "nvim_lsp"},
        { name = "cmp_tabnine"},
    }
}

-- Configure cmp behavior for navigation through autocomplete suggestions
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select), -- Select previous item in completion menu
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select), -- Select next item in completion menu
    ['<C-y>'] = cmp.mapping.confirm({select = true}),     -- Confirm selection and replace text
    ['<C-Space>'] = cmp.mapping.complete()                -- Trigger completion manually
})

-- Configure LSP client on attach for each buffer
lsp.on_attach(function(client, bufnr)
    -- See :help lsp-zero-keybindings to learn about default keybindings provided
    local opts = {buffer = bufnr, remap = false}

    -- Define keymaps for LSP functions
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)               -- Go to definition
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                     -- Hover documentation
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)-- Workspace symbol search
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)    -- Open floating diagnostic
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)             -- Go to next diagnostic
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)             -- Go to previous diagnostic
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)     -- Trigger code action
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)      -- Find references
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)          -- Rename symbol
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)        -- Signature help
end)

-- Initialize the lsp setup
lsp.setup()

