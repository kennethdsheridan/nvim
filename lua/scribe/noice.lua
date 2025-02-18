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
                row = -1, -- Use a negative value for bottom position
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
                width = 60, -- Set width to fit your preference
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
