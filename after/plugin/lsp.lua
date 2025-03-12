-- Make sure this file is the single source of truth for language servers
-- (i.e., you do NOT call "require('lspconfig').rust_analyzer.setup({})"
-- or any other server setups anywhere else).

-- Load the lsp-zero library with the 'recommended' preset
local lsp = require('lsp-zero').preset('recommended')

-- Improve completion quality of life
-- (Set recommended completeopt for a better completion menu experience)
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- If you edit Neovim config in Lua, uncomment the next line for better Lua completions:
-- lsp.nvim_workspace()

-- Mason setup for installing and managing LSP servers
require('mason').setup()

-- Let mason-lspconfig ensure the following servers are installed
require('mason-lspconfig').setup({
    ensure_installed = {
        -- Web dev
        'tsserver',
        'eslint',
        'html',
        'cssls',
        'tailwindcss',

        -- Languages
        'lua_ls',    -- Lua
        'pyright',   -- Python
        'rust_analyzer', -- Rust
        'gopls',     -- Go
        'clangd',    -- C/C++
        'bashls',    -- Bash

        -- Config files
        'jsonls',
        'yamlls',

        -- Others
        'dockerls',
        'marksman', -- Markdown
    },
    -- `automatic_installation = true` will auto-install any server you configure in lsp-zero,
    -- which can be nice. Disable if you prefer full manual control.
    automatic_installation = false,
})

-- Set up nvim-cmp for autocompletion
local cmp = require('cmp')
local lspkind = require('lspkind')

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>']     = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>']     = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>']     = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>']     = cmp.mapping.confirm({ select = true }),
})

cmp.setup({
    mapping = cmp_mappings,
    sources = {
        { name = 'nvim_lsp', priority = 750 },
        { name = 'buffer',   priority = 500 },
        { name = 'path',     priority = 300 },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Use lspkind icons
            vim_item.kind = lspkind.presets.default[vim_item.kind] or ""

            -- Special rust icon for Rust modules
            if entry.source.name == 'nvim_lsp' and vim_item.kind == 'Module'
                and entry.completion_item.label:find("::") then
                vim_item.kind = '🦀'
            end

            vim_item.menu = ({
                buffer   = "[Buffer]",
                nvim_lsp = "[LSP]",
                path     = "[Path]",
                luasnip  = "[Snippet]",
            })[entry.source.name] or ""

            return vim_item
        end,
    },
})

-- Configure on_attach behavior: LSP keymaps, etc.
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

-- Additional config for Rust, e.g. enabling proc macros and all features
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

-- Finally set everything up
lsp.setup()

