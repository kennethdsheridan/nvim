-- Native Neovim 0.11+ LSP Configuration
-- Uses the new vim.lsp.config API (no external dependencies)

-- Aesthetic icons and symbols
local icons = {
    error = " ",
    warn = " ",
    hint = " ",
    info = " ",
    ok = "✓ ",
    server = " ",
    package = " ",
    dot = "●",
    arrow = "➜",
    branch = " ",
    gear = " ",
    magic = "✨",
    rocket = "🚀",
}

-- Silent startup (remove print statement)
-- print("LSP config loading")

-- Suppress LSP exit error messages
vim.lsp.log.set_level(vim.log.levels.ERROR)
vim.notify = (function()
    local original_notify = vim.notify
    return function(msg, level, opts)
        -- Filter out LSP server exit messages
        if msg and type(msg) == "string" then
            if msg:match("Client %d+ quit with exit code") or
               msg:match("marksman quit") or
               msg:match("LSP.*quit.*exit") then
                return -- Suppress these messages
            end
        end
        return original_notify(msg, level, opts)
    end
end)()

-- Create a command to show full documentation in a split
vim.api.nvim_create_user_command('LspDoc', function()
    -- Open hover documentation in a new split
    vim.lsp.buf.hover()
    vim.cmd('wincmd L')  -- Move to the right
    vim.cmd('vertical resize 80')  -- Set width
end, { desc = 'Show LSP documentation in split' })

-- Set up highlight groups for lighter LSP windows
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#3a3a3a', fg = '#e0e0e0' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#3a3a3a', fg = '#808080' })
vim.api.nvim_set_hl(0, 'DiagnosticFloatError', { bg = '#3a3a3a', fg = '#ff6b6b' })
vim.api.nvim_set_hl(0, 'DiagnosticFloatWarn', { bg = '#3a3a3a', fg = '#ffd93d' })
vim.api.nvim_set_hl(0, 'DiagnosticFloatInfo', { bg = '#3a3a3a', fg = '#6bcf7f' })
vim.api.nvim_set_hl(0, 'DiagnosticFloatHint', { bg = '#3a3a3a', fg = '#a8dadc' })
vim.api.nvim_set_hl(0, 'DiagnosticFloatBorder', { bg = '#3a3a3a', fg = '#606060' })

-- Configure LSP UI for beautiful and useful hover windows
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
    return vim.lsp.handlers.hover(err, result, ctx, vim.tbl_deep_extend("force", config or {}, {
        border = {
            {"╭", "FloatBorder"},
            {"─", "FloatBorder"},
            {"╮", "FloatBorder"},
            {"│", "FloatBorder"},
            {"╯", "FloatBorder"},
            {"─", "FloatBorder"},
            {"╰", "FloatBorder"},
            {"│", "FloatBorder"},
        },
        max_width = 100,
        max_height = 40,
        focusable = true,
        pad_top = 1,
        pad_bottom = 1,
    }))
end

vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
    return vim.lsp.handlers.signature_help(err, result, ctx, vim.tbl_deep_extend("force", config or {}, {
        border = {
            {"╭", "FloatBorder"},
            {"─", "FloatBorder"},
            {"╮", "FloatBorder"},
            {"│", "FloatBorder"},
            {"╯", "FloatBorder"},
            {"─", "FloatBorder"},
            {"╰", "FloatBorder"},
            {"│", "FloatBorder"},
        },
        max_width = 80,
        focusable = true,
    }))
end

-- Better diagnostic display with aesthetic configuration
vim.diagnostic.config({
    virtual_text = {
        prefix = icons.dot,
        source = "if_many",
        spacing = 4,
        format = function(diagnostic)
            local severity_icon = ({
                [vim.diagnostic.severity.ERROR] = icons.error,
                [vim.diagnostic.severity.WARN] = icons.warn,
                [vim.diagnostic.severity.INFO] = icons.info,
                [vim.diagnostic.severity.HINT] = icons.hint,
            })[diagnostic.severity] or icons.dot
            
            return string.format("%s%s", severity_icon, diagnostic.message)
        end,
    },
    float = {
        border = {
            {"╭", "DiagnosticFloatBorder"},
            {"─", "DiagnosticFloatBorder"},
            {"╮", "DiagnosticFloatBorder"},
            {"│", "DiagnosticFloatBorder"},
            {"╯", "DiagnosticFloatBorder"},
            {"─", "DiagnosticFloatBorder"},
            {"╰", "DiagnosticFloatBorder"},
            {"│", "DiagnosticFloatBorder"},
        },
        source = "always",
        header = "",
        prefix = function(diagnostic, i, total)
            local severity_icon = ({
                [vim.diagnostic.severity.ERROR] = icons.error,
                [vim.diagnostic.severity.WARN] = icons.warn,
                [vim.diagnostic.severity.INFO] = icons.info,
                [vim.diagnostic.severity.HINT] = icons.hint,
            })[diagnostic.severity] or icons.dot
            return severity_icon .. " ", ""
        end,
        focusable = false,
        style = "minimal",
        max_width = 80,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.error,
            [vim.diagnostic.severity.WARN] = icons.warn,
            [vim.diagnostic.severity.INFO] = icons.info,
            [vim.diagnostic.severity.HINT] = icons.hint,
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- 1. Completion setup
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'preview' }
vim.opt.pumheight = 20  -- Show more items in completion menu

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
        if vim.fn.executable('shellcheck') == 0 then
            table.insert(servers_to_install, 'shellcheck')
        end
        if vim.fn.executable('shfmt') == 0 then
            table.insert(servers_to_install, 'shfmt')
        end
        
        if #servers_to_install > 0 then
            vim.notify(icons.package .. " Installing language servers: " .. table.concat(servers_to_install, ", "), vim.log.levels.INFO)
            for _, server in ipairs(servers_to_install) do
                vim.cmd('MasonInstall ' .. server)
            end
        end
    end, 2000)
else
    -- Silent when Mason not available (less noisy)
    -- vim.notify("Mason not available", vim.log.levels.WARN)
end

-- 3. LSP capabilities for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' }
}
capabilities.textDocument.hover = {
    dynamicRegistration = false,
    contentFormat = { 'markdown', 'plaintext' },
}
capabilities.textDocument.signatureHelp = {
    dynamicRegistration = false,
    signatureInformation = {
        documentationFormat = { 'markdown', 'plaintext' },
        activeParameterSupport = true,
    },
}

-- DISABLED: -- Update capabilities with cmp if available
-- DISABLED: local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
-- DISABLED: if cmp_ok then
-- DISABLED:     capabilities = cmp_lsp.default_capabilities()
-- DISABLED: end

-- 4. Common on_attach function
local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    
    -- Enhanced hover with beautiful window
    vim.keymap.set("n", "K", function()
        -- Close any existing hover windows first
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
                vim.api.nvim_win_close(win, true)
            end
        end
        -- Open new hover window
        vim.lsp.buf.hover()
    end, opts)
    
    -- Standard LSP navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) 
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    
    -- Alternative hover mapping with larger window
    vim.keymap.set("n", "<leader>k", function()
        vim.lsp.buf.hover({
            border = "double",
            max_width = 120,
            max_height = 50,
            focusable = true,
        })
    end, opts)
    
    -- Show full signature help
    vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, opts)
    
    -- Diagnostics with enhanced float window
    vim.keymap.set("n", "<leader>vd", function()
        vim.diagnostic.open_float({
            border = "rounded",
            max_width = 100,
            focusable = true,
            scope = "cursor",
            source = true,
        })
    end, opts)
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
    
    -- Aesthetic LSP attachment notification with capabilities info
    local capabilities_summary = {}
    if client.server_capabilities.hoverProvider then
        table.insert(capabilities_summary, "hover")
    end
    if client.server_capabilities.completionProvider then
        table.insert(capabilities_summary, "completion")
    end
    if client.server_capabilities.definitionProvider then
        table.insert(capabilities_summary, "definition")
    end
    if client.server_capabilities.referencesProvider then
        table.insert(capabilities_summary, "references")
    end
    if client.server_capabilities.documentFormattingProvider then
        table.insert(capabilities_summary, "formatting")
    end
    if client.server_capabilities.codeActionProvider then
        table.insert(capabilities_summary, "code-actions")
    end
    
    vim.notify(
        string.format("%s %s attached\n%s Capabilities: %s", 
            icons.server, 
            client.name, 
            icons.arrow,
            table.concat(capabilities_summary, ", ")
        ), 
        vim.log.levels.INFO
    )
end

-- 5. Root directory detection
local function rust_root_dir(fname)
    -- Look for Cargo.toml in parent directories
    local function find_cargo_toml(path)
        local current = path
        while current ~= '/' and current ~= '' do
            local cargo_path = current .. '/Cargo.toml'
            if vim.fn.filereadable(cargo_path) == 1 then
                return current
            end
            current = vim.fn.fnamemodify(current, ':h')
        end
        return nil
    end

    local dir = vim.fn.fnamemodify(fname, ':h')
    local root = find_cargo_toml(dir)
    if not root then
        root = vim.fn.getcwd()
    end
    return root
end

-- 6. Language Server Configurations using vim.lsp.config

-- Auto-start rust-analyzer for Rust files using BufReadPost
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.rs",
    callback = function(ev)
        -- Silent operation (removed debug print)
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
             end,
            settings = {
                 ["rust-analyzer"] = {
                     cargo = {
                         target = "x86_64-unknown-linux-musl",
                         allFeatures = true,
                         loadOutDirsFromCheck = true,
                     },
                     checkOnSave = {
                         enable = true,
                         command = "clippy",
                         allTargets = false,
                         extraArgs = { "--target", "x86_64-unknown-linux-musl" },
                     },
                     completion = {
                         addCallArgumentSnippets = true,
                         addCallParenthesis = true,
                         postfix = {
                             enable = true,
                         },
                     },
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
                     inlayHints = {
                         bindingModeHints = {
                             enable = true,
                         },
                         chainingHints = {
                             enable = true,
                         },
                         closingBraceHints = {
                             enable = true,
                             minLines = 25,
                         },
                         parameterHints = {
                             enable = true,
                         },
                         typeHints = {
                             enable = true,
                             hideClosureInitialization = false,
                             hideNamedConstructor = false,
                         },
                     },
                     lens = {
                         enable = true,
                         references = {
                             adt = {
                                 enable = true,
                             },
                             enumVariant = {
                                 enable = true,
                             },
                             method = {
                                 enable = true,
                             },
                             trait = {
                                 enable = true,
                             },
                         },
                     },
                     procMacro = {
                         enable = true,
                     },
                 }
             },
        })
    end,
})

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

-- Python (pyright) with enhanced documentation
setup_language_server(
    "python",
    "pyright",
    { "pyright-langserver", "--stdio" },
    { "pyproject.toml", "setup.py", "requirements.txt", "setup.cfg", "tox.ini", ".git" },
    {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
                completeFunctionParens = true,
                indexing = true,
                inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                },
            },
            linting = {
                enabled = true,
            },
            formatting = {
                enabled = true,
            },
        },
        pyright = {
            disableOrganizeImports = false,
        },
    }
)

-- Alternative: Python LSP Server (pylsp) - better for documentation
-- Uncomment if you prefer pylsp over pyright
-- setup_language_server(
--     "python",
--     "pylsp",
--     { "pylsp" },
--     { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
--     {
--         pylsp = {
--             plugins = {
--                 jedi_completion = {
--                     enabled = true,
--                     include_params = true,
--                     include_class_objects = true,
--                     fuzzy = true,
--                 },
--                 jedi_hover = { enabled = true },
--                 jedi_references = { enabled = true },
--                 jedi_signature_help = { enabled = true },
--                 jedi_symbols = { enabled = true },
--                 pycodestyle = { enabled = true },
--                 pydocstyle = { enabled = true },
--                 pylint = { enabled = false },
--                 yapf = { enabled = false },
--                 rope_completion = { enabled = true },
--             }
--         }
--     }
-- )

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

-- Lua Language Server
setup_language_server(
    "lua",
    "lua_ls",
    { "lua-language-server" },
    { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    {
        Lua = {
            diagnostics = { 
                globals = { 'vim', 'use' },
                disable = { "missing-fields" }
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
            format = { enable = false },
            hint = {
                enable = true,
                arrayIndex = "Disable",
                setType = true,
            },
        },
    }
)

-- Bash (bash-language-server) with enhanced documentation
setup_language_server(
    { "sh", "bash", "zsh" },
    "bashls",
    { "bash-language-server", "start" },
    { ".bashrc", ".zshrc", ".bash_profile", ".git" },
    {
        bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
            shellcheckPath = "shellcheck",
            shellcheckArguments = { "--shell=bash", "--exclude=SC2086" },
            includeAllWorkspaceSymbols = true,
            showHover = true,
            enableSourceErrorDiagnostics = true,
            explainshellEndpoint = "https://explainshell.com",
        }
    }
)

-- Nix (nixd - most advanced Nix LSP)
-- Features: completions, hover docs, go-to-definition, diagnostics, option completions
setup_language_server(
    "nix",
    "nixd",
    { "nixd" },
    { "flake.nix", "default.nix", "shell.nix", ".git" },
    {
        nixd = {
            formatting = {
                command = { "nixpkgs-fmt" },
            },
            nixpkgs = {
                -- Use flake nixpkgs for better completions
                expr = "import (builtins.getFlake \"/Users/kennysheridan/macos-nix-config\").inputs.nixpkgs { }",
            },
            options = {
                -- nix-darwin options (for macOS)
                darwin = {
                    expr = "(builtins.getFlake \"/Users/kennysheridan/macos-nix-config\").darwinConfigurations.\"sfc-darwin-arm64\".options",
                },
                -- home-manager options
                home_manager = {
                    expr = "(builtins.getFlake \"/Users/kennysheridan/macos-nix-config\").homeConfigurations.\"sfc-darwin-arm64\".options",
                },
            },
        }
    }
)

-- Markdown (marksman) - with proper URI handling
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(ev)
        local bufnr = ev.buf
        
        -- Check if LSP is already attached
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        for _, client in ipairs(clients) do
            if client.name == "marksman" then
                return -- Already attached
            end
        end
        
        -- Check if marksman is available
        if vim.fn.executable("marksman") == 0 then
            return
        end
        
        -- Get the file path and find a proper root
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        if filepath == "" then
            return -- Don't start for unnamed buffers
        end
        
        local root_dir = vim.fn.getcwd()
        
        -- Look for markdown project markers
        local markers = { ".marksman.toml", ".git", "README.md", "readme.md" }
        local dir = vim.fn.fnamemodify(filepath, ':h')
        
        while dir ~= '/' and dir ~= '' do
            for _, marker in ipairs(markers) do
                if vim.fn.filereadable(dir .. '/' .. marker) == 1 or 
                   vim.fn.isdirectory(dir .. '/' .. marker) == 1 then
                    root_dir = dir
                    break
                end
            end
            if root_dir ~= vim.fn.getcwd() then
                break
            end
            dir = vim.fn.fnamemodify(dir, ':h')
        end
        
        -- Start marksman with explicit settings
        vim.lsp.start({
            name = 'marksman',
            cmd = { 'marksman', 'server' },
            root_dir = root_dir,
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {},
            init_options = {
                -- Ensure proper URI handling
                clientInfo = {
                    name = "Neovim",
                    version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
                }
            },
            handlers = {
                -- Override the exit handler to suppress error messages
                ["$/exit"] = function()
                    -- Silent exit
                end,
            },
            on_exit = function(code, signal)
                if code ~= 0 then
                    -- Silent exit, don't show error
                end
            end,
            on_error = function(code, err)
                -- Silent error handling
            end,
        })
    end,
})

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
    { "java", "jdtls", { "jdtls" }, { "pom.xml", "build.gradle", ".git" } },
    { "ruby", "solargraph", { "solargraph", "stdio" }, { "Gemfile", ".git" } },
    { "php", "intelephense", { "intelephense", "--stdio" }, { "composer.json", ".git" } },
    { "vue", "vuels", { "vls" }, { "package.json", ".git" } },
    { "svelte", "svelte", { "svelteserver", "--stdio" }, { "package.json", ".git" } },
    { "kotlin", "kotlin_language_server", { "kotlin-language-server" }, { "build.gradle", ".git" } },
    { "swift", "sourcekit", { "sourcekit-lsp" }, { "Package.swift", ".git" } },
    { { "haskell", "lhaskell" }, "hls", { "haskell-language-server-wrapper", "--lsp" }, { "stack.yaml", "*.cabal", ".git" } },
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
        
        -- Silent attachment check
        vim.defer_fn(function()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })
            if #clients > 0 then
                -- Silently attached
            else
                vim.notify(icons.warn .. " No LSP client for Rust buffer", vim.log.levels.WARN)
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
            
            -- Show subtle success notification
            vim.notify(icons.ok .. " rust-analyzer ready", vim.log.levels.INFO)
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

-- Command to show all navigation options
vim.api.nvim_create_user_command('NavigationHelp', function()
    print("🧭 Navigation Commands Available:")
    print("")
    print("📄 Basic Navigation:")
    print("  {          - Previous paragraph/code block")
    print("  }          - Next paragraph/code block") 
    print("  [[         - Previous section")
    print("  ]]         - Next section")
    print("  []         - Previous end of section")
    print("  ][         - Next end of section")
    print("")
    print("🔍 LSP Navigation:")
    print("  gd         - Goto definition")
    print("  gr         - Find references")
    print("  gi         - Goto implementation")
    print("  K          - Hover documentation")
    print("  [d         - Previous diagnostic")
    print("  ]d         - Next diagnostic")
    print("")
    print("🗂️  Code Outline:")
    print("  <leader>o  - Show document symbols (Telescope)")
    print("  :Outline   - Same as above")
    print("  :AerialEnable - Enable Aerial plugin (optional)")
    print("")
    print("🔄 Troubleshooting:")
    print("  :LspDebug  - Check LSP status")
    print("  :LspRestart - Restart LSP")
end, { desc = "Show all navigation commands" })

-- Enhanced LSP Info command with detailed language information
vim.api.nvim_create_user_command('LspInfo', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local filetype = vim.bo.filetype
    
    -- Create a new buffer for the info
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    
    local lines = {}
    
    -- Header
    table.insert(lines, "╭─────────────────────────────────────────────╮")
    table.insert(lines, "│            " .. icons.magic .. " LSP Information " .. icons.magic .. "           │")
    table.insert(lines, "╰─────────────────────────────────────────────╯")
    table.insert(lines, "")
    
    -- Current file info
    table.insert(lines, icons.arrow .. " Current File")
    table.insert(lines, "  File Type: " .. filetype)
    table.insert(lines, "  Buffer: " .. bufnr)
    table.insert(lines, "")
    
    -- Active LSP clients
    if #clients > 0 then
        table.insert(lines, icons.server .. " Active Language Servers")
        for _, client in ipairs(clients) do
            table.insert(lines, "")
            table.insert(lines, "  " .. icons.dot .. " " .. client.name)
            table.insert(lines, "    ID: " .. client.id)
            table.insert(lines, "    Root: " .. (client.config.root_dir or "N/A"))
            
            -- Capabilities
            local caps = {}
            local sc = client.server_capabilities
            if sc.hoverProvider then table.insert(caps, "hover") end
            if sc.completionProvider then table.insert(caps, "completion") end
            if sc.definitionProvider then table.insert(caps, "definition") end
            if sc.referencesProvider then table.insert(caps, "references") end
            if sc.documentFormattingProvider then table.insert(caps, "formatting") end
            if sc.codeActionProvider then table.insert(caps, "actions") end
            if sc.inlayHintProvider then table.insert(caps, "inlay-hints") end
            
            table.insert(lines, "    Features: " .. table.concat(caps, ", "))
        end
    else
        table.insert(lines, icons.warn .. " No LSP clients attached")
    end
    
    table.insert(lines, "")
    table.insert(lines, "╭─────────────────────────────────────────────╮")
    table.insert(lines, "│              Keybindings                    │")
    table.insert(lines, "╰─────────────────────────────────────────────╯")
    table.insert(lines, "  K          → Hover documentation")
    table.insert(lines, "  gd         → Go to definition")
    table.insert(lines, "  gr         → Find references")
    table.insert(lines, "  gi         → Go to implementation")
    table.insert(lines, "  <leader>ca → Code actions")
    table.insert(lines, "  <leader>rn → Rename symbol")
    table.insert(lines, "  <leader>f  → Format document")
    table.insert(lines, "  [d / ]d    → Navigate diagnostics")
    
    -- Set content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    
    -- Open in floating window
    local width = 50
    local height = #lines
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = 'minimal',
        border = 'rounded',
    })
    
    -- Set window highlights
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder')
    
    -- Close on escape
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
end, { desc = "Show detailed LSP information" })

-- Command to check language server support
vim.api.nvim_create_user_command('LspStatus', function()
    local servers = {
        { "🦀 Rust", "rust-analyzer", "rust", "*.rs" },
        { "🌙 Lua", "lua-language-server", "lua", "*.lua" },
        { "🐍 Python", "pyright-langserver", "python", "*.py" },
        { "🐹 Go", "gopls", "go", "*.go" },
        { "🐚 Bash", "bash-language-server", "sh,bash,zsh", "*.sh,*.bash" },
        { "❄️  Nix", "nixd", "nix", "*.nix" },
        { "📝 Markdown", "marksman", "markdown", "*.md" },
        { "📄 Vim", "vim-language-server", "vim", "*.vim,init.vim" },
        { "🟨 TypeScript/JS", "typescript-language-server", "typescript,javascript", "*.ts,*.js,*.tsx,*.jsx" },
        { "📋 TOML", "taplo", "toml", "*.toml" },
        { "📄 JSON", "vscode-json-language-server", "json", "*.json" },
        { "⚡ C/C++", "clangd", "c,cpp", "*.c,*.cpp,*.h,*.hpp" },
        { "🌐 HTML", "vscode-html-language-server", "html", "*.html" },
        { "🎨 CSS", "vscode-css-language-server", "css", "*.css" },
        { "📊 YAML", "yaml-language-server", "yaml", "*.yml,*.yaml" },
    }
    
    -- Create a buffer for the status display
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    
    local lines = {}
    table.insert(lines, "╭───────────────────────────────────────────────────────╮")
    table.insert(lines, "│             " .. icons.rocket .. " Language Server Status " .. icons.rocket .. "            │")
    table.insert(lines, "╰───────────────────────────────────────────────────────╯")
    table.insert(lines, "")
    
    for _, server in ipairs(servers) do
        local icon, cmd, lang, files = server[1], server[2], server[3], server[4]
        local status = vim.fn.executable(cmd) == 1 and icons.ok or "✗"
        local status_text = vim.fn.executable(cmd) == 1 and "Ready" or "Missing"
        table.insert(lines, string.format("%s %s %-20s %s", status, icon, lang, status_text))
        table.insert(lines, string.format("     Files: %s", files))
        table.insert(lines, "")
    end
    
    table.insert(lines, "╭───────────────────────────────────────────────────────╮")
    table.insert(lines, "│                    Commands                          │")
    table.insert(lines, "╰───────────────────────────────────────────────────────╯")
    table.insert(lines, "  " .. icons.package .. " Install: :MasonInstall <server-name>")
    table.insert(lines, "  " .. icons.info .. " Info: :LspInfo")
    table.insert(lines, "  " .. icons.gear .. " Debug: :LspDebug")
    
    -- Set content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    
    -- Open in floating window
    local width = 60
    local height = #lines
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = math.min(height, 30),
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = 'minimal',
        border = 'rounded',
    })
    
    -- Set window highlights
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder')
    
    -- Close on escape
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
end, { desc = "Show language server support status" })

-- DISABLED: -- 7. Completion setup with nvim-cmp (Fixed version)
-- DISABLED: local cmp_ok, cmp = pcall(require, 'cmp')
-- DISABLED: local lspkind_ok, lspkind = pcall(require, 'lspkind')
-- DISABLED: 
-- DISABLED: if not cmp_ok then
-- DISABLED:     vim.notify("nvim-cmp not available", vim.log.levels.WARN)
-- DISABLED:     return
-- DISABLED: end
-- DISABLED: 
-- DISABLED: if not lspkind_ok then
-- DISABLED:     vim.notify("lspkind not available", vim.log.levels.WARN)
-- DISABLED:     -- Continue without lspkind
-- DISABLED: end
-- DISABLED: 
-- DISABLED: -- Simple, compatible cmp setup
-- DISABLED: cmp.setup({
-- DISABLED:     completion = {
-- DISABLED:         completeopt = 'menu,menuone,noselect',
-- DISABLED:     },
-- DISABLED:     mapping = {
-- DISABLED:         ['<C-p>'] = cmp.mapping.select_prev_item(),
-- DISABLED:         ['<C-n>'] = cmp.mapping.select_next_item(),
-- DISABLED:         ['<C-y>'] = cmp.mapping.confirm({ select = true }),
-- DISABLED:         ['<C-Space>'] = cmp.mapping.complete(),
-- DISABLED:         ['<C-u>'] = cmp.mapping.scroll_docs(-4),
-- DISABLED:         ['<C-d>'] = cmp.mapping.scroll_docs(4),
-- DISABLED:         ['<Esc>'] = cmp.mapping.abort(),
-- DISABLED:     },
-- DISABLED:     sources = {
-- DISABLED:         -- { name = 'nvim_lsp' }, -- DISABLED DUE TO BUFFER ERROR
-- DISABLED:         { name = 'buffer' },
-- DISABLED:         { name = 'path' },
-- DISABLED:     },
-- DISABLED:     formatting = lspkind_ok and {
-- DISABLED:         format = lspkind.cmp_format({
-- DISABLED:             mode = 'symbol_text',
-- DISABLED:             maxwidth = 50,
-- DISABLED:         })
-- DISABLED:     } or {},
-- DISABLED: })


-- Native LSP completion setup (no external plugins)
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Enable native completion triggered by LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    
    print('✅ Native LSP completion enabled for buffer ' .. ev.buf)
  end,
})

-- Silent startup - configuration loaded
