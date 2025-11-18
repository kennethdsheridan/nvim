local telescope_ok, telescope = pcall(require, 'telescope')
local builtin_ok, builtin = pcall(require, 'telescope.builtin')
local actions_ok, actions = pcall(require, 'telescope.actions')

if not telescope_ok then
    vim.notify("Telescope not available", vim.log.levels.WARN)
    return
end

if not builtin_ok then
    vim.notify("Telescope builtin not available", vim.log.levels.WARN)
    return
end

if not actions_ok then
    vim.notify("Telescope actions not available", vim.log.levels.WARN)
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
        -- Key mappings for full scrolling functionality
        mappings = {
            i = {
                ["<C-n>"] = actions.move_selection_next,
                ["<C-p>"] = actions.move_selection_previous,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-f>"] = actions.results_scrolling_down,
                ["<C-b>"] = actions.results_scrolling_up,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["<PageDown>"] = actions.results_scrolling_down,
                ["<PageUp>"] = actions.results_scrolling_up,
                ["<Tab>"] = actions.move_selection_next,
                ["<S-Tab>"] = actions.move_selection_previous,
            },
            n = {
                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-f>"] = actions.results_scrolling_down,
                ["<C-b>"] = actions.results_scrolling_up,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["<PageDown>"] = actions.results_scrolling_down,
                ["<PageUp>"] = actions.results_scrolling_up,
                ["gg"] = actions.move_to_top,
                ["G"] = actions.move_to_bottom,
            },
        },
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

-- Document symbols (functions, classes, variables in current file)
vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Find symbols/functions in file' })

-- Workspace symbols (all functions across project)
vim.keymap.set('n', '<leader>ws', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })

-- Treesitter-based symbol search (works without LSP)
vim.keymap.set('n', '<leader>ts', builtin.treesitter, { desc = 'Treesitter symbols' })

-- Quick access to current buffer functions only
vim.keymap.set('n', '<leader>fu', function()
    builtin.lsp_document_symbols({
        symbols = { "function", "method" }
    })
end, { desc = 'Find functions only' })

