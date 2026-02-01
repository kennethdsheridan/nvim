-- LSP Completion Configuration with nvim-cmp
-- This provides auto-completion with Tab navigation

local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
    return
end

local luasnip_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_ok then
    return
end

-- Load friendly snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Icons for completion menu
local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "",
}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    
    mapping = cmp.mapping.preset.insert({
        -- Tab/Shift-Tab for navigating completion menu
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback() -- Insert literal Tab if no completion
            end
        end, { 'i', 's' }),
        
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        
        -- Other useful mappings
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(), -- Manually trigger completion
        ['<C-e>'] = cmp.mapping.abort(),        -- Close completion menu
        ['<CR>'] = cmp.mapping.confirm({ 
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,  -- Auto-select first item if nothing selected
        }),
        
        -- Arrow keys for navigation (optional, in addition to Tab)
        ['<Up>'] = cmp.mapping.select_prev_item(),
        ['<Down>'] = cmp.mapping.select_next_item(),
    }),
    
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Add icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            
            -- Show source
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            
            return vim_item
        end,
    },
    
    sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },  -- LSP completions (highest priority)
        { name = 'luasnip', priority = 750 },    -- Snippets
        { name = 'path', priority = 500 },       -- File paths
    }, {
        { name = 'buffer', priority = 250 },     -- Current buffer (fallback)
    }),
    
    -- Better completion experience
    experimental = {
        ghost_text = false,  -- Preview completion (set to true if you want)
    },
    
    -- Performance
    performance = {
        max_view_entries = 20,
    },
})

-- File type specific sources
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})

-- SQL completion (for your dadbod setup)
cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
    sources = cmp.config.sources({
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
    })
})

-- Command line completion
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Auto-show completion menu when typing (optional)
vim.o.completeopt = "menu,menuone,noselect"

-- Optional: Show completion menu after typing 2 characters
-- Integration with autopairs if installed
local autopairs_ok, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
if autopairs_ok then
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end