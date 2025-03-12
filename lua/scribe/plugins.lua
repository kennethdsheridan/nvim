return {

    -- ─────────────────────────────────────────────────────────────────────────────
    -- SNIPPETS
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- HA Proxy
    -- ─────────────────────────────────────────────────────────────────────────────
    { 'Joorem/vim-haproxy' },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Git Signs, Fugitive, and Diffview Integration
    -- ─────────────────────────────────────────────────────────────────────────────
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
            })
            vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", {})
            vim.keymap.set("n", "<leader>gt", "<cmd>Gitsigns toggle_current_line_blame<CR>", {})
            vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", {
                desc = "Show Git blame for current line",
            })
        end,
    },
    {
        "tpope/vim-fugitive",
    },
    {
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup({})
        end,
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Monorepo
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "imNel/monorepo.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        -- No cmd = { ... }, so it loads right away (or you can do event = "VeryLazy" if you like)
        config = function()
            require("monorepo").setup({
                silent = false,
                autoload_telescope = true,
                data_path = vim.fn.stdpath("data") .. "/monorepo.json",
            })
        end,
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Rust Owl
    -- ─────────────────────────────────────────────────────────────────────────────
    { "cordx56/rustowl",   dependencies = { "neovim/nvim-lspconfig" } },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Documentation
    -- ─────────────────────────────────────────────────────────────────────────────
    require("scribe.documentation"),

    -- ─────────────────────────────────────────────────────────────────────────────
    -- NeoGit
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            -- Only one of these is needed.
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua",              -- optional
            "echasnovski/mini.pick",         -- optional
        },
        config = true
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- RUSTACEANVIM (Commented Out)
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        ft = { "rust" },
        config = function()
            -- ...
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
            return require("scribe.alfa-nvim").opts()
        end,
        config = function(_, dashboard)
            require("scribe.alfa-nvim").config(_, dashboard)
        end,
        dependencies = {},
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

            local codelldb = mason_registry.get_package("codelldb")
            local extension_path = codelldb:get_install_path() .. "/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            -- Linux
            -- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
            -- macOS:
            local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
            -- Windows:
            -- local liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"

            dap.adapters.rt_lldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb_path,
                    args = { "--port", "${port}" },
                },
            }

            -- Add required fields: 'current_frame' in icons, and 'indent' in render
            dapui.setup({
                icons = {
                    expanded = "▾",
                    collapsed = "▸",
                    current_frame = "▶", -- <-- Required
                },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                element_mappings = {},
                expand_lines = true,
                force_buffers = false,
                floating = {
                    max_height = 0.9,
                    max_width = 0.5,
                    border = "single",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                controls = {
                    enabled = true,
                    element = "repl",
                    icons = {
                        pause = "",
                        play = "",
                        step_into = "",
                        step_over = "",
                        step_out = "",
                        step_back = "",
                        run_last = "",
                        terminate = "",
                    },
                },
                render = {
                    max_type_length = nil,
                    indent = 1, -- <-- Required
                },
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

            -- Rust-specific debug configurations
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

            -- Automatically open/close DAP UI
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

    { "hrsh7th/cmp-nvim-lsp-signature-help" },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Themes
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.everforest_background = "hard" -- Options: soft, medium, hard
            vim.cmd("colorscheme everforest")
            -- light Theme
        end
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme tokyonight-moon") -- Options: tokyonight-night, tokyonight-storm, tokyonight-moon, tokyonight-day
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "latte", -- Options: latte, frappe, macchiato, mocha
            })
            vim.cmd("colorscheme catppuccin")
        end
    },
    {
        "shaunsingh/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme nord")
        end
    },

    {
        "savq/melange",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme melange")
        end
    },






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
            -- No rust_analyzer here
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

            -- If you decide to add Rust-specific configuration later,
            -- you can re-introduce lsp.configure("rust_analyzer", { ... })

            lsp.on_attach(function(_, bufnr) -- Replace `client` with `_` since we don't use it
                local opts = { noremap = true, silent = true, buffer = bufnr }

                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
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
    { "onsails/lspkind-nvim" },
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
                git = { enable = true, ignore = false },
                renderer = { highlight_opened_files = "all" },
                view = { width = 30 },
            })

            --vim.api.nvim_create_autocmd("VimEnter", {
            --    callback = function()
            --        require("nvim-tree.api").tree.open()
            --    end,
            --})

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
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup({
                -- Basic appearance/position
                position = "bottom",
                height = 10,
                width = 50,                     -- if position = "left" or "right"
                icons = true,
                mode = "workspace_diagnostics", -- or "document_diagnostics", "quickfix", etc.
                fold_open = "",
                fold_closed = "",
                group = true,
                padding = true,

                -- Previously “action_keys”; now must be under `keys`
                keys = {
                    close = "q",
                    cancel = "<esc>",
                    refresh = "r",
                    jump = { "<cr>", "<tab>" },
                    open_split = { "<c-x>" },
                    open_vsplit = { "<c-v>" },
                    open_tab = { "<c-t>" },
                    jump_close = { "o" },
                    toggle_mode = "m",
                    toggle_preview = "P",
                    hover = "K",
                    preview = "p",
                    close_folds = { "zM", "zm" },
                    open_folds = { "zR", "zr" },
                    toggle_fold = { "zA", "za" },
                    previous = "k",
                    next = "j",
                },

                -- Required to avoid type-check warnings
                debug = false,
                auto_open = false,
                auto_close = false,
                auto_preview = true,
                auto_refresh = true,
                auto_jump = { "lsp_definitions" },
                focus = false,
                restore = false,
                follow = false,
                indent_guides = true,
                max_items = nil,
                multiline = true,
                pinned = true,
                warn_no_results = true,
                open_folds = false,

                -- Newly required fields:
                open_no_results = false, -- Don’t auto-open Trouble if no results
                preview = true,          -- Enable preview of diagnostics
                throttle = 50,           -- Debounce in ms for updates
                modes = {
                    -- Minimal sub-tables for each mode you might use
                    workspace_diagnostics = {},
                    document_diagnostics = {},
                    quickfix = {},
                    lsp_references = {},
                    loclist = {},
                },
                win = {
                    -- You can define window options (like transparency) here
                    -- e.g. blend = 0, winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
                },

                signs = {
                    error = "",
                    warning = "",
                    hint = "",
                    information = "",
                    other = "",
                },
                use_diagnostic_signs = false,
            })
        end,
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- TELESCOPE
    -- ─────────────────────────────────────────────────────────────────────────────
    {
        "nvim-telescope/telescope.nvim",
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
                -- Required fields
                cmdline = {
                    enabled = true,
                },
                messages = {
                    enabled = true,
                },
                popupmenu = {
                    enabled = true,
                },
                redirect = {
                    enabled = false,
                },
                commands = {
                    enabled = true,
                },
                notify = {
                    enabled = true,
                    view = "notify",
                },
                markdown = {
                    hover = { enabled = true },
                    view = "popup", -- or "cmdline", etc.
                },
                health = {
                    checker = true,
                },
                throttle = 1000, -- Throttling (ms) for Noice updates

                -- Optional, but needed to avoid warnings if you want custom views
                views = {
                    -- Example: customize the cmdline or popupmenu
                    cmdline = {
                        position = { row = -1, col = "50%" },
                        size = { height = 1 },
                    },
                    popupmenu = {
                        relative = "editor",
                        position = { row = 10, col = "50%" },
                        size = { width = 60, height = 10 },
                    },
                },
                routes = {
                    -- Add filtering or routing rules here
                },

                -- Your LSP overrides
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },

                -- Presets (your existing settings are fine here)
                presets = {
                    bottom_search = true,
                    command_palette = true,
                    long_message_to_split = true,
                    inc_rename = false,
                    lsp_doc_border = true,
                },

                -- Additional required fields
                status = {
                    enabled = true,
                    view = "mini", -- or "cmdline", etc.
                },
                format = {
                    enabled = true,
                },
                debug = false,
                log = {
                    enabled = false,
                    level = 2,
                    file = vim.fn.stdpath("data") .. "/noice.log",
                },
                log_max_size = 1024 * 1024, -- 1MB
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
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
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
        opts = {},
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
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
        config = function()
            require("barbecue").setup({
                -- Required keys:
                attach_navic = true,
                include_buftypes = { "" },
                exclude_filetypes = {
                    "gitcommit",
                    "toggleterm",
                    "DressingSelect",
                    "dashboard",
                    "cmp_menu",
                    "cmp_docs",
                    "noice",
                    "",
                },
                modifiers = {
                    dirname = ":~:.",
                    basename = "",
                },
                show_dirname = true,
                show_basename = true,
                -- Called to get the modified flag (●) if the buffer is modified
                modified = function(bufnr)
                    return vim.bo[bufnr].modified and "●" or ""
                end,
                show_modified = false,
                show_navic = true,
                lead_custom_section = function() return "" end,
                custom_section = function() return "" end,
                theme = "auto", -- or "catppuccin", "onedark", "tokyonight", etc.
                kinds = {
                    Array = "",
                    Boolean = "",
                    Class = "",
                    Color = "",
                    Constant = "",
                    Constructor = "",
                    Enum = "",
                    EnumMember = "",
                    Event = "",
                    Field = "",
                    File = "",
                    Folder = "",
                    Function = "",
                    Interface = "",
                    Key = "",
                    Keyword = "",
                    Method = "",
                    Module = "",
                    Namespace = "",
                    Null = "",
                    Number = "",
                    Object = "",
                    Operator = "",
                    Package = "",
                    Property = "",
                    Reference = "",
                    Snippet = "",
                    String = "",
                    Struct = "",
                    Text = "",
                    TypeParameter = "",
                    Unit = "",
                    Value = "",
                    Variable = "",
                },

                -- Your existing key:
                create_autocmd = false,
                -- Newly required
                context_follow_icon_color = false,
                symbols = {
                    separator = "  ",
                    modified = "●",
                    ellipsis = "…",
                },


            })

            -- Optionally auto-update barbecue on certain events
            vim.api.nvim_create_autocmd(
                { "WinScrolled", "BufWinEnter", "CursorHold", "InsertLeave" },
                {
                    group = vim.api.nvim_create_augroup("barbecue.updater", {}),
                    callback = function()
                        require("barbecue.ui").update()
                    end,
                }
            )
        end,
    },


    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
    },
    {
        "danymat/neogen",
        enabled = true,
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
            vim.g.miniindentscope_disable = true

            require("mini.ai").setup({ n_lines = 500 })
            require("mini.surround").setup()
            require("mini.pairs").setup()

            local statusline = require("mini.statusline")
            statusline.setup({
                use_icons = vim.g.have_nerd_font,
            })
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
        "MunifTanjim/nui.nvim",
    },

    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                -- Your current setting
                background_colour = "#000000",
                -- Required field to avoid the type-check warning:
                merge_duplicates = false,
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
                    hover_actions = { auto_focus = true, border = "rounded" },
                    inlay_hints = {
                        auto = true,
                        show_parameter_hints = true,
                        parameter_hints_prefix = "<- ",
                        other_hints_prefix = "-> ",
                    },
                    runnables = { use_telescope = true },
                },
                -- Comment out the entire `server` block so it won't attach rust-analyzer
                server = {
                    on_attach = function(_, bufnr)
                        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
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
                null_ls = { enabled = false, name = "crates.nvim" },
            })
        end,
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- ADDITIONAL LSP / FORMAT / LINT
    -- ─────────────────────────────────────────────────────────────────────────────
    { "kosayoda/nvim-lightbulb" },
    { "mfussenegger/nvim-lint" },
    { "mhartington/formatter.nvim" },
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
            vim.fn["mkdp#util#install"]()
        end,
    },
    { "preservim/vim-markdown" },
    { "dhruvasagar/vim-table-mode" },
    { "junegunn/limelight.vim" },
    { "junegunn/goyo.vim" },

}
