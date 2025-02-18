-- Set leader key
vim.g.mapleader = " "

-- Project navigation
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- GOTO declaration and documentation navigation
-- Go to reference (LSP go to definition/reference)
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Go to reference" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { desc = "Show documentation hover" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Nvim DAP (Debugger) mappings
vim.keymap.set("n", "<Leader>dl", function()
    require('dap').step_into()
end, { desc = "Debugger step into" })

vim.keymap.set("n", "<Leader>dj", function()
    require('dap').step_over()
end, { desc = "Debugger step over" })

vim.keymap.set("n", "<Leader>dk", function()
    require('dap').step_out()
end, { desc = "Debugger step out" })

vim.keymap.set("n", "<Leader>dc", function()
    require('dap').continue()
end, { desc = "Debugger continue" })

vim.keymap.set("n", "<Leader>db", function()
    require('dap').toggle_breakpoint()
end, { desc = "Debugger toggle breakpoint" })

vim.keymap.set("n", "<Leader>dd", function()
    local condition = vim.fn.input('Breakpoint condition: ')
    require('dap').set_breakpoint(condition)
end, { desc = "Debugger set conditional breakpoint" })

vim.keymap.set("n", "<Leader>de", function()
    require('dap').terminate()
end, { desc = "Debugger reset" })

vim.keymap.set("n", "<Leader>dr", function()
    require('dap').run_last()
end, { desc = "Debugger run last" })

-- Rustacean vim mapping
vim.keymap.set("n", "<Leader>dt", function()
    vim.cmd('RustLsp testables')
end, { desc = "Debugger testables" })


-- Visual mode adjustments
-- Move selected block of text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Normal mode adjustments
-- Join lines without moving the cursor
vim.keymap.set("n", "J", "mzJ`z")
-- Center screen after page down/up
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Center screen after searching next/previous
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Vim-with-me plugin shortcuts
-- Start and stop Vim-with-me sessions
vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- Clipboard operations
-- Greatest remap ever for pasting
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Next greatest remap ever for yanking
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Code Actions
vim.api.nvim_set_keymap('n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })

-- Miscellaneous
-- Cancel action in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")
-- Disable the Q command
vim.keymap.set("n", "Q", "<nop>")
-- Open tmux sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- Format buffer using LSP
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Navigation between diagnostics and locations
-- Next and previous compiler errors
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- Next and previous language server issues
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Search and replace
-- Search and replace the word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Code snippets
-- Quick error check snippet
vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

-- File navigation
-- Open packer configuration
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
-- Open make_it_rain function in CellularAutomaton
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- Reload Vim configuration
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- Keybinding to open Telescope to find files
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end,
    { desc = 'Open Telescope to find files' })

-- Keybinding to open Telescope to search for strings within files
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end,
    { desc = 'Open Telescope to grep for strings' })

-- Additional keybindings for project navigation and visual mode adjustments

-- Visual mode adjustments: Move selected block of text up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected text up' })

-- Debugger
vim.keymap.set("n", "<F5>", require("dap").continue)
vim.keymap.set("n", "<F9>", require("dap").toggle_breakpoint)
vim.keymap.set("n", "<F10>", require("dap").step_over)
vim.keymap.set("n", "<F11>", require("dap").step_into)

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
