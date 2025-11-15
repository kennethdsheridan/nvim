return {
    -- crates.nvim for Cargo.toml dependency management
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