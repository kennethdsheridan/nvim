return {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = true,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    opts = {
        messages = {
            enabled = true,
        },
        popupmenu = {
            enabled = true,
        },
        redirect = {
            enabled = false,
        },
        cmdline = {
            enabled = true,
        },
        notify = {
            enabled = true,
            view = "notify",
        },
        lsp = {
            progress = { enabled = true },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        health = {
            checker = true,
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = true,
        },
        views = {
            cmdline = {
                position = {
                    row = -1,
                    col = "50%",
                },
                size = {
                    height = 1,
                },
            },
            popupmenu = {
                relative = "editor",
                position = {
                    row = 10,
                    col = "50%",
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
    },
}
