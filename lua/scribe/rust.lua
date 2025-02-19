return {
    {
        "mrcjkb/rustaceanvim",
        version = "^3", -- Recommended
        ft = { "rust" },
        dependencies = {
            -- For inlay hints, etc.
            "nvim-lua/plenary.nvim",
            {
                "lvimuser/lsp-inlayhints.nvim",
                opts = {}
            },
            -- If you use nvim-cmp for autocompletion
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- This plugin bundles rust-tools internally, so you can require rust-tools directly:
            local rt = require("rust-tools")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            rt.setup({
                server = {
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                        -- If you want inlay hints, attach them here:
                        require("lsp-inlayhints").on_attach(client, bufnr)

                        -- Example keymaps:
                        vim.keymap.set("n", "<leader>k", rt.hover_actions.hover_actions, { buffer = bufnr })
                        vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                    end,
                },
                tools = {
                    -- Enable auto_focus in hover actions
                    hover_actions = {
                        auto_focus = true,
                    },
                },
            })
        end,
    },

    -- crates.nvim config (unchanged)
    {
        "saecki/crates.nvim",
        version = "v0.3.0",
        lazy = true,
        ft = { "rust", "toml" },
        event = { "BufRead", "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup {
                popup = {
                    border = "rounded",
                },
            }
        end,
    },
}

