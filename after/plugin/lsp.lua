-- Native Neovim LSP Configuration
-- No external dependencies except mason for server installation

-- 1. Completion setup
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- 2. Mason setup (keep this for installing LSP servers)
local mason_ok, mason = pcall(require, 'mason')
if mason_ok then
    mason.setup()
else
    vim.notify("Mason not available", vim.log.levels.WARN)
end

-- 3. Native LSP capabilities for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' }
}

-- 4. Common on_attach function
local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    
    -- Standard LSP navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) 
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    
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
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end

-- 5. Root directory detection (using lspconfig utilities)
local lspconfig_ok, util = pcall(require, 'lspconfig.util')
if not lspconfig_ok then
    vim.notify("lspconfig not available", vim.log.levels.ERROR)
    return
end

local function rust_root_dir(fname)
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
end

-- 6. Language Server Configurations

-- Rust Analyzer
vim.lsp.config('rust-analyzer', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = rust_root_dir,
    single_file_support = true,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        
        -- Enable inlay hints for Rust
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
        
        -- Rust-specific keybindings (commented out - only enable if you have rust-tools)
        -- local opts = { buffer = bufnr, remap = false }
        -- vim.keymap.set("n", "<leader>rr", "<cmd>RustRunnables<cr>", opts)
        -- vim.keymap.set("n", "<leader>rd", "<cmd>RustDebuggables<cr>", opts)
    end,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = { group = "module" },
                merge = { glob = true },
                prefix = "self",
            },
            cargo = {
                buildScripts = { enable = true },
                features = "all",
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
            },
            checkOnSave = {
                enable = true,
                command = "clippy",
                extraArgs = {
                    "--", "-W", "clippy::pedantic",
                    "-W", "clippy::nursery",
                    "-W", "clippy::unwrap_used",
                    "-W", "clippy::expect_used"
                },
                allFeatures = true,
            },
            diagnostics = {
                enable = true,
                experimental = { enable = true },
                enableExperimental = true,
            },
            inlayHints = {
                bindingModeHints = { enable = false },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true, minLines = 25 },
                closureReturnTypeHints = { enable = "never" },
                lifetimeElisionHints = { enable = "never", useParameterNames = false },
                maxLength = 25,
                parameterHints = { enable = true },
                reborrowHints = { enable = "never" },
                renderColons = true,
                typeHints = {
                    enable = true,
                    hideClosureInitialization = false,
                    hideNamedConstructor = false,
                },
            },
            lens = {
                enable = true,
                debug = true,
                implementations = true,
                references = true,
                methodReferences = true,
                enumVariantReferences = true,
            },
            procMacro = {
                enable = true,
                attributes = { enable = true },
            },
            hover = {
                documentation = { enable = true, keywords = { enable = true } },
                links = { enable = true },
            },
            completion = {
                addCallArgumentSnippets = true,
                addCallParenthesis = true,
                postfix = { enable = true },
                autoimport = { enable = true },
                autoself = { enable = true },
            },
        }
    },
})

-- Lua Language Server
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_dir = function(fname)
        return util.root_pattern('.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git')(fname)
    end,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- Other Language Servers (add as needed)
local simple_servers = {
    'ts_ls', 'eslint', 'html', 'cssls', 'tailwindcss', 'pyright',
    'gopls', 'clangd', 'bashls', 'jsonls', 'yamlls', 'dockerls',
    'marksman', 'nil_ls'
}

for _, server in ipairs(simple_servers) do
    vim.lsp.config(server, {
        on_attach = on_attach,
        capabilities = capabilities,
    })
    vim.lsp.enable(server)
end

-- Enable rust-analyzer and lua_ls
vim.lsp.enable('rust-analyzer')
vim.lsp.enable('lua_ls')

-- 7. Completion setup with nvim-cmp
local cmp_ok, cmp = pcall(require, 'cmp')
local lspkind_ok, lspkind = pcall(require, 'lspkind')

if not cmp_ok then
    vim.notify("nvim-cmp not available", vim.log.levels.WARN)
    return
end

if not lspkind_ok then
    vim.notify("lspkind not available", vim.log.levels.WARN)
    return
end

cmp.setup({
    enabled = true,
    completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        completeopt = 'menu,menuone,noselect',
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 750 },
        { name = 'buffer', priority = 500 },
        { name = 'path', priority = 300 },
    }),
    formatting = {
        expandable_indicator = false,
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind] or ""
            if entry.source.name == 'nvim_lsp' and vim_item.kind == 'Module' and entry.completion_item.label:find("::") then
                vim_item.kind = '🦀'
            end
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                path = "[Path]",
            })[entry.source.name] or ""
            return vim_item
        end,
    },
})