-- lsp.lua

-- Load the lsp-zero library with the 'recommended' preset
local lsp = require('lsp-zero').preset('recommended')

-- Ensure the specified language servers are installed
lsp.ensure_installed({
  'tsserver',       -- TypeScript server
  'eslint',         -- ESLint for linting
  'lua_ls',         -- Lua language server
  'rust_analyzer',  -- Rust language server
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

-- Adjust   

-- Adjust the completion sources and their priorities
lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = cmp.config.sources({
    { name = 'cmp_tabnine', priority = 1000 }, -- TabNine source with highest priority
    { name = 'nvim_lsp',     priority = 750 }, -- LSP source
    { name = 'buffer',       priority = 500 }, -- Buffer source
    -- Add other sources if needed
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Set up icons and labels using lspkind
      vim_item.kind = lspkind.presets.default[vim_item.kind] .. ' ' .. vim_item.kind

      -- Customize appearance for cmp_tabnine suggestions
      if entry.source.name == 'cmp_tabnine' then
        local detail = (entry.completion_item.data or {}).detail
        vim_item.kind = '' -- Icon for TabNine
        if detail and detail:find('.*%%.*') then
          vim_item.kind = vim_item.kind .. ' ' .. detail -- Append detail if available
        end
        if (entry.completion_item.data or {}).multiline then
          vim_item.kind = vim_item.kind .. ' ' .. '[ML]' -- Indicate multiline suggestion
        end
      end

      -- Set the source name in the completion menu
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        cmp_tabnine = "[TabNine]",
      })[entry.source.name]

      return vim_item
    end,
  },
})

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

