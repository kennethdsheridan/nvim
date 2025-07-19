return {

    -- �����������������������������������������������������������������������������
    -- SNIPPETS
    -- �����������������������������������������������������������������������������
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
    },

    -- �����������������������������������������������������������������������������
    -- HA Proxy
    -- �����������������������������������������������������������������������������
    { 'Joorem/vim-haproxy' },

    -- �����������������������������������������������������������������������������
    -- Git Signs, Fugitive, and Diffview Integration
    -- �����������������������������������������������������������������������������
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "�" },
                    change       = { text = "�" },
                    delete       = { text = "_" },
                    topdelete    = { text = "�" },
                    changedelete = { text = "~" },
                    untracked    = { text = "�" },
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

    -- �����������������������������������������������������������������������������
    -- Monorepo
    -- �����������������������������������������������������������������������������
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

    -- �����������������������������������������������������������������������������
    -- Rust Owl
    -- �����������������������������������������������������������������������������
    { "cordx56/rustowl",   dependencies = { "neovim/nvim-lspconfig" } },

    -- �����������������������������������������������������������������������������
    -- Augment Code completion
    -- �����������������������������������������������������������������������������
    {
        "augmentcode/augment.vim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            -- Workspace configuration
            local home = vim.fn.expand("$HOME")
            local code_dir = vim.fn.expand("/Users/kennysheridan/Documents")
            if vim.fn.isdirectory(code_dir) == 1 then
                vim.g.augment_workspace_folders = { code_dir }
            end

            -- Run commands configuration
            vim.g.augment_run_commands = {
                rust = "cargo run",
                python = "python3 %",
                sh = "bash %",
                typescript = "ts-node %",
                javascript = "node %",
                go = "go run %",
                lua = "lua %",
                cpp = "g++ % -o %:r && ./%:r",
                c = "gcc % -o %:r && ./%:r",
            }

            -- Telescope integration
            local function setup_telescope_integration()
                local ok, telescope = pcall(require, "telescope.builtin")
                if not ok then
                    vim.notify("Telescope not available for Augment integration", vim.log.levels.WARN)
                    return
                end

                vim.api.nvim_create_user_command("AugmentTelescope", function()
                    telescope.find_files({
                        prompt_title = "Augment Project Files",
                        cwd = vim.fn.getcwd(),
                        hidden = true,
                        follow = true,
                    })
                end, {})
            end

            -- Keymaps configuration
            local function setup_keymaps()
                local opts = { silent = true, noremap = true }

                -- Chat operations
                vim.keymap.set("n", "<leader>ac", "<cmd>Augment chat<CR>",
                    vim.tbl_extend("force", opts, { desc = "Augment: Enter Chat Mode" }))

                vim.keymap.set("n", "<leader>an", "<cmd>Augment new-chat<CR>",
                    vim.tbl_extend("force", opts, { desc = "Augment: Create New Chat" }))

                vim.keymap.set("n", "<leader>at", "<cmd>Augment chat-toggle<CR>",
                    vim.tbl_extend("force", opts, { desc = "Augment: Toggle chat window" }))
            end

            -- Initialize all components
            setup_telescope_integration()
            setup_keymaps()
        end,
        event = "VeryLazy",
    },

    -- �����������������������������������������������������������������������������
    -- Documentation
    -- �����������������������������������������������������������������������������
    require("scribe.documentation"),

    -- �����������������������������������������������������������������������������
    -- NeoGit
    -- �����������������������������������������������������������������������������
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

    -- �����������������������������������������������������������������������������
    -- RUSTACEANVIM (Commented Out)
    -- �����������������������������������������������������������������������������
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        ft = { "rust" },
        config = function()
            -- ...
        end,
    },

    -- �����������������������������������������������������������������������������
    -- Project management
    -- �����������������������������������������������������������������������������
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

    -- �����������������������������������������������������������������������������
    -- LuaLine
    -- �����������������������������������������������������������������������������
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- �����������������������������������������������������������������������������
    -- Alpha NVIM
    -- �����������������������������������������������������������������������������
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

    -- �����������������������������������������������������������������������������
    -- TODO Comments
    -- �����������������������������������������������������������������������������
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    -- �����������������������������������������������������������������������������
    -- DAP & DAP UI
    -- �����������������������������������������������������������������������������
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio", -- required by nvim-dap-ui
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- FIXED: Add error handling for mason registry
            local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
            if not mason_registry_ok then
                vim.notify("Mason registry not available", vim.log.levels.WARN)
                return
            end

            -- FIXED: Add error handling for codelldb package
            local codelldb_ok, codelldb = pcall(mason_registry.get_package, "codelldb")
            if not codelldb_ok then
                vim.notify("CodeLLDB not installed via Mason", vim.log.levels.WARN)
                return
            end

            -- 1. Get codelldb paths from Mason
            local extension_path = codelldb:get_install_path() .. "/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib" -- Adjust if needed

            -- 2. Define the rt_lldb adapter for Rust (via codelldb)
            dap.adapters.rt_lldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb_path,
                    -- Pass `--liblldb` so codelldb knows where to find lldb.dylib
                    args = { "--liblldb", liblldb_path, "--port", "${port}" },
                },
                env = {
                    -- This can help certain TTY-launch issues on macOS
                    LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
                },
            }

            -- Helper: automatically build/pick the first bin target from cargo metadata
            local function pick_first_bin_target()
                -- 1) Fetch metadata
                local output = vim.fn.systemlist("cargo metadata --format-version 1 --no-deps")
                if vim.v.shell_error ~= 0 then
                    error("Error running 'cargo metadata':\n" .. table.concat(output, "\n"))
                end
                local metadata = vim.fn.json_decode(table.concat(output, "\n"))

                -- 2) Grab the first package
                local pkg = metadata.packages[1]
                if not pkg then
                    error("No packages found in 'cargo metadata'.")
                end

                -- 3) Collect all bin targets
                local bin_targets = {}
                for _, target in ipairs(pkg.targets or {}) do
                    if vim.tbl_contains(target.kind, "bin") then
                        table.insert(bin_targets, target.name)
                    end
                end
                if #bin_targets == 0 then
                    error("No bin targets found in package '" .. pkg.name .. "'.")
                end

                -- 4) Build the *first* bin target
                local bin_name = bin_targets[1]
                local build_cmd = "cargo build --bin " .. bin_name
                local build_result = vim.fn.systemlist(build_cmd)
                if vim.v.shell_error ~= 0 then
                    error("Error building " .. bin_name .. ":\n" .. table.concat(build_result, "\n"))
                end

                -- 5) Return the resulting path
                local exe_path = "target/debug/" .. bin_name
                if vim.fn.executable(exe_path) == 0 then
                    error("Could not find debug executable at " .. exe_path)
                end
                return exe_path
            end

            -- Helper: build & locate the test executable
            local function get_test_executable()
                -- Build tests (without running them)
                vim.fn.system("cargo test --no-run")

                local metadata_json = vim.fn.system("cargo metadata --format-version 1 --no-deps")
                local metadata = vim.fn.json_decode(metadata_json)
                local target_name = metadata.packages[1].targets[1].name

                -- Find the test artifact. This assumes a single test target.
                local pattern = "target/debug/deps/" .. target_name .. "-*"
                local test_files = vim.fn.glob(pattern, 1, 1)
                if #test_files == 0 then
                    error("Test executable not found after running cargo test --no-run")
                end
                return test_files[1]
            end

            -- 3. Set up nvim-dap-ui
            dapui.setup({
                icons = {
                    expanded = "�",
                    collapsed = "�",
                    current_frame = "�", -- Required by nvim-dap-ui v3
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
                        pause = "",
                        play = "",
                        step_into = "",
                        step_over = "",
                        step_out = "",
                        step_back = "",
                        run_last = "",
                        terminate = "",
                    },
                },
                render = {
                    max_type_length = nil,
                    indent = 1, -- Required by nvim-dap-ui v3
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

            -- 4. Rust-specific configurations (no prompts for program or args)
            dap.configurations.rust = {
                {
                    name = "Debug Rust (auto bin)",
                    type = "rt_lldb", -- Uses our `rt_lldb` adapter defined above
                    request = "launch",
                    program = pick_first_bin_target,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                },
                {
                    name = "Debug Rust Tests",
                    type = "rt_lldb",
                    request = "launch",
                    program = get_test_executable,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                },
            }

            -- 5. Auto-open/close the DAP UI
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

    -- �����������������������������������������������������������������������������
    -- Themes
    -- �����������������������������������������������������������������������������
    {
        "NLKNguyen/papercolor-theme",
        lazy = false,
        priority = 1000,
        config = function()
            -- Tell Neovim we're using a light background
            vim.o.background = "light"

            -- Then set the PaperColor theme
            vim.cmd("colorscheme PaperColor")
        end,
    },
    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
        config = function()
            -- Make sure we support 24-bit colors
            vim.opt.termguicolors = true

            -- Tell Neovim we want a light background
            vim.o.background = "light" -- or: vim.cmd("set background=light")

            -- Optional: set contrast level ('soft', 'medium', or 'hard')
            vim.g.everforest_background = "soft"

            -- Finally, load the colorscheme
            vim.cmd("colorscheme everforest")
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






    -- �����������������������������������������������������������������������������
    -- LSP CONFIG / MASON / LSP-ZERO
    -- �����������������������������������������������������������������������������
    { "neovim/nvim-lspconfig" },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        -- Mason setup is handled in after/plugin/lsp.lua
    },
    {
        "williamboman/mason-lspconfig.nvim",
        -- mason-lspconfig setup is handled in after/plugin/lsp.lua
    },

    -- �����������������������������������������������������������������������������
    -- LSP Zero
    -- �����������������������������������������������������������������������������
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "L3MON4D3/LuaSnip",
        },
        -- lsp-zero configuration is handled in after/plugin/lsp.lua
    },

    -- �����������������������������������������������������������������������������
    -- AUTOCOMPLETION (CMP) + TABNINE
    -- �����������������������������������������������������������������������������
    { "hrsh7th/cmp-buffer" },
    {
        "codota/tabnine-nvim",
        build = "./dl_binaries.sh",
        event = "InsertEnter",
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

    -- �����������������������������������������������������������������������������
    -- FILE EXPLORER (Nvim-Tree)
    -- �����������������������������������������������������������������������������
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                hijack_netrw = false, -- or true if you want Nvim-Tree to replace netrw, but be aware of its side effects
                hijack_directories = {
                    enable = false,
                },
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

    -- �����������������������������������������������������������������������������
    -- GIT / DIFF / TROUBLE
    -- �����������������������������������������������������������������������������
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
                fold_open = "",
                fold_closed = "",
                group = true,
                padding = true,

                -- Previously "action_keys"; now must be under `keys`
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
                open_no_results = false, -- Don't auto-open Trouble if no results
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
                    error = "",
                    warning = "",
                    hint = "",
                    information = "",
                    other = "",
                },
                use_diagnostic_signs = false,
            })
        end,
    },

    -- �����������������������������������������������������������������������������
    -- TELESCOPE
    -- �����������������������������������������������������������������������������
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- �����������������������������������������������������������������������������
    -- NOTIFICATIONS (NOICE + NOTIFY)
    -- �����������������������������������������������������������������������������
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

    -- �����������������������������������������������������������������������������
    -- COLORS & THEMES
    -- �����������������������������������������������������������������������������
    { "EdenEast/nightfox.nvim" },
    { "ellisonleao/gruvbox.nvim" },
    { "sainnhe/gruvbox-material" },

    -- �����������������������������������������������������������������������������
    -- TREESITTER
    -- �����������������������������������������������������������������������������
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    { "nvim-treesitter/playground" },

    -- �����������������������������������������������������������������������������
    -- MISC UTILITIES
    -- �����������������������������������������������������������������������������
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
                -- Called to get the modified flag (�) if the buffer is modified
                modified = function(bufnr)
                    return vim.bo[bufnr].modified and "�" or ""
                end,
                show_modified = false,
                show_navic = true,
                lead_custom_section = function() return "" end,
                custom_section = function() return "" end,
                theme = "auto", -- or "catppuccin", "onedark", "tokyonight", etc.
                kinds = {
                    Array = "",
                    Boolean = "",
                    Class = "",
                    Color = "",
                    Constant = "",
                    Constructor = "",
                    Enum = "",
                    EnumMember = "",
                    Event = "",
                    Field = "",
                    File = "",
                    Folder = "",
                    Function = "",
                    Interface = "",
                    Key = "",
                    Keyword = "",
                    Method = "",
                    Module = "",
                    Namespace = "",
                    Null = "",
                    Number = "",
                    Object = "",
                    Operator = "",
                    Package = "",
                    Property = "",
                    Reference = "",
                    Snippet = "",
                    String = "",
                    Struct = "",
                    Text = "",
                    TypeParameter = "",
                    Unit = "",
                    Value = "",
                    Variable = "",
                },

                -- Your existing key:
                create_autocmd = false,
                -- Newly required
                context_follow_icon_color = false,
                symbols = {
                    separator = "  ",
                    modified = "�",
                    ellipsis = "�",
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

    -- �����������������������������������������������������������������������������
    -- CLOAK
    -- �����������������������������������������������������������������������������
    {
        "laytan/cloak.nvim",
    },

    -- �����������������������������������������������������������������������������
    -- RUST TOOLS & CRATES
    -- �����������������������������������������������������������������������������
    --     {
    --         "simrat39/rust-tools.nvim",
    --         config = function()
    --             local capabilities = require("cmp_nvim_lsp").default_capabilities()
    --             local rt = require("rust-tools")
    --             rt.setup({
    --                 tools = {
    --                     hover_actions = { auto_focus = true, border = "rounded" },
    --                     inlay_hints = {
    --                         auto = true,
    --                         show_parameter_hints = true,
    --                         parameter_hints_prefix = "<- ",
    --                         other_hints_prefix = "-> ",
    --                     },
    --                     runnables = { use_telescope = true },
    --                 },
    --                 -- Comment out the entire `server` block so it won't attach rust-analyzer
    --                 server = {
    --                     on_attach = function(_, bufnr)
    --                         vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
    --                     end,
    --                     capabilities = capabilities,
    --                     settings = {
    --                         ["rust-analyzer"] = {
    --                             cargo = {
    --                                 allFeatures = true,
    --                             },
    --                             checkOnSave = {
    --                                 command = "clippy",
    --                             },
    --                         },
    --                     },
    --                 },
    --             })
    --         end,
    --     },
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
                        title = " %s",
                        version = "   %s",
                        date = "   %s",
                        features = " � Features",
                        dependencies = " � Dependencies",
                    },
                },
                completion = {
                    insert_closing_quote = true,
                },
                null_ls = { enabled = false, name = "crates.nvim" },
            })
        end,
    },

    -- �����������������������������������������������������������������������������
    -- Aerial VIM
    -- �����������������������������������������������������������������������������
    {
        "stevearc/aerial.nvim",
        config = function()
            require("aerial").setup({
                backends = { "lsp", "treesitter", "markdown", "man" },
                show_guides = true,
                icons = {
                    Array = "� ",
                    Boolean = " ",
                    Class = "� ",
                    Constant = "� ",
                    Constructor = " ",
                    Function = "� ",
                    Interface = " ",
                    Key = "� ",
                    Method = "� ",
                    Module = " ",
                    Namespace = "� ",
                    Number = "� ",
                    Object = "� ",
                    Property = " ",
                    String = "� ",
                    Struct = "� ",
                    Variable = "� ",
                },
                focus_on_open = false,
                layout = {
                    width = 70,
                    placement = "edge",
                    preserve_equality = true,
                },
                open_automatic = false,
                close_on_select = false,
                center_on_jump = true,
                on_attach = function(bufnr)
                    vim.keymap.set("n", "[a", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "]a", "<cmd>AerialNext<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "<leader>f", "<cmd>AerialToggle!<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "{", "<cmd>AerialPrevUp<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "}", "<cmd>AerialNextUp<CR>", { buffer = bufnr })

                    vim.api.nvim_create_autocmd("QuitPre", {
                        buffer = bufnr,
                        callback = function()
                            if vim.fn.winnr("$") == 1 then
                                vim.cmd("AerialClose")
                            end
                        end,
                    })

                    -- � REMOVE THIS TO DISABLE AUTO OPEN ON BUFFER ATTACH
                    -- vim.cmd("AerialOpen")
                end,
                filter_kind = {
                    "Class",
                    "Constructor",
                    "Enum",
                    "Function",
                    "Interface",
                    "Module",
                    "Method",
                    "Struct",
                },
                highlight_on_hover = true,
                highlight_on_jump = 300,
            })

            -- � REMOVE THIS TO DISABLE AUTO OPEN ON VIM STARTUP
            -- vim.api.nvim_create_autocmd("VimEnter", {
            --     callback = function()
            --         vim.defer_fn(function()
            --             vim.cmd("AerialOpen")
            --         end, 100)
            --     end,
            -- })
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-web-devicons",
        },
    },
    -- �����������������������������������������������������������������������������
    -- ADDITIONAL LSP / FORMAT / LINT
    -- �����������������������������������������������������������������������������
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
                    text = "�",
                    virt_text_pos = "eol",
                },
            })
            vim.cmd([[
              autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
            ]])
        end,
    },

    -- �����������������������������������������������������������������������������
    -- BASH-SPECIFIC
    -- �����������������������������������������������������������������������������
    { "vim-scripts/bats.vim" },
    { "chrisbra/vim-sh-indent" },
    { "arzg/vim-sh" },

    -- �����������������������������������������������������������������������������
    -- MARKDOWN
    -- �����������������������������������������������������������������������������
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

    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({
                auto_load = true,         -- automatically load preview when entering markdown buffer
                close_on_bdelete = true,  -- close preview window on buffer delete
                syntax = true,            -- enable syntax highlighting
                theme = 'dark',           -- 'dark' or 'light'
                update_on_change = true,
                app = 'webview',          -- use native macOS webview
                filetype = { 'markdown' }, -- list of filetypes to recognize as markdown
                throttle_at = 200000,     -- start throttling when file exceeds this amount of bytes
                throttle_time = 'auto',   -- minimum time between updates
            })
        end,
    },
    { "dhruvasagar/vim-table-mode" },
    { "junegunn/limelight.vim" },
    { "junegunn/goyo.vim" },

    -- �����������������������������������������������������������������������������
    -- RENDER MARKDOWN
    -- �����������������������������������������������������������������������������
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        ft = { "markdown" },
        config = function()
            require('render-markdown').setup({
                -- Enable for markdown files
                enabled = true,
                -- File types to enable for
                file_types = { 'markdown' },
                -- Render style
                render_modes = { 'n', 'c' },
                -- Enable anti-conceal
                anti_conceal = {
                    enabled = true,
                },
                -- Configure heading styles
                heading = {
                    enabled = true,
                    sign = true,
                    position = 'overlay',
                    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
                    signs = { '󰫎 ' },
                    width = 'full',
                    left_pad = 0,
                    right_pad = 0,
                    min_width = 0,
                    border = false,
                    border_virtual = false,
                    above = '',
                    below = '',
                },
                -- Configure code block rendering
                code = {
                    enabled = true,
                    sign = true,
                    style = 'full',
                    position = 'left',
                    language_pad = 0,
                    disable_background = { 'diff' },
                    width = 'full',
                    left_pad = 0,
                    right_pad = 0,
                    min_width = 0,
                    border = 'thin',
                    above = '',
                    below = '',
                    highlight = 'RenderMarkdownCode',
                    highlight_inline = 'RenderMarkdownCodeInline',
                },
                -- Configure list rendering
                bullet = {
                    enabled = true,
                    icons = { '●', '○', '◆', '◇' },
                    left_pad = 0,
                    right_pad = 0,
                    highlight = 'RenderMarkdownBullet',
                },
            })
        end,
    },

}

