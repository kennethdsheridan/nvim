-- Native Neovim 0.11+ LSP Configuration
-- Uses the new vim.lsp.config API (no external dependencies)

-- 1. Completion setup
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- 2. Mason setup (optional, for installing LSP servers)
local mason_ok, mason = pcall(require, 'mason')
if mason_ok then
    mason.setup()
    
    -- Auto-install key language servers if not found
    vim.defer_fn(function()
        local servers_to_install = {}
        
        if vim.fn.executable('rust-analyzer') == 0 then
            table.insert(servers_to_install, 'rust-analyzer')
        end
        if vim.fn.executable('lua-language-server') == 0 then
            table.insert(servers_to_install, 'lua-language-server')
        end
        if vim.fn.executable('pyright-langserver') == 0 then
            table.insert(servers_to_install, 'pyright')
        end
        if vim.fn.executable('typescript-language-server') == 0 then
            table.insert(servers_to_install, 'typescript-language-server')
        end
        if vim.fn.executable('vscode-json-language-server') == 0 then
            table.insert(servers_to_install, 'json-lsp')
        end
        if vim.fn.executable('bash-language-server') == 0 then
            table.insert(servers_to_install, 'bash-language-server')
        end
        
        if #servers_to_install > 0 then
            vim.notify("Installing language servers via Mason: " .. table.concat(servers_to_install, ", "), vim.log.levels.INFO)
            for _, server in ipairs(servers_to_install) do
                vim.cmd('MasonInstall ' .. server)
            end
        end
    end, 2000)
else
    vim.notify("Mason not available", vim.log.levels.WARN)
end

-- 3. LSP capabilities for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' }
}

-- Update capabilities with cmp if available
local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- 4. Common on_attach function
local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    
    -- Override the default K mapping explicitly for LSP hover
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    
    -- Standard LSP navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) 
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    
    -- Alternative hover mapping in case K doesn't work
    vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
    
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
    
    -- Show LSP info
    vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", opts)
    
    -- Debug: Show that LSP is attached
    vim.notify("LSP attached: " .. client.name .. " to buffer " .. bufnr, vim.log.levels.INFO)
end

-- 5. Root directory detection
local function rust_root_dir(fname)
    -- Look for Cargo.toml in parent directories
    local function find_cargo_toml(path)
        local current = path
        while current ~= '/' and current ~= '' do
            local cargo_path = current .. '/Cargo.toml'
            if vim.fn.filereadable(cargo_path) == 1 then
                vim.notify("Found Cargo.toml at: " .. current, vim.log.levels.DEBUG)
                return current
            end
            current = vim.fn.fnamemodify(current, ':h')
        end
        return nil
    end
    
    local dir = vim.fn.fnamemodify(fname, ':h')
    local root = find_cargo_toml(dir)
    if not root then
        vim.notify("No Cargo.toml found for " .. fname .. ", using cwd", vim.log.levels.WARN)
        root = vim.fn.getcwd()
    end
    return root
end

-- 6. Language Server Configurations using vim.lsp.config

-- Auto-start rust-analyzer for Rust files using the working approach
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function(ev)
        local bufnr = ev.buf
        
        -- Check if LSP is already attached
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        for _, client in ipairs(clients) do
            if client.name:match('rust.analyzer') then
                return -- Already attached
            end
        end
        
        -- Start rust-analyzer
        vim.lsp.start({
            name = 'rust-analyzer',
            cmd = { 'rust-analyzer' },
            root_dir = rust_root_dir(vim.api.nvim_buf_get_name(bufnr)),
            capabilities = capabilities,
            on_attach = function(client, buf)
                on_attach(client, buf)
                
                -- Enable inlay hints for Rust
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
                end
                
                vim.notify("rust-analyzer attached to buffer " .. buf, vim.log.levels.INFO)
            end,
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        buildScripts = { enable = true },
                        allFeatures = true,
                    },
                    checkOnSave = {
                        enable = true,
                        command = "clippy",
                    },
                    diagnostics = {
                        enable = true,
                    },
                    hover = {
                        documentation = { enable = true },
                    },
                    completion = {
                        addCallArgumentSnippets = true,
                        addCallParenthesis = true,
                        autoimport = { enable = true },
                    },
                }
            },
        })
    end,
})

-- Lua Language Server
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_dir = function(fname)
        local function find_project_root(path)
            local patterns = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' }
            local current = path
            while current ~= '/' and current ~= '' do
                for _, pattern in ipairs(patterns) do
                    if vim.fn.filereadable(current .. '/' .. pattern) == 1 or vim.fn.isdirectory(current .. '/' .. pattern) == 1 then
                        return current
                    end
                end
                current = vim.fn.fnamemodify(current, ':h')
            end
            return vim.fn.getcwd()
        end
        
        local dir = vim.fn.fnamemodify(fname, ':h')
        return find_project_root(dir)
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

-- Enable lua_ls
vim.lsp.enable('lua_ls')

-- Helper function to start LSP servers for various languages
local function setup_language_server(filetype, server_name, cmd, root_patterns, settings)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetype,
        callback = function(ev)
            local bufnr = ev.buf
            
            -- Check if LSP is already attached
            local clients = vim.lsp.get_clients({ bufnr = bufnr })
            for _, client in ipairs(clients) do
                if client.name == server_name then
                    return -- Already attached
                end
            end
            
            -- Find root directory
            local function find_root(patterns)
                local path = vim.api.nvim_buf_get_name(bufnr)
                local dir = vim.fn.fnamemodify(path, ':h')
                
                while dir ~= '/' and dir ~= '' do
                    for _, pattern in ipairs(patterns) do
                        if vim.fn.filereadable(dir .. '/' .. pattern) == 1 or 
                           vim.fn.isdirectory(dir .. '/' .. pattern) == 1 then
                            return dir
                        end
                    end
                    dir = vim.fn.fnamemodify(dir, ':h')
                end
                return vim.fn.getcwd()
            end
            
            -- Check if server executable exists
            if vim.fn.executable(cmd[1]) == 0 then
                return -- Server not available
            end
            
            -- Start the server
            vim.lsp.start({
                name = server_name,
                cmd = cmd,
                root_dir = find_root(root_patterns),
                capabilities = capabilities,
                on_attach = on_attach,
                settings = settings or {},
            })
        end,
    })
end

-- Python (pyright)
setup_language_server(
    "python",
    "pyright",
    { "pyright-langserver", "--stdio" },
    { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
    {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            }
        }
    }
)

-- Go (gopls)
setup_language_server(
    "go",
    "gopls",
    { "gopls" },
    { "go.mod", ".git" },
    {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        }
    }
)

-- Bash (bash-language-server)
setup_language_server(
    { "sh", "bash", "zsh" },
    "bashls",
    { "bash-language-server", "start" },
    { ".git" },
    {
        bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)",
        }
    }
)

-- Nix (nil)
setup_language_server(
    "nix",
    "nil",
    { "nil" },
    { "flake.nix", "default.nix", "shell.nix", ".git" },
    {
        ["nil"] = {
            formatting = {
                command = { "nixpkgs-fmt" },
            },
        }
    }
)

-- Markdown (marksman)
setup_language_server(
    "markdown",
    "marksman",
    { "marksman", "server" },
    { ".git", "README.md" },
    {}
)

-- Vim (vim-language-server)
setup_language_server(
    "vim",
    "vim-language-server",
    { "vim-language-server", "--stdio" },
    { ".vimrc", "init.vim", ".git" },
    {
        vimls = {
            isNeovim = true,
            iskeyword = "@,48-57,_,192-255,-#",
            runtimepath = "",
            diagnostic = {
                enable = true,
            },
            indexes = {
                runtimepath = true,
                gap = 100,
                count = 3,
            },
            suggest = {
                fromRuntimepath = true,
                fromVimruntime = true,
            },
        }
    }
)

-- C/C++ (clangd) - you have this installed!
setup_language_server(
    { "c", "cpp", "cc", "cxx", "objc", "objcpp" },
    "clangd",
    { 
        "clangd",
        "--background-index",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--header-insertion=iwyu",
    },
    { "compile_commands.json", "compile_flags.txt", "CMakeLists.txt", "Makefile", ".git" },
    {}
)

-- TypeScript/JavaScript (when available)
setup_language_server(
    { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    "ts_ls",
    { "typescript-language-server", "--stdio" },
    { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
    {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            }
        }
    }
)

-- JSON (when available)
setup_language_server(
    "json",
    "jsonls",
    { "vscode-json-language-server", "--stdio" },
    { ".git" },
    {
        json = {
            schemas = {
                {
                    fileMatch = { "package.json" },
                    url = "https://json.schemastore.org/package.json"
                },
                {
                    fileMatch = { "tsconfig*.json" },
                    url = "https://json.schemastore.org/tsconfig.json"
                },
            }
        }
    }
)

-- TOML (when available)
setup_language_server(
    "toml",
    "taplo",
    { "taplo", "lsp", "stdio" },
    { "Cargo.toml", "pyproject.toml", ".git" },
    {
        taplo = {
            schema = {
                enabled = true,
                catalogs = {
                    "https://www.schemastore.org/api/json/catalog.json",
                }
            }
        }
    }
)

-- Additional servers for completeness
local other_servers = {
    { "yaml", "yamlls", { "yaml-language-server", "--stdio" }, { ".git" } },
    { "dockerfile", "dockerls", { "docker-langserver", "--stdio" }, { "Dockerfile", ".git" } },
    { "html", "html", { "vscode-html-language-server", "--stdio" }, { ".git" } },
    { "css", "cssls", { "vscode-css-language-server", "--stdio" }, { ".git" } },
}

for _, config in ipairs(other_servers) do
    setup_language_server(config[1], config[2], config[3], config[4], {})
end

-- Global autocmd to ensure LSP keybindings work in Rust files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function(ev)
        local bufnr = ev.buf
        
        -- Disable keywordprg (man pages) for Rust files
        vim.bo[bufnr].keywordprg = ""
        
        -- Set LSP keybindings immediately
        local opts = { buffer = bufnr, noremap = true, silent = true }
        
        -- Force override K for hover (highest priority)
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
        end, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        
        -- Also wait for LSP and notify when attached
        vim.defer_fn(function()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })
            if #clients > 0 then
                vim.notify("LSP attached: " .. clients[1].name .. " to Rust buffer " .. bufnr, vim.log.levels.INFO)
            else
                vim.notify("Warning: No LSP clients attached to Rust buffer " .. bufnr, vim.log.levels.WARN)
            end
        end, 2000)
    end,
})

-- Also set a global autocmd for when LSP actually attaches
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        
        if client and client.name == "rust-analyzer" then
            -- Disable keywordprg for this buffer
            vim.bo[bufnr].keywordprg = ""
            
            local opts = { buffer = bufnr, noremap = true, silent = true }
            
            -- Set keybindings with highest priority
            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover()
            end, opts)
            
            vim.notify("rust-analyzer attached! K should now work for hover.", vim.log.levels.INFO)
        end
    end,
})

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Debug command to check LSP status
vim.api.nvim_create_user_command('LspDebug', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    
    print("=== LSP Debug Info ===")
    print("Buffer: " .. bufnr)
    print("Filetype: " .. vim.bo.filetype)
    print("Keywordprg: '" .. vim.bo.keywordprg .. "'")
    print("LSP Clients attached: " .. #clients)
    
    for i, client in ipairs(clients) do
        print("  " .. i .. ": " .. client.name .. " (id: " .. client.id .. ")")
    end
    
    if #clients == 0 then
        print("❌ No LSP clients attached!")
        print("Configured servers:")
        local configured_servers = { "rust-analyzer", "lua_ls" }
        for _, server in ipairs(configured_servers) do
            print("  - " .. server)
        end
    end
    
    -- Test keymapping
    local maps = vim.api.nvim_buf_get_keymap(bufnr, 'n')
    local k_map = nil
    for _, map in ipairs(maps) do
        if map.lhs == 'K' then
            k_map = map
            break
        end
    end
    
    if k_map then
        print("K mapping found: " .. (k_map.rhs or "function"))
    else
        print("❌ No K mapping found for this buffer")
    end
    
    print("=== End Debug Info ===")
end, { desc = "Debug LSP status and keymappings" })

-- Test command to manually trigger hover
vim.api.nvim_create_user_command('TestHover', function()
    print("Testing LSP hover...")
    vim.lsp.buf.hover()
end, { desc = "Test LSP hover functionality" })

-- Command to restart LSP for current buffer
vim.api.nvim_create_user_command('LspRestart', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    
    for _, client in ipairs(clients) do
        vim.notify("Restarting " .. client.name, vim.log.levels.INFO)
        client.stop()
    end
    
    -- Wait a moment then restart
    vim.defer_fn(function()
        vim.cmd('edit!')
    end, 1000)
end, { desc = "Restart LSP for current buffer" })

-- Command to check language server support
vim.api.nvim_create_user_command('LspStatus', function()
    local servers = {
        { "🦀 Rust", "rust-analyzer", "rust" },
        { "🌙 Lua", "lua-language-server", "lua" },
        { "🐍 Python", "pyright-langserver", "python" },
        { "🐹 Go", "gopls", "go" },
        { "🐚 Bash", "bash-language-server", "bash/sh" },
        { "❄️  Nix", "nil", "nix" },
        { "📝 Markdown", "marksman", "markdown" },
        { "📄 Vim", "vim-language-server", "vim" },
        { "🟨 TypeScript/JS", "typescript-language-server", "typescript/javascript" },
        { "📋 TOML", "taplo", "toml" },
        { "📄 JSON", "vscode-json-language-server", "json" },
        { "⚡ C/C++", "clangd", "c/cpp" },
        { "🌐 HTML", "vscode-html-language-server", "html" },
        { "🎨 CSS", "vscode-css-language-server", "css" },
        { "📊 YAML", "yaml-language-server", "yaml" },
    }
    
    print("=== Language Server Status ===")
    for _, server in ipairs(servers) do
        local icon, cmd, lang = server[1], server[2], server[3]
        local status = vim.fn.executable(cmd) == 1 and "✅ Ready" or "❌ Not installed"
        print(string.format("%s %-20s %s", icon, lang, status))
    end
    
    print("\n📦 Install missing servers with:")
    print("  :MasonInstall <server-name>")
    print("  Or use package manager (brew, nix, npm, etc.)")
    print("\n🔍 Check current buffer: :LspDebug")
end, { desc = "Show language server support status" })

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