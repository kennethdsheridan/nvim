local M = {}

M.opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
тттт   ттттттттттт ттттттт ттт   тттттттттт   тттт
ттттт  ттттттттттттттттттттттт   ттттттттттт ттттт
тттттт ттттттттт  ттт   тттттт   ттттттттттттттттт
тттттттттттттттт  ттт   ттттттт тттттттттттттттттт
ттт ттттттттттттттттттттттт ттттттт тттттт ттт ттт
ттт  ттттттттттттт ттттттт   ттттт  тттттт     ттт
    ]]

    local notEmacs = [[

тттт   ттт ттттттт ттттттттт    тттттттттттт   тттт тттттт  ттттттттттттттт
ттттт  ттттттттттттттттттттт    ттттттттттттт ттттттттттттттттттттттттттттт
тттттт тттттт   ттт   ттт       тттттт  тттттттттттттттттттттт     тттттттт
ттттттттттттт   ттт   ттт       тттттт  тттттттттттттттттттттт     тттттттт
ттт ттттттттттттттт   ттт       ттттттттттт ттт тттттт  ттттттттттттттттттт
ттт  ттттт тттт
ттт    ттт       ттттттттттт     тттттт  ттт ттттттттттттттт

]]

    local notVscode = [[

тттт   ттт ттттттт ттттттттт    ттт   ттттттттттт ттттттт ттттттт ттттттт тттттттт
ттттт  ттттттттттттттттттттт    ттт   тттттттттттттттттттттттттттттттттттттттттттт
тттттт тттттт   ттт   ттт       ттт   тттттттттттттт     ттт   тттттт  ттттттттт
ттттттттттттт   ттт   ттт       тттт ттттттттттттттт     ттт   тттттт  ттттттттт
ттт ттттттттттттттт   ттт        ттттттт ттттттттттттттттттттттттттттттттттттттттт
ттт  ттттт ттттттт    ттт         ттттт  тттттттт ттттттт ттттттт ттттттт тттттттт

    ]]

    -- Choose which logo to display
    dashboard.section.header.val = vim.split(logo, "\n")

    dashboard.section.buttons.val = {
        dashboard.button("f", "я " .. " Find file", ":Telescope find_files <CR>"),
        -- dashboard.button("n", "я " .. " New file", ":ene <BAR> startinsert <CR>"),
        -- dashboard.button("r", "я " .. " Recent files", ":Telescope oldfiles <CR>"),
        -- dashboard.button("g", "яЂ " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("s", "яЎ " .. "Restore Session", '<cmd>lua require("persistence").load()<cr>'),
        -- dashboard.button("c", "яЃ " .. " Config", ":e ~/.config/nvim/ <CR>"),
        -- dashboard.button("l", "ѓАВ " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("d", "я " .. " Documentation", ":Telescope command_palette <CR>"),
        dashboard.button("q", "яІ " .. " Quit", ":qa<CR>"),
    }

    for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
    end

    -- Add documentation section
    local docs_section = {
        type = "group",
        val = {
            { type = "text",    val = "Documentation",                                                opts = { hl = "SpecialComment", position = "center" } },
            { type = "padding", val = 1 },
            { type = "text",    val = "Rust: <leader>rd | TypeScript/JS: <leader>ng | C: <leader>cm", opts = { hl = "Comment", position = "center" } },
            { type = "text",    val = "Bash: <leader>bd | Lua: <leader>ld | All: <leader>dd",         opts = { hl = "Comment", position = "center" } },
        },
        position = "center",
    }

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        docs_section,
        { type = "padding", val = 1 },
        dashboard.section.footer,
    }

    return dashboard
end

M.config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaReady",
            callback = function()
                require("lazy").show()
            end,
        })
    end

    require("alpha").setup(dashboard.config)

    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            dashboard.section.footer.val = "тЁ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
            pcall(vim.cmd.AlphaRedraw)
        end,
    })
end

return {
    "goolord/alpha-nvim",
    enabled = true,
    event = "VimEnter",
    lazy = true,
    opts = M.opts,
    config = M.config,
}

