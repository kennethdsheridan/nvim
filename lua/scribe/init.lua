print("Hello, from Scribe, starting configuration and requirement imports")
require("scribe.remap") -- import keyremaps
require("scribe.packer") -- import packer config
require("scribe.set") -- import editor settings
print("Completed importing requirements for Scribe configuration")
-- require the scribe/test plugin file
--
vim.o.clipboard = "unnamedplus" -- enables clipboard integration with NeoVim with the system ciipboard

-- Use the nvim_create_autocmd function to create an autocommand that runs on VimEnter
vim.api.nvim_create_autocmd('VimEnter', {
  -- The command to run when the event is triggered
  command = 'lua ColorMyPencils()',
})



-- Mason LSP managament 
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'rust_analyzer', -- Rust
    'markdown_oxide',
    'pylsp',
    'pyright',
    'sqlls',
    'solidity_ls',
    'taplo',
    'yamlls',
    'zls',
    'lemminx',
    'dockerls',
    'lua_ls',

  },
  automatic_installation = true,
})

-- Configure lsp-zero
require('lsp-zero').setup({
    -- You can add specific configurations or tweaks for lsp-zero here
    -- Ensure that this is called after mason and mason-lspconfig are set up
})


-- Rust Specific Settings 
require('lspconfig')['rust_analyzer'].setup {
  -- Enable all Rust Analyzer features
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

-- Automatically organize imports on file save
  on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', '<leader>o', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
      vim.api.nvim_command [[augroup END]]
    end
  end,
}


  -- Format on save and keybindings
  on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
      vim.api.nvim_command [[augroup END]]
    end
  end,


  -- Assuming you are within a Lua file or block configuring Neovim
vim.keymap.set("n", "<leader>nd", function()
    require('notify').dismiss()
end, { desc = "Dismiss all notifications" })

-- remap.lua
-- This script configures key mappings for cycling through and accepting completion options in NeoVim

local function setup()
    local has_cmp, cmp = pcall(require, 'cmp')
    if not has_cmp then
        return
    end

    local function check_backspace()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
    end

    -- Use Tab and Shift-Tab to navigate through the completion menu
    vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', {expr = true, noremap = true})
    vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', {expr = true, noremap = true})

    -- Additional settings for better completion experience
    cmp.setup({
        mapping = {
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    if cmp.get_selected_entry() then
                        cmp.confirm({ select = true })
                    else
                        cmp.select_next_item()
                    end
                elseif check_backspace() then
                    fallback()
                else
                    fallback()
                end
            end, {'i', 's'}),

            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, {'i', 's'}),
        },
    })
end
 
return {
    setup = setup
}
  


