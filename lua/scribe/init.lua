-- File: lua/scribe/init.lua



-------------------------------------------------------------------------------
-- 1. LAZY.NVIM BOOTSTRAP
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
-- 2. SET UP LAZY.NVIM WITH OUR PLUGIN SPECS
-------------------------------------------------------------------------------
-- (Assuming you created lua/scribe/plugins.lua with your plugin table)
require("lazy").setup("scribe.plugins")

-- require("after.plugin.treesitter")

-------------------------------------------------------------------------------
-- 3. BASIC DEBUG/INFORMATION PRINT
-------------------------------------------------------------------------------
print("Hello, from Scribe, starting configuration and requirement imports")

-------------------------------------------------------------------------------
-- 4. IMPORT YOUR REMAPS AND SETTINGS
-------------------------------------------------------------------------------
require("scribe.remap")    -- Import your keyremaps
require("scribe.set")      -- Import your editor settings
require("scribe.rust")     -- Import your rust settings
require("scribe.markdown") -- Import your rust settings
require("scribe.configs")  -- Import your rust settings

-------------------------------------------------------------------------------
-- 5. OPTIONAL: AUTOCMD / COLOR SETUP
-------------------------------------------------------------------------------
-- Automatically run ColorMyPencils() on VimEnter if you have that function defined
vim.api.nvim_create_autocmd("VimEnter", {
    command = "lua ColorMyPencils()",
})

-- Keybinding to dismiss all notifications
vim.keymap.set("n", "<leader>nd", function()
    require("notify").dismiss()
end, { desc = "Dismiss all notifications" })

-------------------------------------------------------------------------------
-- 6. CLIPBOARD INTEGRATION
-------------------------------------------------------------------------------
vim.o.clipboard = "unnamedplus"

-------------------------------------------------------------------------------
-- 7. MASON SETUP (FOR LSP INSTALLATION)
-------------------------------------------------------------------------------
require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        'bashls',        -- Bash
        'dockerls',      -- Docker
        'gopls',         -- Go
        'jsonls',        -- JSON
        'lua_ls',        -- Lua
        'marksman',      -- Markdown
        'pyright',       -- Python
        'rust_analyzer', -- Rust
        'sqlls',         -- SQL
        'taplo',         -- TOML
        'yamlls',        -- YAML
        -- Add any other servers you need
    },
    automatic_installation = false,
})

-------------------------------------------------------------------------------
-- 8. DEFINE A COMMON ON_ATTACH FOR LSP
-------------------------------------------------------------------------------
local on_attach = function(client, bufnr)
    -- Key mappings
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)          -- Go to definition
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                -- Hover doc
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)      -- Go to implementation
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)      -- Rename symbol
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)          -- References
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)        -- Prev diagnostic
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)        -- Next diagnostic
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Code action
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
    end, opts) -- Format code

    -- Format on save (if the server supports it)
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format { async = false }
            end,
        })
    end
end

-------------------------------------------------------------------------------
-- 9. SET UP LSPCONFIG SERVERS
-------------------------------------------------------------------------------
local lspconfig = require('lspconfig')

local servers = {
    'bashls',
    'dockerls',
    'gopls',
    'jsonls',
    'marksman',
    'pyright',
    'sqlls',
    'taplo',
    'yamlls',
}
for _, server in ipairs(servers) do
    lspconfig[server].setup({
        on_attach = on_attach,
    })
end

-- Special config for Lua
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }, -- Recognize the `vim` global
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

-- If you want to enable Rust manually (rather than via rust-tools):
-- lspconfig.rust_analyzer.setup({
--   on_attach = on_attach,
--   settings = {
--     ["rust-analyzer"] = {
--       cargo = {
--         allFeatures = true,
--       },
--       procMacro = {
--         enable = true,
--       },
--       checkOnSave = {
--         command = "clippy",
--       },
--     },
--   },
-- })

-------------------------------------------------------------------------------
-- 10. TABNINE CONFIGURATION
-------------------------------------------------------------------------------
require('tabnine').setup({
    disable_auto_comment = true,
    accept_keymap = "<Tab>",
    dismiss_keymap = "<C-]>",
    debounce_ms = 800,
    suggestion_color = { gui = "#808080", cterm = 244 },
    exclude_filetypes = { "TelescopePrompt", "NvimTree" },
    log_file_path = nil,
    ignore_certificate_errors = false,
})

-------------------------------------------------------------------------------
-- 11. FINAL DEBUG PRINT
-------------------------------------------------------------------------------
print("Completed importing requirements for Scribe configuration")
print("LSP configuration completed successfully")
