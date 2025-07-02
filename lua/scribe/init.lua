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
-- IMPORT REMAPS AND SETTINGS (but skip scribe.configs for now)
-------------------------------------------------------------------------------
require("scribe.remap")
require("scribe.set")
require("scribe.rust")
require("scribe.markdown")
-- Skip scribe.configs temporarily to isolate the LSP setup issue
-- require("scribe.configs")

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
-- MASON SETUP (SIMPLE APPROACH)
-------------------------------------------------------------------------------
-- First, set up mason
require('mason').setup()

-------------------------------------------------------------------------------
-- MANUAL LSP CONFIGURATION
-------------------------------------------------------------------------------
local lspconfig = require('lspconfig')

-- Default on_attach function
local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- LSP keybinds
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Format on save (only if supported)
    if client.supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", {}),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end

-- Basic servers
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

-- Set up basic servers
for _, server in ipairs(servers) do
    lspconfig[server].setup({
        on_attach = on_attach,
    })
end

-- Special config for lua_ls
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- Special config for rust_analyzer
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            procMacro = { enable = true },
            checkOnSave = { command = "clippy" },
            diagnostics = {
                disabled = { "unresolved-proc-macro", "macro-error" },
            },
        },
    },
})

-------------------------------------------------------------------------------
-- DAP SETUP (SIMPLIFIED)
-------------------------------------------------------------------------------
-- Only set up DAP if the plugin is properly loaded
local dap_ok, dap = pcall(require, 'dap')
if dap_ok then
    -- Basic DAP configuration for Rust
    dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode', -- Adjust path as needed
        name = 'lldb'
    }

    dap.configurations.rust = {
        {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
        },
    }
end

-- Mason-nvim-dap setup (optional)
local mason_nvim_dap_ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
if mason_nvim_dap_ok then
    mason_nvim_dap.setup({
        ensure_installed = { "codelldb" },
        automatic_installation = false,
    })
end

-------------------------------------------------------------------------------
-- TABNINE CONFIGURATION
-------------------------------------------------------------------------------
local tabnine_ok, tabnine = pcall(require, 'tabnine')
if tabnine_ok then
    tabnine.setup({
        disable_auto_comment = true,
        -- accept_keymap = "<Tab>",  -- DISABLED TAB ACCEPTANCE
        accept_keymap = nil,  -- Disable Tabnine completely
        dismiss_keymap = "<C-]>",
        debounce_ms = 800,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt", "NvimTree" },
        log_file_path = nil,
        ignore_certificate_errors = false,
    })
end

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

-------------------------------------------------------------------------------
-- DISABLE TAB COMPLETION AFTER EVERYTHING LOADS
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.schedule(function()
            -- Force disable Tab completion
            vim.keymap.set('i', '<Tab>', '\t', { noremap = true, silent = true })
            print("Tab completion forcefully disabled")
        end)
    end,
})
