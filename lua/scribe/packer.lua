-- packer.lua
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    -- **Plugin Declarations**

    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- Snippet engine and snippets
    use("L3MON4D3/LuaSnip")
    use("rafamadriz/friendly-snippets")

    use({
        "mrcjkb/rustaceanvim",
        version = "^5",
        ft = { "rust" },
        config = function()
            local mason_registry = require("mason-registry")
            local codelldb = mason_registry.get_package("codelldb")
            local extension_path = codelldb:get_install_path() .. "/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
            local cfg = require("rustaceanvim.config")

            vim.g.rustaceanvim = {
                dap = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
                server = {
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                            },
                        },
                    },
                },
            }
        end,
    })
  -- DAP and DAP UI setup
    use({
        "mfussenegger/nvim-dap",
        requires = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Configure DAP UI
            dapui.setup({
                layouts = {
                    {
                        elements = {
                            "scopes",
                            "breakpoints",
                            "stacks",
                            "watches",
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            "repl",
                            "console",
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
            })

            -- Add Rust configurations
            dap.configurations.rust = {
                {
                    name = "Debug Rust",
                    type = "rt_lldb", -- Changed from codelldb to rt_lldb
                    request = "launch",
                    program = function()
                        -- First try to find the target/debug executable with the same name as the package
                        local metadata_json = vim.fn.system("cargo metadata --format-version 1 --no-deps")
                        local metadata = vim.fn.json_decode(metadata_json)
                        local target_name = metadata.packages[1].targets[1].name
                        local cargo_path = "target/debug/" .. target_name

                        if vim.fn.executable(cargo_path) == 1 then
                            return cargo_path
                        end

                        -- If the above fails, ask the user
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = function()
                        local args_string = vim.fn.input("Arguments: ")
                        return vim.fn.split(args_string, " ", true)
                    end,
                },
                {
                    name = "Debug Rust Tests",
                    type = "rt_lldb", -- Changed from codelldb to rt_lldb
                    request = "launch",
                    program = function()
                        -- Get the test executable path
                        local metadata_json = vim.fn.system("cargo metadata --format-version 1 --no-deps")
                        local metadata = vim.fn.json_decode(metadata_json)
                        local target_name = metadata.packages[1].targets[1].name
                        return vim.fn.input(
                            "Path to test executable: ",
                            vim.fn.getcwd() .. "/target/debug/" .. target_name .. "-",
                            "file"
                        )
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = function()
                        local args_string = vim.fn.input("Arguments: ")
                        return vim.fn.split(args_string, " ", true)
                    end,
                },
            }

            -- Packer
            use({
                "jackMort/ChatGPT.nvim",
                config = function()
                    require("chatgpt").setup()
                end,
                requires = {
                    "MunifTanjim/nui.nvim",
                    "nvim-lua/plenary.nvim",
                    "folke/trouble.nvim",
                    "nvim-telescope/telescope.nvim"
                }
            })


            -- Set up DAP UI listeners
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    })

    -- LSP signature
    use("hrsh7th/cmp-nvim-lsp-signature-help")

    -- LSP configurations and tools
    use("neovim/nvim-lspconfig")   -- LSP configurations
    use("williamboman/mason.nvim") -- LSP installer
    use("williamboman/mason-lspconfig.nvim")
    use({
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        requires = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "neovim/nvim-lspconfig" },
            { "L3MON4D3/LuaSnip" },
        },
    })

    -- Add RustaceanVim Plugin (optional)
    -- use("rust-lang/rust.vim")

    -- Autocompletion
    use("hrsh7th/cmp-buffer") -- Source for buffer words

    -- Standalone TabNine plugin
    use({ "codota/tabnine-nvim", run = "./dl_binaries.sh" })

    -- Neo-tree plugin
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        hide_by_name = {
                            ".DS_Store",
                            "thumbs.db",
                        },
                        never_show = {
                            ".DS_Store",
                            "thumbs.db",
                        },
                    },
                },
            })
        end,
    })

    -- Icons and symbols for completion items
    use("onsails/lspkind-nvim")
    -- Provides icons for `nvim-cmp`
    use("hrsh7th/nvim-cmp")     -- Completion engine
    use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp

    -- LSP UI enhancements
    use("glepnir/lspsaga.nvim")

    -- Git DiffView
    use("sindrets/diffview.nvim")

    -- Trouble Plugin
    use({
        "folke/trouble.nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup({})
        end,
    })

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        requires = { "nvim-lua/plenary.nvim" },
    })

    -- Noice
    use({
        "folke/noice.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup()
        end,
    })

    -- EdenEast NightFox color scheme
    use("EdenEast/nightfox.nvim")

    -- Install Gruvbox
    use("ellisonleao/gruvbox.nvim")

    -- Install Gruvbox Material
    use("sainnhe/gruvbox-material")


    -- Treesitter
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    -- Treesitter Playground
    use("nvim-treesitter/playground")

    -- Harpoon
    use("theprimeagen/harpoon")

    -- Undotree
    use("mbbill/undotree")

    -- VIM Fugitive
    use("tpope/vim-fugitive")

    -- Notify Plugin Configuration
    use({
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })
        end,
    })

    -- Cloak
    use("laytan/cloak.nvim")

    -- Rust-specific plugins
    use("simrat39/rust-tools.nvim")
    use("saecki/crates.nvim")

    -- Additional LSP enhancements
    use("kosayoda/nvim-lightbulb")
    use("mfussenegger/nvim-lint")
    use("mhartington/formatter.nvim")

    -- Bash-specific plugins
    use("vim-scripts/bats.vim")
    use("chrisbra/vim-sh-indent")
    use("arzg/vim-sh")

    -- Markdown-specific plugins
    use({
        "iamcco/markdown-preview.nvim",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
    })
    use("preservim/vim-markdown")
    use("dhruvasagar/vim-table-mode")
    use("junegunn/limelight.vim")
    use("junegunn/goyo.vim")

    -- **Plugin Configurations**

    -- Setup mason (LSP Installer)
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "pyright" },
        automatic_installation = true,
    })

    -- LSP-zero setup
    local lsp = require("lsp-zero").preset("recommended")

    lsp.on_attach(function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Key mappings for LSP functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    end)

    lsp.setup()

    -- Rust-specific setup
    local rt = require("rust-tools")
    rt.setup({
        server = {
            on_attach = function(_, bufnr)
                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            end,
        },
    })

    -- Setup crates.nvim
    require("crates").setup({
        smart_insert = true,
        autoload = true,
        autoupdate = true,
        loading_indicator = true,
        date_format = "%Y-%m-%d",
        popup = {
            autofocus = false,
            style = "minimal",
            border = "rounded",
            show_version_date = true,
            max_height = 30,
            min_width = 20,
            text = {
                title = " %s",
                version = "   %s",
                date = "   %s",
                features = " • Features",
                dependencies = " • Dependencies",
            },
        },
        completion = {
            insert_closing_quote = true,
        },
        null_ls = {
            enabled = false,
            name = "crates.nvim",
        },
    })

    -- CMP Configuation for LSP suggestions
    local cmp = require("cmp")
    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = {
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif require("luasnip").expand_or_jumpable() then
                    require("luasnip").expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif require("luasnip").jumpable(-1) then
                    require("luasnip").jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
        }, {
            { name = "buffer" },
        }),
    })

    -- Setup nvim-lightbulb
    require("nvim-lightbulb").setup({
        sign = {
            enabled = false,
        },
        virtual_text = {
            enabled = true,
            text = "💡",
            virt_text_pos = "eol",
        },
    })

    -- Update lightbulb on CursorHold and CursorHoldI
    vim.cmd([[
    autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
  ]])

    -- Ensure packer compiles when changes are made to your plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
