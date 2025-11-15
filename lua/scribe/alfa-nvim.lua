local M = {}

M.opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
                                                
        ╭─────────────────────────────╮        
        │           NeoVim            │        
        │     Powered Editor for      │        
        │       Professionals         │        
        ╰─────────────────────────────╯        
                       🦀                      
                                                
    ]]

    local notEmacs = [[

����   ��� ������� ���������    ������������   ���� ������  ���������������
�����  ���������������������    ������������� �����������������������������
������ ������   ���   ���       ������  ����������������������     ��������
�������������   ���   ���       ������  ����������������������     ��������
��� ���������������   ���       ����������� ��� ������  �������������������
���  ����� ����
���    ���       �����������     ������  ��� ���������������

]]

    local notVscode = [[

����   ��� ������� ���������    ���   ����������� ������� ������� ������� ��������
�����  ���������������������    ���   ��������������������������������������������
������ ������   ���   ���       ���   ��������������     ���   ������  ���������
�������������   ���   ���       ���� ���������������     ���   ������  ���������
��� ���������������   ���        ������� �����������������������������������������
���  ����� �������    ���         �����  �������� ������� ������� ������� ��������

    ]]

    -- Choose which logo to display
    dashboard.section.header.val = vim.split(logo, "\n")

    dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        -- dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        -- dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        -- dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("s", " " .. "Restore Session", '<cmd>lua require("persistence").load()<cr>'),
        -- dashboard.button("c", " " .. " Config", ":e ~/.config/nvim/ <CR>"),
        -- dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("d", "󰈙 " .. " Documentation", ":Telescope command_palette <CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
    }

    for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
    end

    -- Add documentation section
    local docs_section = {
        type = "group",
        val = {
            { type = "text",    val = "🔧 Essential Keybindings",                                        opts = { hl = "SpecialComment", position = "center" } },
            { type = "padding", val = 1 },
            { type = "text",    val = "Git: <leader>gs (status) | <leader>gp (preview) | <leader>gt (blame)", opts = { hl = "Comment", position = "center" } },
            { type = "text",    val = "Octo: <leader>opl (PRs) | <leader>opr (review) | <leader>opc (checkout)", opts = { hl = "Comment", position = "center" } },
            { type = "text",    val = "Files: <leader>pf (find) | <C-p> (git files) | <leader>/ (grep)", opts = { hl = "Comment", position = "center" } },
            { type = "text",    val = "Harpoon: <leader>a (add) | <C-e> (menu) | <C-h/t/n/s> (nav)",   opts = { hl = "Comment", position = "center" } },
            { type = "text",    val = "Debug: <F5> (run) | <Leader>b (breakpoint) | <leader>tt (trouble)", opts = { hl = "Comment", position = "center" } },
        },
        position = "center",
    }

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    dashboard.config.layout = {
        { type = "padding", val = 4 },
        dashboard.section.header,
        { type = "padding", val = 3 },
        dashboard.section.buttons,
        { type = "padding", val = 2 },
        docs_section,
        { type = "padding", val = 2 },
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
            dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
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

