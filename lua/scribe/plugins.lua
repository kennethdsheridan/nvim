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
    -- Database Tools
    -- �����������������������������������������������������������������������������
    {
        "tpope/vim-dadbod",
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            "tpope/vim-dadbod",
            "kristijanhusak/vim-dadbod-completion",
        },
        config = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_force_echo_notifications = 1
            vim.g.db_ui_win_position = 'left'
            vim.g.db_ui_winwidth = 40
            vim.g.db_ui_default_query = 'SELECT * FROM "{table}" LIMIT 10;'

            -- Auto-completion for SQL
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "plsql" },
                callback = function()
                    local ok, cmp = pcall(require, 'cmp')
                    if ok then
                        cmp.setup.buffer({
                            sources = {
                                { name = 'vim-dadbod-completion' },
                                { name = 'buffer' },
                            },
                        })
                    end
                end,
            })
        end,
        keys = {
            { "<leader>db", "<cmd>DBUIToggle<CR>",        desc = "Toggle Database UI" },
            { "<leader>df", "<cmd>DBUIFindBuffer<CR>",    desc = "Find Database Buffer" },
            { "<leader>dr", "<cmd>DBUIRenameBuffer<CR>",  desc = "Rename Database Buffer" },
            { "<leader>dq", "<cmd>DBUILastQueryInfo<CR>", desc = "Last Query Info" },
        },
    },
    {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = "tpope/vim-dadbod",
        ft = { "sql", "mysql", "plsql" },
    },

    -- �����������������������������������������������������������������������������
    -- Git Worktree Management
    -- �����������������������������������������������������������������������������
    {
        "ThePrimeagen/git-worktree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("git-worktree").setup({
                change_directory_command = "cd",
                update_on_change = true,
                update_on_change_command = "e .",
                clearjumps_on_change = true,
                autopush = false,
            })
            -- Extension loaded in telescope config to avoid conflicts
        end,
        keys = {
            { "<leader>gw", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",       desc = "Switch worktree" },
            { "<leader>gW", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", desc = "Create worktree" },
        },
    },

    -- �����������������������������������������������������������������������������
    -- GitHub PR Review with Octo.nvim
    -- �����������������������������������������������������������������������������
    {
        "pwntester/octo.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("octo").setup({
                enable_builtin = true,
                default_to_projects_v2 = false,
                default_merge_method = "commit",
                picker = "telescope",
            })
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
     { 'cordx56/rustowl',     dependencies = { 'neovim/nvim-lspconfig' }, enabled = false }

    -- �����������������������������������������������������������������������������
    -- Augment Code completion
    -- �����������������������������������������������������������������������������
    {
        "augmentcode/augment.vim",
        enabled = false,
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
    -- OpenCode AI Assistant
    -- �����������������������������������������������������������������������������
    {
        "folke/snacks.nvim",
        opts = { input = { enabled = true } },
    },
    {
        "NickvanDyke/opencode.nvim",
        config = function()
            vim.g.opencode_opts = {
                auto_reload = true,
                split_direction = "horizontal",
                split_size = 0.3,
                auto_open = false,
            }

            -- Required for vim.g.opencode_opts.auto_reload
            vim.opt.autoread = true

            -- Basic keymaps
            vim.keymap.set("n", "<leader>ot", function() require("opencode").toggle() end,
                { desc = "Toggle embedded opencode" })
            vim.keymap.set("n", "<leader>oa", function() require("opencode").ask("@cursor: ") end,
                { desc = "Ask about this" })
            vim.keymap.set("x", "<leader>oa", function() require("opencode").ask("@selection: ") end,
                { desc = "Ask about selection" })
            vim.keymap.set("n", "<leader>o+", function() require("opencode").prompt("@buffer", { append = true }) end,
                { desc = "Add buffer to prompt" })
            vim.keymap.set("x", "<leader>o+", function() require("opencode").prompt("@selection", { append = true }) end,
                { desc = "Add selection to prompt" })
            vim.keymap.set("n", "<leader>oe",
                function() require("opencode").prompt("Explain @cursor and its context") end,
                { desc = "Explain this code" })
            vim.keymap.set("n", "<leader>on", function() require("opencode").command("session_new") end,
                { desc = "New session" })
            vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("messages_half_page_up") end,
                { desc = "Messages half page up" })
            vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("messages_half_page_down") end,
                { desc = "Messages half page down" })
            vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end,
                { desc = "Select prompt" })

            -- Enhanced context-aware keybindings
            vim.keymap.set("n", "<leader>oP", function() 
                require("opencode").prompt("@project", { append = true }) 
            end, { desc = "Add project context" })

            vim.keymap.set("n", "<leader>od", function() 
                require("opencode").prompt("@diagnostics", { append = true }) 
            end, { desc = "Add diagnostics context" })

            vim.keymap.set("n", "<leader>og", function() 
                require("opencode").prompt("@git", { append = true }) 
            end, { desc = "Add git context" })

            -- Quick code review and refactoring
            vim.keymap.set("x", "<leader>or", function() 
                require("opencode").ask("Review this code for potential issues: @selection") 
            end, { desc = "Review selected code" })

            vim.keymap.set("x", "<leader>oR", function() 
                require("opencode").ask("Suggest refactoring improvements for: @selection") 
            end, { desc = "Refactor selected code" })

            -- LSP integration
            vim.keymap.set("n", "<leader>ol", function()
                require("opencode").prompt("Explain this LSP error: @cursor", { append = true })
            end, { desc = "Explain LSP error" })

            -- Workspace-aware prompts
            vim.keymap.set("n", "<leader>ow", function()
                local project_root = vim.fn.getcwd()
                if pcall(require, "project_nvim") then
                    project_root = require("project_nvim").get_project_root() or project_root
                end
                require("opencode").prompt(string.format("Working in project: %s. @buffer", project_root), { append = true })
            end, { desc = "Add workspace context" })

            -- Auto-commands for better workflow
            vim.api.nvim_create_autocmd("FileChangedShellPost", {
                callback = function()
                    vim.notify("File updated by OpenCode", vim.log.levels.INFO)
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "OpenCodeSessionStart",
                callback = function()
                    vim.notify("OpenCode session started", vim.log.levels.INFO)
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "OpenCodeSessionEnd",
                callback = function()
                    vim.notify("OpenCode session ended", vim.log.levels.INFO)
                end,
            })

            -- File type specific prompts
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "rust",
                callback = function()
                    vim.keymap.set("n", "<leader>orc", function()
                        require("opencode").ask("Explain this Rust code and suggest improvements: @cursor")
                    end, { desc = "Rust code explanation", buffer = true })
                    
                    vim.keymap.set("n", "<leader>ort", function()
                        require("opencode").ask("Write comprehensive tests for this Rust code: @cursor")
                    end, { desc = "Generate Rust tests", buffer = true })
                    
                    vim.keymap.set("n", "<leader>orp", function()
                        require("opencode").ask("Optimize this Rust code for performance: @cursor")
                    end, { desc = "Optimize Rust performance", buffer = true })
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "lua",
                callback = function()
                    vim.keymap.set("n", "<leader>olc", function()
                        require("opencode").ask("Explain this Lua/Neovim config and suggest improvements: @cursor")
                    end, { desc = "Lua config explanation", buffer = true })
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "javascript", "typescript" },
                callback = function()
                    vim.keymap.set("n", "<leader>ojc", function()
                        require("opencode").ask("Explain this JavaScript/TypeScript code and suggest improvements: @cursor")
                    end, { desc = "JS/TS code explanation", buffer = true })
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "go",
                callback = function()
                    vim.keymap.set("n", "<leader>ogc", function()
                        require("opencode").ask("Explain this Go code and suggest improvements: @cursor")
                    end, { desc = "Go code explanation", buffer = true })
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "markdown",
                callback = function()
                    vim.keymap.set("n", "<leader>omc", function()
                        require("opencode").ask("Help improve this markdown documentation: @buffer")
                    end, { desc = "Improve markdown", buffer = true })
                end,
            })
        end,
    },

    -- �����������������������������������������������������������������������������
    -- Documentation
    -- �����������������������������������������������������������������������������
    require("scribe.documentation"),

    -- �����������������������������������������������������������������������������
    -- NeoGit
    -- �����������������������������������������������������������������������������
    -- {
    --     "NeogitOrg/neogit",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",  -- required
    --         "sindrets/diffview.nvim", -- optional - Diff integration
    --         "nvim-telescope/telescope.nvim", -- optional
    --     },
    --     config = function()
    --         require('neogit').setup {
    --             integrations = {
    --                 telescope = true,
    --                 diffview = true,
    --             }
    --         }
    --     end
    -- },

    -- �����������������������������������������������������������������������������
     -- RUSTACEANVIM (Disabled for native LSP)
     -- �����������������������������������������������������������������������������
     {
         "mrcjkb/rustaceanvim",
         version = "^5",
         ft = { "rust" },
         enabled = false,
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
                    -- "Cargo.toml",  -- Disabled: conflicts with rust-analyzer workspace detection
                    "go.mod",
                    "package.json",
                    "tsconfig.json",
                    "init.lua",
                    ".bashrc",
                },
                silent_chdir = false,
            }
            -- Extension loaded in telescope config to avoid conflicts
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
                vim.notify("CodeLLDB not installed via Mason - skipping Rust debugging setup", vim.log.levels.INFO)
                -- Still setup DAP UI without Rust debugging
                dapui.setup({
                    icons = {
                        expanded = "▾",
                        collapsed = "▸",
                        current_frame = "▸",
                    },
                })
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
        lazy = true,
        config = function()
            -- Tell Neovim we're using a light background
            vim.o.background = "light"
        end,
    },
    {
        "sainnhe/everforest",
        lazy = true,
        config = function()
            -- Make sure we support 24-bit colors
            vim.opt.termguicolors = true

            -- Tell Neovim we want a light background
            vim.o.background = "light" -- or: vim.cmd("set background=light")

            -- Optional: set contrast level ('soft', 'medium', or 'hard')
            vim.g.everforest_background = "soft"
        end
    },

    {
        "folke/tokyonight.nvim",
        lazy = true,
        config = function()
            require("tokyonight").setup({
                style = "storm", -- storm, moon, night, day
                light_style = "day",
                transparent = false,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                    sidebars = "dark",
                    floats = "dark",
                },
                sidebars = { "qf", "help" },
                day_brightness = 0.3,
                hide_inactive_statusline = false,
                dim_inactive = false,
                lualine_bold = false,
            })
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        config = function()
            require("catppuccin").setup({
                flavour = "auto", -- latte, frappe, macchiato, mocha
                background = {
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false,
                show_end_of_buffer = false,
                term_colors = false,
                dim_inactive = {
                    enabled = false,
                    shade = "dark",
                    percentage = 0.15,
                },
                no_italic = false,
                no_bold = false,
                no_underline = false,
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    notify = false,
                    mini = {
                        enabled = true,
                        indentscope_color = "",
                    },
                },
            })
        end
    },
    {
        "shaunsingh/nord.nvim",
        lazy = true,
        config = function()
            -- Colorscheme will be set by colors.lua
        end
    },

    {
        "savq/melange",
        lazy = true,
        config = function()
            vim.cmd("colorscheme melange")
        end
    },

    -- �����������������������������������������������������������������������������
    -- RECOMMENDED DARK THEMES (More readable than Gruvbox)
    -- �����������������������������������������������������������������������������
    
    -- Kanagawa - Beautiful dark theme inspired by famous painting
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                compile = false,
                undercurl = true,
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = false,
                dimInactive = false,
                terminalColors = true,
                colors = {
                    palette = {},
                    theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
                },
                theme = "wave", -- Load "wave" theme when 'background' option is not set
                background = {
                    dark = "wave", -- try "dragon" !
                    light = "lotus"
                },
            })
            vim.cmd("colorscheme kanagawa")
        end
    },

    -- Onedark - Clean and readable
    {
        "navarasu/onedark.nvim",
        lazy = true,
        config = function()
            require('onedark').setup {
                style = 'dark', -- dark, darker, cool, deep, warm, warmer, light
                transparent = false,
                term_colors = true,
                ending_tildes = false,
                cmp_itemkind_reverse = false,
                code_style = {
                    comments = 'italic',
                    keywords = 'none',
                    functions = 'none',
                    strings = 'none',
                    variables = 'none'
                },
                diagnostics = {
                    darker = true,
                    undercurl = true,
                    background = true,
                },
            }
        end
    },

    -- Nightfox - Modern and clean
    {
        "EdenEast/nightfox.nvim",
        lazy = true,
        config = function()
            require('nightfox').setup({
                options = {
                    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
                    compile_file_suffix = "_compiled",
                    transparent = false,
                    terminal_colors = true,
                    dim_inactive = false,
                    module_default = true,
                    styles = {
                        comments = "italic",
                        conditionals = "NONE",
                        constants = "NONE",
                        functions = "NONE",
                        keywords = "NONE",
                        numbers = "NONE",
                        operators = "NONE",
                        strings = "NONE",
                        types = "NONE",
                        variables = "NONE",
                    },
                    inverse = {
                        match_paren = false,
                        visual = false,
                        search = false,
                    },
                }
            })
        end
    },

    -- Rose Pine - Elegant and easy on the eyes
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
        config = function()
            require('rose-pine').setup({
                variant = 'auto', -- auto, main, moon, or dawn
                dark_variant = 'main', -- main, moon, or dawn
                dim_inactive_windows = false,
                extend_background_behind_borders = true,
                enable = {
                    terminal = true,
                    legacy_highlights = true,
                    migrations = true,
                },
                styles = {
                    bold = true,
                    italic = true,
                    transparency = false,
                },
            })
        end
    },

    -- Sonokai - High contrast and readable
    {
        "sainnhe/sonokai",
        lazy = true,
        config = function()
            vim.g.sonokai_style = 'default' -- default, atlantis, andromeda, shusia, maia, espresso
            vim.g.sonokai_better_performance = 1
            vim.g.sonokai_enable_italic = 1
            vim.g.sonokai_diagnostic_text_highlight = 1
            vim.g.sonokai_diagnostic_line_highlight = 1
        end
    },

    -- Dracula - Classic and popular
    {
        "Mofiqul/dracula.nvim",
        lazy = true,
        config = function()
            local dracula = require("dracula")
            dracula.setup({
                colors = {
                    bg = "#282A36",
                    fg = "#F8F8F2",
                    selection = "#44475A",
                    comment = "#6272A4",
                    red = "#FF5555",
                    orange = "#FFB86C",
                    yellow = "#F1FA8C",
                    green = "#50fa7b",
                    purple = "#BD93F9",
                    cyan = "#8BE9FD",
                    pink = "#FF79C6",
                    bright_red = "#FF6E6E",
                    bright_green = "#69FF94",
                    bright_yellow = "#FFFFA5",
                    bright_blue = "#D6ACFF",
                    bright_magenta = "#FF92DF",
                    bright_cyan = "#A4FFFF",
                    bright_white = "#FFFFFF",
                    menu = "#21222C",
                    visual = "#3E4452",
                    gutter_fg = "#4B5263",
                    nontext = "#3B4048",
                    white = "#ABB2BF",
                    black = "#191A21",
                },
                show_end_of_buffer = true,
                transparent_bg = false,
                lualine_bg_color = "#44475a",
                italic_comment = true,
            })
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

    -- DISABLED: Force disable nvim-cmp for native LSP only
    cmp.setup({ enabled = false })
    return
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
                hijack_netrw = true,
                hijack_directories = {
                    enable = false,
                },
                disable_netrw = true,
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
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                contrast = "medium",
                transparent_mode = false,
                palette_overrides = {},
                overrides = {},
            })
        end,
    },
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
    -- Aerial VIM (Code outline - disabled by default to avoid conflicts)
    -- �����������������������������������������������������������������������������
    {
        "stevearc/aerial.nvim",
        enabled = false, -- Disabled to avoid keymap conflicts
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
                    -- Use non-conflicting keybindings for Aerial navigation
                    vim.keymap.set("n", "[a", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Aerial: Previous symbol" })
                    vim.keymap.set("n", "]a", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Aerial: Next symbol" })
                    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { buffer = bufnr, desc = "Aerial: Toggle outline" })
                    
                    -- Use leader-based keys instead of conflicting with { and }
                    vim.keymap.set("n", "<leader>[", "<cmd>AerialPrevUp<CR>", { buffer = bufnr, desc = "Aerial: Previous level up" })
                    vim.keymap.set("n", "<leader>]", "<cmd>AerialNextUp<CR>", { buffer = bufnr, desc = "Aerial: Next level up" })

                    vim.api.nvim_create_autocmd("QuitPre", {
                        buffer = bufnr,
                        callback = function()
                            if vim.fn.winnr("$") == 1 then
                                vim.cmd("AerialClose")
                            end
                        end,
                    })

                    -- Don't auto-open Aerial to avoid conflicts
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
    {
        "mhartington/formatter.nvim",
        config = function()
            require("formatter").setup({
                logging = true,
                log_level = vim.log.levels.WARN,
                filetype = {
                    nix = {
                        require("formatter.filetypes.nix").nixpkgsfmt
                    },
                    ["*"] = {
                        require("formatter.filetypes.any").remove_trailing_whitespace
                    }
                }
            })

            vim.api.nvim_create_augroup("__formatter__", { clear = true })
            vim.api.nvim_create_autocmd("BufWritePost", {
                group = "__formatter__",
                pattern = "*.nix",
                command = ":FormatWrite",
            })
        end,
    },
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
                auto_load = true,          -- automatically load preview when entering markdown buffer
                close_on_bdelete = true,   -- close preview window on buffer delete
                syntax = true,             -- enable syntax highlighting
                theme = 'dark',            -- 'dark' or 'light'
                update_on_change = true,
                app = 'webview',           -- use native macOS webview
                filetype = { 'markdown' }, -- list of filetypes to recognize as markdown
                throttle_at = 200000,      -- start throttling when file exceeds this amount of bytes
                throttle_time = 'auto',    -- minimum time between updates
            })
        end,
    },
    { "dhruvasagar/vim-table-mode" },
    { "junegunn/limelight.vim" },
    { "junegunn/goyo.vim" },

    -- �����������������������������������������������������������������������������
    -- OTTER NEOVIM
    -- �����������������������������������������������������������������������������


    {
        'jmbuhr/otter.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {
            lsp = {
                -- Enable LSP for embedded languages
                hover = {
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                },
                -- Language-specific LSP configurations
                diagnostic_update_events = { "BufWritePost", "InsertLeave", "TextChanged" },
            },
            buffers = {
                -- Set to true to write to a temporary file and read from it instead of
                -- redrawing the buffer
                set_filetype = false,
                -- Write to a temporary file and read from it instead of redrawing the buffer
                write_to_disk = false,
            },
            strip_wrapping_quote_characters = { "'", '"', "`" },
            -- Language specific highlighters
            handle_leading_whitespace = true,
        },
        config = function(_, opts)
            require('otter').setup(opts)

            -- Only activate otter for languages with available treesitter parsers
            local function has_parser(lang)
                local ok, _ = pcall(vim.treesitter.language.require_language, lang)
                return ok
            end

            local otter_languages = {
                'python', 'javascript', 'typescript', 'lua', 'rust', 'bash', 'sh',
                'go', 'cpp', 'c', 'java', 'ruby', 'php', 'perl', 'r', 'sql'
            }

            for _, lang in ipairs(otter_languages) do
                if has_parser(lang) then
                    local ok, err = pcall(require('otter').activate, { lang })
                    if not ok then
                        vim.notify("Failed to activate otter for " .. lang .. ": " .. err, vim.log.levels.DEBUG)
                    end
                end
            end
        end,
    },

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

    -- �����������������������������������������������������������������������������
    -- SNACKS.NVIM - QoL Plugin Collection
    -- �����������������������������������������������������������������������������
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false }, -- Keep your alpha dashboard
            explorer = { 
                enabled = true,
                replace_netrw = false,
            },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = false }, -- Keep your nvim-notify
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = false }, -- Keep your neoscroll
            statuscolumn = { enabled = true },
            words = { enabled = true },
            bufdelete = { enabled = false }, -- Keep your existing bufdelete
            terminal = { enabled = true },
            lazygit = { enabled = true },
            zen = { enabled = true },
            gitbrowse = { enabled = true },
            rename = { enabled = true },
            scratch = { enabled = true },
            toggle = { enabled = true },
        },
        keys = {
            -- File operations
            { "<leader>fe", function() Snacks.explorer() end, desc = "File Explorer" },
            { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
            { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
            
            -- Pickers (integrating with your existing telescope setup)
            { "<leader>sf", function() Snacks.picker.files() end, desc = "Snacks: Find Files" },
            { "<leader>sg", function() Snacks.picker.grep() end, desc = "Snacks: Live Grep" },
            { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Snacks: Buffers" },
            { "<leader>sr", function() Snacks.picker.recent() end, desc = "Snacks: Recent Files" },
            { "<leader>sh", function() Snacks.picker.help() end, desc = "Snacks: Help Pages" },
            { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Snacks: Keymaps" },
            { "<leader>sc", function() Snacks.picker.commands() end, desc = "Snacks: Commands" },
            { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Snacks: Diagnostics" },
            
            -- Git operations
            { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
            { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
            { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
            { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
            { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
            
            -- LSP
            { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
            { "gr", function() Snacks.picker.lsp_references() end, desc = "References" },
            { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
            { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
            { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
            
            -- Terminal and utilities
            { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
            { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
            { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
            { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
            { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
            
            -- Word navigation
            { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
            { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup debug globals
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end

                    -- Create toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.line_number():map("<leader>ul")
                    Snacks.toggle.treesitter():map("<leader>uT")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                    Snacks.toggle.indent():map("<leader>ug")
                    Snacks.toggle.dim():map("<leader>uD")
                end,
            })
        end,
    },

}
