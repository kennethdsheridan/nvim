require('noice').setup({
    -- Configuration for routes
    routes = {
        {
            filter = {
                event = "msg_show",
                kind = ""
            },
            opts = {
                skip = true
            }
        },
        -- Additional route filters can be added here
    },

    -- Configuration for views
    views = {
        cmdline = {
            position = {
                row = -1,    -- Use a negative value for bottom position
                col = "50%", -- Center horizontally
            },
            size = {
                height = 1, -- Adjust height as needed
            },
        },
        popupmenu = {
            relative = "editor",
            position = {
                row = "10%", -- Adjust vertical position as needed
                col = "50%", -- Center horizontally
            },
            size = {
                width = 60,  -- Set width to fit your preference
                height = 10, -- Set height for the popup menu
            },
        },
        -- Add more custom view configurations here if needed
    },

    -- Configuration for cmdline
    cmdline = {
        icons = {
            ["/"] = {
                icon = "",
                hl_group = "DiagnosticWarn",
                firstc = false
            },
            [":"] = {
                icon = "",
                hl_group = "DiagnosticInfo",
                firstc = false
            },
            -- Add more cmdline icons as needed
        },
    },

    -- Configuration for notify
    notify = {
        enabled = true, -- Use nvim-notify for notifications
        view = "notify",
    },
})

return {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = {
        -- add any options here
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,        -- add a border to hover docs and signature help
            },
            -- cmdline = {
            --     view = "cmdline",
            -- },
        })
    end,
}
