-- plugins.lua
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
    -- Git Signs, Fugitive, and Diffview Integration
    -- ─────────────────────────────────────────────────────────────────────────────
    -- Gitsigns
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "┃" },
                    change       = { text = "┃" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked    = { text = "┆" },
                },
                current_line_blame = true,
                -- If you see a warning about `current_line_blame_formatter_opts`, remove it or update gitsigns.
                -- current_line_blame_formatter_opts = {
                --   relative_time = true,
                -- },
            })
            vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", {})
            vim.keymap.set("n", "<leader>gt", "<cmd>Gitsigns toggle_current_line_blame<CR>", {})
        end,
    },
    -- Vim-fugitive
    {
        "tpope/vim-fugitive",
        -- cmd = { "Git", "Gdiffsplit", ... } -- optionally lazy‐load
    },
    -- Diffview
    {
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup({
                -- See :help diffview-config for possible settings
            })
        end,
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
    -- Project management
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                detection_methods = { "pattern" },
                patterns = {
                    ".git",
                    "Cargo.toml",
                    "go.mod",
                    "package.json",
                    "tsconfig.json",
                    "init.lua",
                    ".bashrc",
                },
                silent_chdir = false,
            }
            pcall(function()
                require("telescope").load_extension("projects")
            end)
        end,
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- (Removed the duplicated 'iamcco/markdown-preview.nvim' block here)
    -- ─────────────────────────────────────────────────────────────────────────────

    -- ─────────────────────────────────────────────────────────────────────────────
    -- LuaLine
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Alpha NVIM
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        lazy = true,
        enabled = true,
        opts = function()
            return require("scribe.alfa-nvim").opts() -- calls M.opts()
        end,
        config = function(_, dashboard)
            require("scribe.alfa-nvim").config(_, dashboard) -- calls M.config()
        end,
        dependencies = {
            -- e.g., "nvim-tree/nvim-web-devicons",
        },
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- TODO Comments
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- DAP & DAP UI
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio", -- required by nvim-dap-ui
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            local mason_registry = require("mason-registry")

            ------------------------------------------------------------------------
            -- 1. Retrieve CodeLLDB paths from Mason
            ------------------------------------------------------------------------
            local codelldb = mason_registry.get_package("codelldb")
            local extension_path = codelldb:get_install_path() .. "/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.so" -- Linux
            -- local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib" -- macOS
            -- local liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll" -- Windows

            ------------------------------------------------------------------------
            -- 2. Define the DAP adapter
            ------------------------------------------------------------------------
            dap.adapters.rt_lldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb_path,
                    args = { "--port", "${port}" },
                },
            }

            ------------------------------------------------------------------------
            -- 3. DAP UI setup
            ------------------------------------------------------------------------
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

            ------------------------------------------------------------------------
            -- 4. Rust DAP configurations
            ------------------------------------------------------------------------
            dap.configurations.rust = {
                {
                    name = "Debug Rust",
                    type = "rt_lldb",
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

            ------------------------------------------------------------------------
            -- 5. Auto-open/close DAP UI on debug sessions
            ------------------------------------------------------------------------
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

    -- ─────────────────────────────────────────────────────────────────────────────
    -- LSP Zero
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local lsp = require("lsp-zero").preset("recommended")

            -- If you want custom config for servers:
            lsp.configure("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true },
                        checkOnSave = { command = "clippy" },
                    },
                },
            })

            lsp.on_attach(function(client, bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
                -- etc...
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
    -- FILE EXPLORER (Nvim-Tree)
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                filters = {
                    dotfiles = false,
                    custom = { ".DS_Store", "thumbs.db" },
                },
                git = {
                    enable = true,
                    ignore = false,
                },
                renderer = {
                    highlight_opened_files = "all",
                },
                view = {
                    width = 30,
                },
            })

            -- Auto-open on startup
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    require("nvim-tree.api").tree.open()
                end,
            })

            -- Toggle with <leader>ft
            vim.keymap.set("n", "<leader>ft", "<cmd>NvimTreeToggle<CR>", {
                silent = true,
                noremap = true,
                desc = "Toggle NvimTree",
            })
        end,
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- GIT / DIFF / TROUBLE
    -- ─────────────────────────────────────────────────────────────────────────────
    -- (Removed duplicates for diffview & fugitive here)
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup({})
        end,
    },

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
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                presets = {
                    bottom_search = true,
                    command_palette = true,
                    long_message_to_split = true,
                    inc_rename = false,
                    lsp_doc_border = true,
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
    {
        "windwp/nvim-ts-autotag",
        opts = {},
    },
    {
        "famiu/bufdelete.nvim",
        event = "VeryLazy",
        config = function()
            vim.keymap.set("n", "Q", ":lua require('bufdelete').bufdelete(0, false)<CR>", {
                noremap = true,
                silent = true,
                desc = "Delete buffer",
            })
        end,
    },
    {
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },
    {
        "joosepalviste/nvim-ts-context-commentstring",
        lazy = true,
    },
    {
        "stevearc/dressing.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
        config = function()
            require("dressing").setup()
        end,
    },
    {
        "j-hui/fidget.nvim",
        branch = "legacy",
        enabled = false,
        config = function()
            require("fidget").setup({
                window = { blend = 0 },
            })
        end,
    },
    {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup({
                stop_eof = true,
                easing_function = "sine",
                hide_cursor = true,
                cursor_scrolls_alone = true,
            })
        end,
    },
    {
        "windwp/nvim-spectre",
        enabled = false,
        event = "BufRead",
        keys = {
            {
                "<leader>Rr",
                function()
                    require("spectre").open()
                end,
                desc = "Replace",
            },
            {
                "<leader>Rw",
                function()
                    require("spectre").open_visual({ select_word = true })
                end,
                desc = "Replace Word",
            },
            {
                "<leader>Rf",
                function()
                    require("spectre").open_file_search()
                end,
                desc = "Replace Buffer",
            },
        },
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end,
    },
    {
        "tpope/vim-sleuth",
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Example: { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "Bilal2453/luvit-meta",
        lazy = true,
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0,
            })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = false,
        event = { "BufReadPost", "BufNewFile" },
        version = "2.1.0",
        opts = {
            char = "┊",
            filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
            show_trailing_blankline_indent = false,
            show_current_context = false,
        },
    },
    {
        "editorconfig/editorconfig-vim",
    },
    {
        "ggandor/flit.nvim",
        keys = function()
            local ret = {}
            for _, key in ipairs({ "f", "F", "t", "T" }) do
                ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
            end
            return ret
        end,
        opts = { labeled_modes = "nx" },
    },
    {
        "ggandor/leap.nvim",
        keys = {
            { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
            { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
            { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
        },
        config = function(_, opts)
            local leap = require("leap")
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
            leap.add_default_mappings(true)
            -- Optional: remove 'x' and 'X' if you prefer
            vim.keymap.del({ "x", "o" }, "x")
            vim.keymap.del({ "x", "o" }, "X")
        end,
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional icons
        },
        opts = {},
        config = function()
            require("barbecue").setup({
                create_autocmd = false, -- manually control updates
            })
            vim.api.nvim_create_autocmd({
                "WinScrolled",
                "BufWinEnter",
                "CursorHold",
                "InsertLeave",
                -- "BufModifiedSet",
            }, {
                group = vim.api.nvim_create_augroup("barbecue.updater", {}),
                callback = function()
                    require("barbecue.ui").update()
                end,
            })
        end,
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
    },
    {
        "danymat/neogen",
        enabled = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            require("neogen").setup({
                snippet_engine = "luasnip",
            })
        end,
        keys = {
            {
                "<leader>ng",
                function()
                    require("neogen").generate()
                end,
                desc = "Generate code annotations",
            },
            {
                "<leader>nf",
                function()
                    require("neogen").generate({ type = "func" })
                end,
                desc = "Generate Function Annotation",
            },
            {
                "<leader>nt",
                function()
                    require("neogen").generate({ type = "type" })
                end,
                desc = "Generate Type Annotation",
            },
        },
    },
    {
        "echasnovski/mini.nvim",
        config = function()
            require("mini.ai").setup({ n_lines = 500 })
            require("mini.surround").setup()
            require("mini.pairs").setup()

            local statusline = require("mini.statusline")
            statusline.setup({
                use_icons = vim.g.have_nerd_font,
            })
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return "%2l:%-2v"
            end
        end,
    },
    {
        "echasnovski/mini.icons",
        enabled = true,
        lazy = true,
        opts = {},
    },
    {
        "fladson/vim-kitty",
        -- Additional UI library
        "MunifTanjim/nui.nvim",
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })
        end,
    },
    {
        "nvchad/showkeys",
        cmd = "ShowkeysToggle",
        opts = {
            timeout = 1,
            maxkeys = 6,
            position = "bottom-right",
        },
        keys = {
            {
                "<leader>kt",
                function()
                    vim.cmd("ShowkeysToggle")
                end,
                desc = "Show key presses",
            },
        },
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- CLOAK
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "laytan/cloak.nvim",
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- RUST TOOLS & CRATES
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "simrat39/rust-tools.nvim",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local rt = require("rust-tools")

            rt.setup({
                tools = {
                    hover_actions = {
                        auto_focus = true,
                        border = "rounded",
                    },
                    inlay_hints = {
                        auto = true,
                        show_parameter_hints = true,
                        parameter_hints_prefix = "<- ",
                        other_hints_prefix = "-> ",
                    },
                    runnables = {
                        use_telescope = true,
                    },
                },
                server = {
                    on_attach = function(_, bufnr)
                        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                        vim.keymap.set("n", "<Leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
                        vim.keymap.set("n", "<Leader>rr", rt.runnables.runnables, { buffer = bufnr })
                    end,
                    capabilities = capabilities,
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                            },
                            checkOnSave = {
                                command = "clippy",
                            },
                            completion = {
                                autoimport = { enable = true },
                            },
                            lens = {
                                enable = true,
                            },
                        },
                    },
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
        "kosayoda/nvim-lightbulb",
        config = function()
            require("nvim-lightbulb").setup({
                sign = { enabled = false },
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
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        build = function()
            -- This is the Lua-friendly approach recommended by the plugin
            vim.fn["mkdp#util#install"]()
        end,
    },
    { "preservim/vim-markdown" },
    { "dhruvasagar/vim-table-mode" },
    { "junegunn/limelight.vim" },
    { "junegunn/goyo.vim" },

}

