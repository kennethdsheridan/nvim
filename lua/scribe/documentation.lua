return {
    -- LSP Hover Documentation Enhancement
    {
        "amrbashir/nvim-docs-view",
        opts = {
            position = "right",
            width = 60,
        },
        cmd = { "DocsViewToggle" },
        keys = {
            { "<leader>hd", "<cmd>DocsViewToggle<cr>", desc = "Toggle Documentation View" },
        },
    },

    -- Rust Documentation
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        ft = { "rust" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            vim.g.rustaceanvim = {
                tools = {
                    hover_actions = {
                        auto_focus = true,
                    },
                },
                server = {
                    on_attach = function(client, bufnr)
                        -- Enable inlay hints if supported
                        if client.server_capabilities.inlayHintProvider then
                            vim.lsp.inlay_hint.enable(bufnr, true)
                        end

                        -- Set up keymaps for Rust documentation
                        vim.keymap.set("n", "K", function()
                            vim.cmd.RustLsp("hover actions")
                        end, { buffer = bufnr, desc = "Rust Hover Actions" })

                        vim.keymap.set("n", "<leader>rd", function()
                            vim.cmd.RustLsp("openDocs")
                        end, { buffer = bufnr, desc = "Open Rust Documentation" })
                    end,
                },
            }
        end,
    },

    -- TypeScript/JavaScript Documentation
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("neogen").setup({
                enabled = true,
                languages = {
                    typescript = {
                        template = {
                            annotation_convention = "tsdoc",
                        },
                    },
                    javascript = {
                        template = {
                            annotation_convention = "jsdoc",
                        },
                    },
                },
            })

            -- Keymaps for generating documentation
            vim.keymap.set("n", "<leader>nf", function()
                require("neogen").generate({ type = "func" })
            end, { desc = "Generate function documentation" })

            vim.keymap.set("n", "<leader>nc", function()
                require("neogen").generate({ type = "class" })
            end, { desc = "Generate class documentation" })
        end,
        cmd = { "Neogen" },
        keys = {
            { "<leader>ng", "<cmd>Neogen<cr>", desc = "Generate Documentation" },
        },
    },

    -- Bash Documentation
    {
        "LinArcX/telescope-command-palette.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            -- Extension loaded in telescope config to avoid conflicts
            
            -- Keymaps for bash documentation
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sh", "bash" },
                callback = function()
                    vim.keymap.set("n", "<leader>bd", "<cmd>Telescope command_palette<cr>",
                        { buffer = true, desc = "Bash Documentation" })
                end,
            })
        end,
    },

    -- Lua Documentation
    {
        "folke/neodev.nvim",
        ft = "lua",
        config = function()
            require("neodev").setup({
                library = {
                    plugins = { "nvim-dap-ui" },
                    types = true,
                },
            })

            -- Keymaps for Lua documentation
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "lua",
                callback = function()
                    vim.keymap.set("n", "<leader>ld", function()
                        vim.lsp.buf.hover()
                    end, { buffer = true, desc = "Show Lua Documentation" })
                end,
            })
        end,
    },

    -- General Documentation Browser
    {
        "luckasRanarison/nvim-devdocs",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            dir_path = vim.fn.stdpath("data") .. "/devdocs",
            telescope = {},
            filetypes = {
                rust = { "rust" },
                javascript = { "javascript" },
                typescript = { "typescript" },
                c = { "c" },
                lua = { "lua" },
                sh = { "bash" },
            },
            float_win = {
                relative = "editor",
                height = 25,
                width = 100,
                border = "rounded",
            },
        },
        keys = {
            { "<leader>dd", "<cmd>DevdocsOpenFloat<cr>", desc = "Open DevDocs" },
            { "<leader>df", "<cmd>DevdocsOpenFloat<cr>", desc = "Open DevDocs for Current Filetype" },
            { "<leader>ds", "<cmd>DevdocsSearch<cr>",    desc = "Search DevDocs" },
        },
    },
}
