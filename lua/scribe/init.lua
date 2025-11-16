-- ======================================================================
-- File: init.lua
-- ======================================================================

-------------------------------------------------------------------------------
-- SET MAPLEADER FIRST
-------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------------------------------------------------------------------------
-- ENABLE NETRW FOR DIRECTORY BROWSING
-------------------------------------------------------------------------------
-- vim.g.loaded_netrw = 1           -- Commented out to enable netrw
-- vim.g.loaded_netrwPlugin = 1     -- Commented out to enable netrw

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

-------------------------------------------------------------------------------
-- FORCE NETRW ON DIRECTORY OPEN
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    callback = function(data)
        -- Check if the buffer is a directory
        local directory = vim.fn.isdirectory(data.file) == 1
        
        if directory then
            -- Use vim.schedule to ensure this runs after other plugins load
            vim.schedule(function()
                -- Delete any other buffers that might have opened
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    local bufname = vim.api.nvim_buf_get_name(buf)
                    local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
                    -- Close scratch, alpha, nofile, or empty buffers
                    if bufname == "" or bufname:match("alpha") or bufname:match("[Ss]cratch") or buftype == "nofile" then
                        if buf ~= vim.api.nvim_get_current_buf() then
                            pcall(vim.api.nvim_buf_delete, buf, { force = true })
                        end
                    end
                end
                
                -- Open netrw explicitly
                vim.cmd("edit " .. vim.fn.fnameescape(data.file))
            end)
        end
    end,
})

-- Keybinding to dismiss all notifications
vim.keymap.set("n", "<leader>nd", function()
    require("notify").dismiss()
end, { desc = "Dismiss all notifications" })

-------------------------------------------------------------------------------
-- CLIPBOARD INTEGRATION
-------------------------------------------------------------------------------
if vim.fn.has('macunix') then
    vim.o.clipboard = 'unnamed'  -- macOS uses pbcopy/pbpaste
else
    vim.o.clipboard = 'unnamedplus'  -- Linux uses system clipboard
    -- Explicit clipboard provider for Linux
    vim.g.clipboard = {
        name = 'xclip-wl-clipboard',
        copy = {
            ['+'] = 'xclip -selection clipboard',
            ['*'] = 'xclip -selection primary',
        },
        paste = {
            ['+'] = 'xclip -selection clipboard -o',
            ['*'] = 'xclip -selection primary -o',
        },
        cache_enabled = 1,
    }
    -- Fallback to wl-clipboard if xclip fails
    if vim.fn.executable('wl-copy') == 1 then
        vim.g.clipboard = {
            name = 'wl-clipboard',
            copy = {
                ['+'] = 'wl-copy --type text/plain',
                ['*'] = 'wl-copy --type text/plain --primary',
            },
            paste = {
                ['+'] = 'wl-paste --type text/plain',
                ['*'] = 'wl-paste --type text/plain --primary',
            },
            cache_enabled = 1,
        }
    end
end

-------------------------------------------------------------------------------
-- MASON SETUP (SIMPLE APPROACH)
-------------------------------------------------------------------------------
-- First, set up mason
require('mason').setup()

-------------------------------------------------------------------------------
-- LSP configuration is now handled in after/plugin/lsp.lua
-- This avoids duplication and uses the modern vim.lsp.config API


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
-- RUST-SPECIFIC COMMANDS
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command('CargoTest', function()
    vim.cmd('!cargo test')
end, { desc = 'Run cargo test' })

vim.api.nvim_create_user_command('CargoRun', function()
    vim.cmd('!cargo run')
end, { desc = 'Run cargo run' })

vim.api.nvim_create_user_command('CargoCheck', function()
    vim.cmd('!cargo check')
end, { desc = 'Run cargo check' })

vim.api.nvim_create_user_command('CargoClippy', function()
    vim.cmd('!cargo clippy')
end, { desc = 'Run cargo clippy' })

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

-------------------------------------------------------------------------------
-- PARCHMENT COLORSCHEME FUNCTION
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- GRUVBOX COLORSCHEME FUNCTION
-------------------------------------------------------------------------------
function ColorMyPencils(color)
    color = color or "gruvbox"
    
    if color == "gruvbox" then
        -- Setup Gruvbox with configuration
        require("gruvbox").setup({
            contrast = "medium", -- or "soft" for softer contrast
            transparent_mode = false,
            palette_overrides = {},
            overrides = {},
        })
        vim.cmd.colorscheme("gruvbox")
        print("Applied Gruvbox colorscheme - warm and retro coding vibes")
    else
        vim.cmd.colorscheme(color)
    end
    
    -- Optional: Keep backgrounds opaque
    -- Remove these lines if you want transparency
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
