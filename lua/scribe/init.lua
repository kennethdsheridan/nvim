-- ======================================================================
-- File: init.lua
-- ======================================================================

-------------------------------------------------------------------------------
-- 0. SET MAPLEADER FIRST
-------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
-- (Assuming you created lua/scribe/plugins.lua with your plugin specs)
require("lazy").setup("scribe.plugins")

-------------------------------------------------------------------------------
-- 3. DEBUG/INFORMATION PRINT
-------------------------------------------------------------------------------
print("Hello, from Scribe, starting configuration and requirement imports")

-------------------------------------------------------------------------------
-- 4. IMPORT REMAPS AND SETTINGS
-------------------------------------------------------------------------------
require("scribe.remap")
require("scribe.set")
require("scribe.rust")
require("scribe.markdown")
require("scribe.configs")

-------------------------------------------------------------------------------
-- 5. OPTIONAL: AUTOCMD / COLOR SETUP
-------------------------------------------------------------------------------
-- Automatically run ColorMyPencils() on VimEnter if you have that function
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
-- 7. MASON SETUP (FOR LSP + DAP INSTALLATION)
-------------------------------------------------------------------------------
require('mason').setup()

-- LSP servers
require('mason-lspconfig').setup({
    ensure_installed = {
        'bashls',
        'dockerls',
        'gopls',
        'jsonls',
        'lua_ls',
        'marksman',
        'pyright',
        'rust_analyzer',
        'sqlls',
        'taplo',
        'yamlls',
    },
    automatic_installation = false,
})

-- DAP tools
-- Make sure you have mason-nvim-dap in your plugin list if you want this:
local mason_nvim_dap_ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
if mason_nvim_dap_ok then
    mason_nvim_dap.setup({
        ensure_installed = { "codelldb" }, -- crucial for Rust debugging
        automatic_installation = true,
    })
end

-------------------------------------------------------------------------------
-- 8. DEFINE A COMMON ON_ATTACH FOR LSP
-------------------------------------------------------------------------------
local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Some typical LSP keybinds
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Format on save
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end
end

-------------------------------------------------------------------------------
-- 9. SET UP LSPCONFIG SERVERS MANUALLY
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
            telemetry = { enable = false },
        },
    },
})

-- (Optional) Rust Analyzer manual config
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            procMacro = { enable = true },
            checkOnSave = { command = "clippy" },
        },
    },
})

-------------------------------------------------------------------------------
-- 10. TABNINE CONFIGURATION (if used)
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
-- 11. FILETYPE OVERRIDES (HUJSON -> jsonc)
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "policy.hujson" },
    callback = function()
        vim.bo.filetype = "jsonc"
    end
})

-------------------------------------------------------------------------------
-- 12. FINAL DEBUG PRINT
-------------------------------------------------------------------------------
print("Completed importing requirements for Scribe configuration")
print("LSP configuration completed successfully")

