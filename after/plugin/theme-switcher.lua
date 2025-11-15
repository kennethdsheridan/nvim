-- Theme Switcher for better readability than Gruvbox
-- Provides easy switching between excellent dark themes

local themes = {
    -- Recommended for readability
    { name = "kanagawa", desc = "🎨 Kanagawa - Inspired by famous painting (RECOMMENDED)" },
    { name = "onedark", desc = "🌙 OneDark - Clean and modern" },
    { name = "nightfox", desc = "🦊 Nightfox - Modern with great contrast" },
    { name = "duskfox", desc = "🌅 Duskfox - Warm dark theme" },
    { name = "nordfox", desc = "❄️  Nordfox - Cool and clean" },
    { name = "rose-pine", desc = "🌹 Rose Pine - Elegant and soft" },
    { name = "rose-pine-moon", desc = "🌙 Rose Pine Moon - Darker variant" },
    { name = "sonokai", desc = "🎵 Sonokai - High contrast" },
    { name = "dracula", desc = "🧛 Dracula - Classic dark theme" },
    
    -- Your existing themes
    { name = "tokyonight-storm", desc = "🌃 Tokyo Night Storm" },
    { name = "tokyonight-moon", desc = "🌙 Tokyo Night Moon" },
    { name = "catppuccin-mocha", desc = "☕ Catppuccin Mocha" },
    { name = "catppuccin-macchiato", desc = "☕ Catppuccin Macchiato" },
    { name = "nord", desc = "❄️  Nord - Arctic theme" },
    { name = "melange", desc = "🎨 Melange - Warm colors" },
}

-- Function to apply theme with error handling
local function apply_theme(theme_name)
    local success, err = pcall(function()
        vim.cmd("colorscheme " .. theme_name)
    end)
    
    if success then
        vim.notify("✅ Applied theme: " .. theme_name, vim.log.levels.INFO)
        -- Save preference
        vim.g.current_theme = theme_name
    else
        vim.notify("❌ Failed to load theme: " .. theme_name .. "\nError: " .. tostring(err), vim.log.levels.ERROR)
    end
end

-- Theme picker using vim.ui.select
local function show_theme_picker()
    local theme_options = {}
    for i, theme in ipairs(themes) do
        table.insert(theme_options, string.format("%d. %s", i, theme.desc))
    end
    
    vim.ui.select(theme_options, {
        prompt = "🎨 Choose a theme:",
        format_item = function(item)
            return item
        end,
    }, function(choice, idx)
        if choice and idx then
            apply_theme(themes[idx].name)
        end
    end)
end

-- Quick theme commands
vim.api.nvim_create_user_command('ThemeSwitch', show_theme_picker, { desc = "🎨 Switch between themes" })

vim.api.nvim_create_user_command('ThemeKanagawa', function()
    apply_theme('kanagawa')
end, { desc = "Apply Kanagawa theme (recommended)" })

vim.api.nvim_create_user_command('ThemeOneDark', function()
    apply_theme('onedark')
end, { desc = "Apply OneDark theme" })

vim.api.nvim_create_user_command('ThemeNightfox', function()
    apply_theme('nightfox')
end, { desc = "Apply Nightfox theme" })

vim.api.nvim_create_user_command('ThemeRosePine', function()
    apply_theme('rose-pine')
end, { desc = "Apply Rose Pine theme" })

vim.api.nvim_create_user_command('ThemeDracula', function()
    apply_theme('dracula')
end, { desc = "Apply Dracula theme" })

-- Keybinding for quick theme switching
vim.keymap.set('n', '<leader>th', show_theme_picker, { desc = "🎨 Switch theme" })

-- Quick theme cycle (for testing themes quickly)
local current_theme_index = 1
vim.keymap.set('n', '<leader>tn', function()
    current_theme_index = current_theme_index % #themes + 1
    local theme = themes[current_theme_index]
    apply_theme(theme.name)
    vim.notify("Theme " .. current_theme_index .. "/" .. #themes .. ": " .. theme.desc, vim.log.levels.INFO)
end, { desc = "🔄 Cycle to next theme" })

vim.keymap.set('n', '<leader>tp', function()
    current_theme_index = current_theme_index - 1
    if current_theme_index < 1 then current_theme_index = #themes end
    local theme = themes[current_theme_index]
    apply_theme(theme.name)
    vim.notify("Theme " .. current_theme_index .. "/" .. #themes .. ": " .. theme.desc, vim.log.levels.INFO)
end, { desc = "🔄 Cycle to previous theme" })

-- Theme information command
vim.api.nvim_create_user_command('ThemeInfo', function()
    local current = vim.g.colors_name or "unknown"
    print("🎨 Current theme: " .. current)
    print("Available themes:")
    for i, theme in ipairs(themes) do
        local marker = (theme.name == current) and " ← CURRENT" or ""
        print("  " .. theme.desc .. marker)
    end
    print("\n🎮 Commands:")
    print("  :ThemeSwitch - Interactive theme picker")
    print("  <leader>th   - Interactive theme picker")
    print("  <leader>tn   - Cycle to next theme")
    print("  <leader>tp   - Cycle to previous theme")
end, { desc = "Show theme information" })

-- Set Kanagawa as default if no theme preference is set
if not vim.g.current_theme then
    vim.defer_fn(function()
        apply_theme('kanagawa')
    end, 100)
end

-- Command to install matching iTerm2 theme
vim.api.nvim_create_user_command('InstallItermTheme', function()
    local script_path = vim.fn.stdpath('config') .. '/install-kanagawa-iterm.sh'
    if vim.fn.filereadable(script_path) == 1 then
        vim.notify("🎨 Installing Kanagawa theme for iTerm2...", vim.log.levels.INFO)
        vim.fn.system('bash ' .. script_path)
    else
        vim.notify("❌ iTerm2 installer script not found", vim.log.levels.ERROR)
    end
end, { desc = "Install matching Kanagawa theme for iTerm2" })