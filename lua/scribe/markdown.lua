return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        config = function()
            vim.cmd([[do FileType]])
        end,
    },

    {
        "lukas-reineke/headlines.nvim",
        opts = function()
            local opts = {}
            for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
                opts[ft] = {
                    headline_highlights = {},
                    -- disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
                    bullets = {},
                }
                for i = 1, 6 do
                    local hl = "Headline" .. i
                    vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
                    table.insert(opts[ft].headline_highlights, hl)
                end
            end
            return opts
        end,
        ft = { "markdown", "norg", "rmd", "org" },
        config = function(_, opts)
            -- PERF: schedule to prevent headlines slowing down opening a file
            vim.schedule(function()
                require("headlines").setup(opts)
                require("headlines").refresh()
            end)
        end,
    },

    {
        "mzlogin/vim-markdown-toc",
    },

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
}
