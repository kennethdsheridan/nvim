require("noice").setup({
    messages = {
        enabled = true, -- Enable messages (recommended)
    },
    popupmenu = {
        enabled = true, -- Enable popupmenu
    },
    redirect = {
        enabled = false, -- Disable redirection unless needed
    },
    commands = {
        enabled = true, -- Enable commands support
    },
    lsp = {
        progress = { enabled = true },
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    markdown = {
        hover = { enabled = true },
        view = "popup",
    },
    health = {
        checker = true, -- Enable health checks
    },
    presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false, -- Disable incremental rename unless needed
    },
    throttle = 1000,        -- Adjust throttle rate
    status = {
        enabled = true,
        view = "mini",
    },
    format = {
        enabled = true,
    },
    debug = false,       -- Disable debug mode
    log = {
        enabled = false, -- Disable logging
        level = 2,
        file = vim.fn.stdpath("data") .. "/noice.log",
    },
    log_max_size = 10000, -- Adjust max log size if needed

    -- ✅ Add missing required fields
    cmdline = {
        enabled = true,
    },
    notify = {
        enabled = true, -- Enable nvim-notify for notifications
        view = "notify",
    },
    views = {
        cmdline = {
            position = {
                row = -1,    -- Bottom position
                col = "50%", -- Center horizontally
            },
            size = {
                height = 1,
            },
        },
        popupmenu = {
            relative = "editor",
            position = {
                row = 10,
                col = "50%", -- Center horizontally
            },
            size = {
                width = 60,
                height = 10,
            },
        },
    },
    routes = {
        {
            filter = {
                event = "msg_show",
                kind = "",
            },
            opts = {
                skip = true,
            },
        },
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
