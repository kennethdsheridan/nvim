local telescope_ok, telescope = pcall(require, 'telescope')
local builtin_ok, builtin = pcall(require, 'telescope.builtin')

if not telescope_ok then
    vim.notify("Telescope not available", vim.log.levels.WARN)
    return
end

if not builtin_ok then
    vim.notify("Telescope builtin not available", vim.log.levels.WARN)
    return
end

-- Telescope setup with proper defaults to fix highlight issues
telescope.setup({
    defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                mirror = false,
                preview_width = 0.5,
            },
            vertical = {
                mirror = false,
            },
        },
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        set_env = { ['COLORTERM'] = 'truecolor' },
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        -- Explicitly set highlight groups to prevent errors
        hl_result_eol = "",
    },
    extensions = {
        -- Pre-configure extensions to avoid issues
        projects = {},
        git_worktree = {},
        command_palette = {},
    }
})

-- Load extensions after setup with error handling
pcall(require('telescope').load_extension, 'projects')
-- pcall(require('telescope').load_extension, 'git_worktree')  -- Temporarily disabled due to highlight error
pcall(require('telescope').load_extension, 'command_palette')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ")})
end)

