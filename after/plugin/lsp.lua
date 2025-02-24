-- Load the lsp-zero library with the 'recommended' preset
local lsp = require('lsp-zero').preset('recommended')

-- Mason setup for installing and managing LSP servers
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'eslint',
        'lua_ls',
        'rust_analyzer',
    },
    automatic_installation = true, -- Optional, automatically install LSP servers
})

-- Require necessary modules
local cmp = require('cmp')         -- Completion engine
local lspkind = require('lspkind') -- Adds icons to completion items

-- Configure completion behavior and mappings
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>']     = cmp.mapping.select_prev_item(cmp_select), -- Select previous item
    ['<C-n>']     = cmp.mapping.select_next_item(cmp_select), -- Select next item
    ['<C-y>']     = cmp.mapping.confirm({ select = true }),   -- Confirm selection
    ['<C-Space>'] = cmp.mapping.complete(),                   -- Trigger completion
    ['<Tab>']     = cmp.mapping.confirm({ select = true }),   -- Confirm selection with Tab
})

-- Adjust the completion sources and their priorities
cmp.setup({
    mapping = cmp_mappings,
    sources = {
        { name = 'nvim_lsp', priority = 750 },
        { name = 'buffer',   priority = 500 },
        { name = 'path',     priority = 300 },
    },

    -- Formatting block for custom icons and source display
    formatting = {
        format = function(entry, vim_item)
            -- Use default lspkind icons, with a fallback to empty if none exists
            vim_item.kind = lspkind.presets.default[vim_item.kind] or ""

            -- Add Rust-specific icon 🦀 for rust_analyzer LSP items (e.g., Rust modules)
            if entry.source.name == 'nvim_lsp' and vim_item.kind == 'Module' and entry.completion_item.label:find("::") then
                vim_item.kind = '🦀' -- Rust crab emoji for Rust modules
            end

            -- For other sources, keep menu display simple and clean
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                path = "[Path]",
                luasnip = "[Snippet]",
            })[entry.source.name] or ""

            return vim_item
        end,
    },
}) -- This was missing its closing parenthesis

-- Configure LSP client on attachment to buffer
lsp.on_attach(function(client, bufnr)
    -- Set up key mappings for LSP functions
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)                -- Go to definition
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                      -- Hover for info
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts) -- Workspace symbols
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)     -- Open diagnostics
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)              -- Next diagnostic
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)              -- Previous diagnostic
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)      -- Code action
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)       -- References
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)           -- Rename symbol
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)         -- Signature help
end)


-- Tell rust-analyzer to enable proc macros and build all features
lsp.configure('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true
            },
        }
    }
})

-- Initialize the lsp setup
lsp.setup()
