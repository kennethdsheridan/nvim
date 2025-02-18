-- lazy.lua (example)
return {

    -- ─────────────────────────────────────────────────────────────────────────────
    -- SNIPPETS
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        -- (Optionally) config = function() ... end
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- RUSTACEANVIM
    -- ─────────────────────────────────────────────────────────────────────────────
    {
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
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- DAP & DAP UI
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio", -- If you actually need nvim-nio
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
                    type = "rt_lldb", -- using 'rt_lldb' as in your config
                    request = "launch",
                    program = function()
                        local metadata_json = vim.fn.system("cargo metadata --format-version 1 --no-deps")
                        local metadata = vim.fn.json_decode(metadata_json)
                        local target_name = metadata.packages[1].targets[1].name
                        local cargo_path = "target/debug/" .. target_name

                        if vim.fn.executable(cargo_path) == 1 then
                            return cargo_path
                        end
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
                    type = "rt_lldb",
                    request = "launch",
                    program = function()
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
    },

    -- LSP signature help source for nvim-cmp
    { "hrsh7th/cmp-nvim-lsp-signature-help" },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- LSP CONFIG / MASON / LSP-ZERO
    -- ─────────────────────────────────────────────────────────────────────────────
    { "neovim/nvim-lspconfig" },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright" },
                automatic_installation = true,
            })
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local lsp = require("lsp-zero").preset("recommended")

            lsp.on_attach(function(client, bufnr)
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

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
        end,
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- AUTOCOMPLETION (CMP) + TABNINE
    -- ─────────────────────────────────────────────────────────────────────────────
    { "hrsh7th/cmp-buffer" },
    {
        "codota/tabnine-nvim",
        build = "./dl_binaries.sh",
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },

    -- Icons / UI improvements for completion
    { "onsails/lspkind-nvim" },

    -- LSP UI enhancements (lspsaga)
    { "glepnir/lspsaga.nvim" },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- FILE EXPLORER (NEO-TREE)
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
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
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- GIT / DIFF / TROUBLE
    -- ─────────────────────────────────────────────────────────────────────────────
    { "sindrets/diffview.nvim" },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup({})
        end,
    },
    { "tpope/vim-fugitive" },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- TELESCOPE
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- NOTIFICATIONS (NOICE + NOTIFY)
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        enabled = true,
        opts = {
            -- Add any Noice-specific options here if you like
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            -- If you want the notification view, also include:
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    -- Override markdown rendering so that cmp and other plugins use treesitter
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- disable inc-rename.nvim integration
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
            })
        end,
    },
    -- ─────────────────────────────────────────────────────────────────────────────
    -- COLORS & THEMES
    -- ─────────────────────────────────────────────────────────────────────────────
    { "EdenEast/nightfox.nvim" },
    { "ellisonleao/gruvbox.nvim" },
    { "sainnhe/gruvbox-material" },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- TREESITTER
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    { "nvim-treesitter/playground" },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- MISC UTILITIES
    -- ─────────────────────────────────────────────────────────────────────────────
    { "theprimeagen/harpoon" },
    { "mbbill/undotree" },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- CLOAK
    -- ─────────────────────────────────────────────────────────────────────────────
    { "laytan/cloak.nvim" },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- RUST TOOLS & CRATES
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "simrat39/rust-tools.nvim",
        config = function()
            local rt = require("rust-tools")
            rt.setup({
                server = {
                    on_attach = function(_, bufnr)
                        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                        vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                    end,
                },
            })
        end,
    },
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = function()
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
        end,
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- ADDITIONAL LSP / FORMAT / LINT
    -- ─────────────────────────────────────────────────────────────────────────────
    { "kosayoda/nvim-lightbulb" },
    { "mfussenegger/nvim-lint" },
    { "mhartington/formatter.nvim" },

    -- Lightbulb on CursorHold
    {
        -- Using a separate spec only to attach the autocmd; could be merged elsewhere
        "kosayoda/nvim-lightbulb",
        config = function()
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

            vim.cmd([[
        autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
      ]])
        end,
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- BASH-SPECIFIC
    -- ─────────────────────────────────────────────────────────────────────────────
    { "vim-scripts/bats.vim" },
    { "chrisbra/vim-sh-indent" },
    { "arzg/vim-sh" },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- MARKDOWN
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            -- Lazy.nvim allows a Lua build function:
            vim.fn["mkdp#util#install"]()
        end,
    },
    { "preservim/vim-markdown" },
    { "dhruvasagar/vim-table-mode" },
    { "junegunn/limelight.vim" },
    { "junegunn/goyo.vim" },

}
