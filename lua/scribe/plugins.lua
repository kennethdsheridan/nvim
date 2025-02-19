--plugins.lua
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
    -- Project management
    -- ─────────────────────────────────────────────────────────────────────────────

    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                -- Use pattern-based detection for project roots
                detection_methods = { "pattern" },
                -- List of files or directories that signal a project root
                patterns = {
                    ".git",          -- Git repo (common fallback)
                    "Cargo.toml",    -- Rust
                    "go.mod",        -- Go
                    "package.json",  -- Node.js / TypeScript
                    "tsconfig.json", -- TypeScript
                    "init.lua",      -- Lua projects (e.g., Neovim configs)
                    ".bashrc",       -- Bash (or any other marker you may want)
                },
                -- Optionally, you can disable changing the directory silently:
                silent_chdir = false,
            }
            -- Optionally load the Telescope extension (if you're using telescope.nvim)
            pcall(function()
                require("telescope").load_extension("projects")
            end)
        end,
    },


    -- ─────────────────────────────────────────────────────────────────────────────
    -- Markdown
    -- ─────────────────────────────────────────────────────────────────────────────
    -- install with yarn or npm
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- LuaLine
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Apha NVIM
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
            -- if you need icons or other dependencies
            -- "nvim-tree/nvim-web-devicons",
        },
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- TODO Comments
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
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
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- disable inc-rename.nvim integration
                    lsp_doc_border = true,        -- add a border to hover docs and signature help
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
        -- Automatically close and rename HTML/JSX/TSX tags
        "windwp/nvim-ts-autotag",
        opts = {},
    },

    {
        -- Easily delete buffers without closing your window layout
        "famiu/bufdelete.nvim",
        event = "VeryLazy",
        config = function()
            vim.keymap.set("n", "Q", ":lua require('bufdelete').bufdelete(0, false)<cr>", {
                noremap = true,
                silent = true,
                desc = "Delete buffer",
            })
        end,
    },

    {
        -- Commenting plugin that works with treesitter for better context detection
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },
    {
        -- Context-aware commenting (useful for files with embedded languages)
        "joosepalviste/nvim-ts-context-commentstring",
        lazy = true,
    },

    {
        -- Improves the default vim.ui interfaces, such as input and select menus
        "stevearc/dressing.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
        config = function()
            require("dressing").setup()
        end,
    },

    -- Uncomment and enable if you want an LSP progress notification plugin
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
        -- Smooth scrolling animations
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
        -- Find and replace across files, with a user-friendly interface
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
        -- Easily add/change/delete surrounding brackets, quotes, etc.
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end,
    },

    {
        -- Automatically detect indentation settings
        "tpope/vim-sleuth",
    },

    {
        -- Helper plugin for Neovim plugin development; includes completions for Lua
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Example config for pulling in external library definitions
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "Bilal2453/luvit-meta",
        lazy = true,
    },
    {
        -- Example: adding a custom completion source for 'lazydev'
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },

    {
        -- Visually display indent levels with thin vertical lines
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
        -- Supports EditorConfig files to maintain consistent coding styles
        "editorconfig/editorconfig-vim",
    },

    {
        -- Enhanced f/t motions that work well with Leap
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
        -- Motion plugin that replaces the need to use a mouse for quick jumps
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
            vim.keymap.del({ "x", "o" }, "x")
            vim.keymap.del({ "x", "o" }, "X")
        end,
    },

    {
        -- Display file path/breadcrumbs in a winbar
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
        -- Simple session management (auto-save and restore sessions)
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
    },

    {
        -- Generate docstrings or annotations for functions, classes, etc.
        "danymat/neogen",
        enabled = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local neogen = require("neogen")

            neogen.setup({
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
        -- Collection of minimal yet feature-rich plugins (mini.*)
        "echasnovski/mini.nvim",
        config = function()
            -- AI: better around/inside text objects
            require("mini.ai").setup({ n_lines = 500 })
            -- Surround: add/change/delete surrounding brackets, quotes, etc.
            require("mini.surround").setup()
            -- Pairs: auto insert matching brackets/quotes
            require("mini.pairs").setup()
            -- Statusline: a minimal but useful statusline
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
        -- Minimal Icons for use by mini.* or other plugins if devicons is not present
        "echasnovski/mini.icons",
        enabled = true,
        lazy = true,
        opts = {},
    },

    {
        -- Syntax highlighting for kitty terminal config files
        "fladson/vim-kitty",
        -- Additional UI library
        "MunifTanjim/nui.nvim",
    },

    {
        -- Customizable notifications with optional animations
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })
        end,
    },

    {
        -- Displays a popup of recent key presses (helpful for demos or screen sharing)
        "nvchad/showkeys",
        cmd = "ShowkeysToggle",
        opts = {
            timeout = 1,
            maxkeys = 6,
            position = "bottom-right", -- can be: 'bottom-left', 'bottom-center', etc.
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
    { "laytan/cloak.nvim" },

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

                    -- Add this block to enable Runnables
                    runnables = {
                        use_telescope = true, -- if you use telescope, it’ll show runnables in a picker
                    },
                },
                server = {
                    on_attach = function(_, bufnr)
                        -- Existing keymaps
                        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                        vim.keymap.set("n", "<Leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })

                        -- Keymap to invoke Runnables
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
                                autoimport = {
                                    enable = true,
                                },
                            },
                            -- (Optional) Enable CodeLens (see below)
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
