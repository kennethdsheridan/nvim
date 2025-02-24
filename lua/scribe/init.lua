-- ======================================================================
-- File: init.lua
-- ======================================================================

-------------------------------------------------------------------------------
-- SET MAPLEADER FIRST
-------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------------------------------------------------------------------------
-- LAZY.NVIM BOOTSTRAP
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
-- SET UP LAZY.NVIM WITH OUR PLUGIN SPECS
-------------------------------------------------------------------------------
require("lazy").setup("scribe.plugins")

-------------------------------------------------------------------------------
-- DEBUG/INFORMATION PRINT
-------------------------------------------------------------------------------
print("Hello, from Scribe, starting configuration and requirement imports")

-------------------------------------------------------------------------------
-- IMPORT REMAPS AND SETTINGS
-------------------------------------------------------------------------------
require("scribe.remap")
require("scribe.set")
require("scribe.rust")
require("scribe.markdown")
require("scribe.configs")

-------------------------------------------------------------------------------
-- OPTIONAL: AUTOCMD / COLOR SETUP
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
    command = "lua ColorMyPencils()",
})

-- Keybinding to dismiss all notifications
vim.keymap.set("n", "<leader>nd", function()
    require("notify").dismiss()
end, { desc = "Dismiss all notifications" })

-------------------------------------------------------------------------------
-- CLIPBOARD INTEGRATION
-------------------------------------------------------------------------------
vim.o.clipboard = "unnamedplus"

-------------------------------------------------------------------------------
-- MASON SETUP (FOR LSP + DAP INSTALLATION)
-------------------------------------------------------------------------------
-- Make sure 'mason' is set up *before* we configure 'mason-lspconfig'
require('mason').setup()

-- DAP tools (optional)
local mason_nvim_dap_ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
if mason_nvim_dap_ok then
    mason_nvim_dap.setup({
        ensure_installed = { "codelldb" }, -- for Rust debugging
        automatic_installation = true,
    })
end

-------------------------------------------------------------------------------
-- LSP-ZERO SETUP
-------------------------------------------------------------------------------
-- 1) Load lsp-zero with the "recommended" preset (which configures many defaults)
local lsp = require('lsp-zero').preset('recommended')

-- 2) Ensure certain servers are installed via mason-lspconfig
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

-- 3) Customize what happens when an LSP server attaches to a buffer
lsp.on_attach(function(client, bufnr)
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
end)

-- 4) Optional: Fine-tune specific servers
--    (For example, Rust Analyzer advanced config)
lsp.configure('rust_analyzer', {
    settings = {
        ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            procMacro = { enable = true },
            checkOnSave = { command = "clippy" },
        },
    },
})

-- 5) For Lua, you can add extra workspace settings, etc.
lsp.configure('lua_ls', {
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

-- 6) Finally, initialize lsp-zero, which will set up all servers
lsp.setup()

-------------------------------------------------------------------------------
-- TABNINE CONFIGURATION (IF USED)
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
-- FILETYPE OVERRIDES (HUJSON -> jsonc)
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "policy.hujson" },
    callback = function()
        vim.bo.filetype = "jsonc"
    end
})

-------------------------------------------------------------------------------
-- FINAL DEBUG PRINT
-------------------------------------------------------------------------------
print("Completed importing requirements for Scribe configuration")
print("LSP configuration completed successfully")

