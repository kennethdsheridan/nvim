-- Make sure this file is the single source of truth for language servers
-- (i.e., do NOT call "require('lspconfig').rust_analyzer.setup({})" elsewhere).
-- 1. Load the lsp-zero library with the 'recommended' preset
local lsp = require('lsp-zero').preset('recommended')

-- 2. Improve completion quality of life
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- 3. Mason setup for installing and managing LSP servers
require('mason').setup()

-- MONKEY PATCH: Disable automatic_enable before mason-lspconfig setup
local automatic_enable = require('mason-lspconfig.features.automatic_enable')
automatic_enable.init = function() end       -- Override init to do nothing
automatic_enable.enable_all = function() end -- Override enable_all to do nothing

require('mason-lspconfig').setup({
    ensure_installed = {
        'ts_ls', -- UPDATED: was tsserver
        'eslint',
        'html',
        'cssls',
        'tailwindcss',
        'lua_ls',
        'pyright',
        'rust_analyzer',
        'gopls',
        'clangd',
        'bashls',
        'jsonls',
        'yamlls',
        'dockerls',
        'marksman',
    },
    automatic_installation = false, -- Still set to false for extra measure
})

-- Manual LSP configuration (setup_handlers is not available in your version)
local lspconfig = require('lspconfig')

-- Default configuration for most servers
local default_servers = {
    'ts_ls', -- UPDATED: was tsserver
    'eslint',
    'html',
    'cssls',
    'tailwindcss',
    'pyright',
    'gopls',
    'clangd',
    'bashls',
    'jsonls',
    'yamlls',
    'dockerls',
    'marksman',
}

for _, server in ipairs(default_servers) do
    lspconfig[server].setup({
        on_attach = lsp.on_attach,
        capabilities = lsp.get_capabilities(),
    })
end

-- Special configuration for lua_ls
lspconfig.lua_ls.setup({
    on_attach = lsp.on_attach,
    capabilities = lsp.get_capabilities(),
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

-- Enhanced rust-analyzer configuration
lspconfig.rust_analyzer.setup({
    on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
        
        -- Enable inlay hints for Rust
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
        
        -- Rust-specific keybindings
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "<leader>rr", "<cmd>RustRunnables<cr>", opts)
        vim.keymap.set("n", "<leader>rd", "<cmd>RustDebuggables<cr>", opts)
        vim.keymap.set("n", "<leader>re", "<cmd>RustExpandMacro<cr>", opts)
        vim.keymap.set("n", "<leader>rc", "<cmd>RustOpenCargo<cr>", opts)
        vim.keymap.set("n", "<leader>rp", "<cmd>RustParentModule<cr>", opts)
        vim.keymap.set("n", "<leader>rj", "<cmd>RustJoinLines<cr>", opts)
        vim.keymap.set("n", "<leader>rh", "<cmd>RustHoverActions<cr>", opts)
        vim.keymap.set("n", "<leader>rH", "<cmd>RustHoverRange<cr>", opts)
        vim.keymap.set("n", "<leader>rm", "<cmd>RustMoveItemDown<cr>", opts)
        vim.keymap.set("n", "<leader>rM", "<cmd>RustMoveItemUp<cr>", opts)
    end,
    capabilities = lsp.get_capabilities(),
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = function(fname)
        local util = require('lspconfig.util')
        -- Look for Cargo.toml in parent directories
        local cargo_crate_root = util.root_pattern('Cargo.toml')(fname)
        -- Look for rust-project.json for non-cargo projects
        local rust_project_root = util.root_pattern('rust-project.json')(fname)
        
        -- Prioritize workspace root if we're in a workspace
        if cargo_crate_root then
            local cargo_toml = cargo_crate_root .. '/Cargo.toml'
            local file = io.open(cargo_toml, 'r')
            if file then
                local content = file:read('*all')
                file:close()
                -- If this is a workspace member, try to find the workspace root
                if not content:match('%[workspace%]') then
                    local parent = vim.fn.fnamemodify(cargo_crate_root, ':h')
                    while parent ~= '/' and parent ~= '' do
                        local parent_cargo = parent .. '/Cargo.toml'
                        local parent_file = io.open(parent_cargo, 'r')
                        if parent_file then
                            local parent_content = parent_file:read('*all')
                            parent_file:close()
                            if parent_content:match('%[workspace%]') then
                                return parent
                            end
                        end
                        parent = vim.fn.fnamemodify(parent, ':h')
                    end
                end
            end
            return cargo_crate_root
        end
        
        return rust_project_root or util.find_git_ancestor(fname)
    end,
    settings = {
        ["rust-analyzer"] = {
            -- Import settings
            imports = {
                granularity = {
                    group = "module",
                },
                merge = {
                    glob = true,
                },
                prefix = "self",
            },
            
            -- Cargo settings
            cargo = {
                buildScripts = {
                    enable = true,
                },
                features = "all",
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
                -- Target specific settings
                target = nil, -- Will use the default target
            },
            
            -- Check on save settings (using clippy)
            checkOnSave = {
                enable = true,
                command = "clippy",
                extraArgs = {
                    "--",
                    "-W", "clippy::pedantic",
                    "-W", "clippy::nursery",
                    "-W", "clippy::unwrap_used",
                    "-W", "clippy::expect_used"
                },
                allFeatures = true,
            },
            
            -- Diagnostics settings
            diagnostics = {
                enable = true,
                experimental = {
                    enable = true,
                },
                disabled = {
                    -- Disable specific diagnostics if needed
                },
                enableExperimental = true,
                warningsAsHint = {
                    -- Downgrade specific warnings to hints
                },
                warningsAsInfo = {
                    -- Downgrade specific warnings to info
                },
            },
            
            -- Inlay hints configuration
            inlayHints = {
                bindingModeHints = {
                    enable = false,
                },
                chainingHints = {
                    enable = true,
                },
                closingBraceHints = {
                    enable = true,
                    minLines = 25,
                },
                closureReturnTypeHints = {
                    enable = "never",
                },
                lifetimeElisionHints = {
                    enable = "never",
                    useParameterNames = false,
                },
                maxLength = 25,
                parameterHints = {
                    enable = true,
                },
                reborrowHints = {
                    enable = "never",
                },
                renderColons = true,
                typeHints = {
                    enable = true,
                    hideClosureInitialization = false,
                    hideNamedConstructor = false,
                },
            },
            
            -- Lens settings (code lens)
            lens = {
                enable = true,
                debug = true,
                implementations = true,
                references = true,
                methodReferences = true,
                enumVariantReferences = true,
            },
            
            -- Proc macro settings
            procMacro = {
                enable = true,
                attributes = {
                    enable = true,
                },
                ignored = {
                    -- List of proc macros to ignore
                },
            },
            
            -- Rust fmt settings
            rustfmt = {
                enableRangeFormatting = true,
                extraArgs = {},
                overrideCommand = nil,
            },
            
            -- Workspace settings
            workspace = {
                symbol = {
                    search = {
                        kind = "all_symbols",
                        limit = 128,
                        scope = "workspace",
                    },
                },
            },
            
            -- Completion settings
            completion = {
                addCallArgumentSnippets = true,
                addCallParenthesis = true,
                postfix = {
                    enable = true,
                },
                autoimport = {
                    enable = true,
                },
                autoself = {
                    enable = true,
                },
            },
            
            -- Hover settings
            hover = {
                documentation = {
                    enable = true,
                    keywords = {
                        enable = true,
                    },
                },
                links = {
                    enable = true,
                },
            },
            
            -- Join lines settings
            joinLines = {
                joinAssignments = true,
                joinElseIf = true,
                removeTrailingComma = true,
                unwrapTrivialBlock = true,
            },
            
            -- Highlighting settings
            highlighting = {
                strings = {
                    enable = true,
                },
            },
            
            -- Files to watch
            files = {
                excludeDirs = {},
                watcher = "client",
            },
        }
    },
})

-- 4. Set up nvim-cmp for autocompletion
local cmp = require('cmp')
local lspkind = require('lspkind')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>']     = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>']     = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>']     = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    -- ['<Tab>']     = cmp.mapping.confirm({ select = true }),  -- DISABLED TAB COMPLETION
})
cmp.setup({
    enabled = true,
    completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        completeopt = 'menu,menuone,noselect',
    },
    mapping = cmp_mappings,
    sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 750 },
        { name = 'buffer',   priority = 500 },
        { name = 'path',     priority = 300 },
    }),
    formatting = {
        -- ▼ Add the expandable_indicator to avoid typecheck warnings.
        expandable_indicator = false,
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Use lspkind icons
            vim_item.kind = lspkind.presets.default[vim_item.kind] or ""
            -- Special rust icon for Rust modules
            if entry.source.name == 'nvim_lsp'
                and vim_item.kind == 'Module'
                and entry.completion_item.label:find("::")
            then
                vim_item.kind = '🦀'
            end
            vim_item.menu = ({
                buffer   = "[Buffer]",
                nvim_lsp = "[LSP]",
                path     = "[Path]",
                luasnip  = "[Snippet]",
            })[entry.source.name] or ""
            return vim_item
        end,
    },
})

-- 5. Configure on_attach behavior: LSP keymaps, etc.
-- Using standard LSP keybindings that work consistently across all projects
lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }
    
    -- Standard LSP navigation (these should work with Command+K, gd, gr)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) 
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    
    -- Diagnostics
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    
    -- Code actions and refactoring
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    
    -- Other useful LSP functions
    vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
end)

-- 6. Finally set everything up
lsp.setup()

