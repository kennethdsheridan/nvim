-- Initial print statements for debugging
print("Hello, from Scribe, starting configuration and requirement imports")

-- Import key remaps, packer config, and editor settings
require("scribe.remap")  -- import keyremaps
require("scribe.packer") -- import packer config
require("scribe.set")    -- import editor settings

print("Completed importing requirements for Scribe configuration")

-- Enable clipboard integration with NeoVim and the system clipboard
vim.o.clipboard = "unnamedplus"

-- Automatically run ColorMyPencils() on VimEnter
vim.api.nvim_create_autocmd('VimEnter', {
    command = 'lua ColorMyPencils()',
})

-- Keybinding to dismiss all notifications (assuming you use the 'notify' plugin)
vim.keymap.set("n", "<leader>nd", function()
    require('notify').dismiss()
end, { desc = "Dismiss all notifications" })

-- **Mason LSP management**
require('mason').setup()

-- Ensure the desired LSP servers are installed
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

-- **Common `on_attach` function**
local on_attach = function(client, bufnr)
    -- Key mappings
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)          -- Go to definition
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                -- Hover documentation
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)      -- Go to implementation
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)      -- Rename symbol
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)          -- Find references
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)        -- Previous diagnostic
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)        -- Next diagnostic
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Code actions
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
    end, opts) -- Format code

    -- Format on save if the server supports it
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

-- **Set up LSP servers with `lspconfig`**
local lspconfig = require('lspconfig')

-- Configure servers with default settings
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
    -- Add any other servers you need
}

for _, server in ipairs(servers) do
    lspconfig[server].setup({
        on_attach = on_attach,
    })
end

-- **Lua Language Server (special configuration)**
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }, -- Recognize the `vim` global
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

-- **Rust Analyzer (specific settings)**
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true,
            },
            checkOnSave = {
                command = "clippy",
            },
        },
    },
})

-- **Tabnine Configuration**
require('tabnine').setup({
    disable_auto_comment = true,
    accept_keymap = "<Tab>",
    dismiss_keymap = "<C-]>",
    debounce_ms = 800,
    suggestion_color = { gui = "#808080", cterm = 244 },
    exclude_filetypes = { "TelescopePrompt", "NvimTree" },
    log_file_path = nil, -- Absolute path to Tabnine log file
    ignore_certificate_errors = false,
})

-- **Optional: lsp-zero setup**
-- If you're using lsp-zero and want to keep it, configure it as needed
-- require('lsp-zero').setup({
--     -- Add specific configurations or tweaks for lsp-zero here
-- })

-- **Final print statement for debugging**
print("LSP configuration completed successfully")
