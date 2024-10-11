-- lsp.lua

-- Load the lsp-zero library with the 'recommended' preset
local lsp = require('lsp-zero').preset('recommended')

-- Mason setup for installing and managing LSP servers
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'tsserver',
    'eslint',
    'lua_ls',
    'rust_analyzer',
  },
  automatic_installation = true, -- Optional, automatically install LSP servers
})

-- Require necessary modules
local cmp = require('cmp')         -- Completion engine
local lspkind = require('lspkind') -- Adds icons to completion items

-- Configure cmp_tabnine before setting up nvim-cmp
local cmp_tabnine = require('cmp_tabnine.config')
cmp_tabnine:setup({
  max_lines = 1000,                -- Max lines to parse
  max_num_results = 10,            -- Max number of suggestions
  sort = true,                     -- Enable sorting of suggestions
  run_on_every_keystroke = true,   -- Update suggestions on every keystroke
  snippet_placeholder = '..',      -- Placeholder for snippets
  ignored_file_types = {},         -- Ignore suggestions for specified file types
  show_prediction_strength = true, -- Display prediction strength
  debounce_ms = 100,               -- Debounce time in milliseconds
  -- log_file_path = '/tmp/tabnine.log',  -- Enable logging if needed
})

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
    { name = 'cmp_tabnine', priority = 1000 },
    { name = 'nvim_lsp', priority = 750 },
    { name = 'buffer', priority = 500 },
  },
  
  -- Formatting block for custom icons and source display
  formatting = {
    format = function(entry, vim_item)
      -- Use default lspkind icons, with a fallback to empty if none exists
      vim_item.kind = lspkind.presets.default[vim_item.kind] or ""

      -- Add Rust-specific icon 🦀 for rust_analyzer LSP items (e.g., Rust modules)
      if entry.source.name == 'nvim_lsp' and vim_item.kind == 'Module' and entry.completion_item.label:find("::") then
        vim_item.kind = '🦀'  -- Rust crab emoji for Rust modules
      end

      -- Customize appearance for cmp_tabnine suggestions
      if entry.source.name == 'cmp_tabnine' then
        local detail = (entry.completion_item.data or {}).detail
        vim_item.kind = '' -- Lightning bolt icon for TabNine suggestions

        -- Append detail information if available
        if detail then
          vim_item.menu = "[TabNine: " .. detail .. "]"
        else
          vim_item.menu = "[TabNine]"
        end

        -- Indicate if the suggestion is multi-line
        if (entry.completion_item.data or {}).multiline then
          vim_item.menu = vim_item.menu .. ' [ML]'  -- Elegant multiline indicator
        end
      else
        -- For other sources, keep menu display simple and clean
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          path = "[Path]",
          luasnip = "[Snippet]",
        })[entry.source.name] or ""
      end

      return vim_item
    end,
  },
}) -- This was missing its closing parenthesis

-- Configure LSP client on attachment to buffer
lsp.on_attach(function(client, bufnr)
  -- Set up key mappings for LSP functions
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)           -- Go to definition
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                 -- Hover for info
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts) -- Workspace symbols
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)    -- Open diagnostics
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)             -- Next diagnostic
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)             -- Previous diagnostic
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)     -- Code action
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)      -- References
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)          -- Rename symbol
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)        -- Signature help
end)

-- Initialize the lsp setup
lsp.setup()

