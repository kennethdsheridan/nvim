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

-- NVIM DapBreakpoint
vim.keymap.set("n", "<F5>", require("dap").continue)
vim.keymap.set("n", "<F10>", require("dap").step_over)
vim.keymap.set("n", "<F11>", require("dap").step_into)
vim.keymap.set("n", "<F12>", require("dap").step_out)
vim.keymap.set("n", "<F9>", require("dap").step_back)
vim.keymap.set("n", "<F8>", require("dap").restart)
vim.keymap.set("n", "<Leader>b", require("dap").toggle_breakpoint)
vim.keymap.set("n", "<Leader>dt", require("dap").terminate)

-- Split horizontally with a terminal session on top
vim.keymap.set("n", "<leader>tt", function()
    -- "10sp" means "horizontal split 10 lines tall"
    -- "aboveleft" ensures it appears above the current window
    -- Then open the built-in terminal
    vim.cmd("aboveleft 10split | terminal")
end, { desc = "Open terminal (top horizontal split)" })

-- Projects keymap (Telescope Projects extension)
vim.keymap.set('n', '<leader>pp', function()
    require('telescope').extensions.projects.projects {}
end, {})

-- Rustacean vim mapping
vim.keymap.set("n", "<Leader>dt", function()
    vim.cmd('RustLsp testables')
end, { desc = "Debugger testables" })

-- Toggle autocomplete
vim.g.completion_active = true
vim.keymap.set('n', '<leader>tc', function()
    vim.g.completion_active = not vim.g.completion_active
    
    local cmp = require('cmp')
    
    if vim.g.completion_active then
        -- Enable automatic completion
        cmp.setup({ 
            enabled = true,
            completion = { 
                autocomplete = { cmp.TriggerEvent.TextChanged }
            }
        })
        print("Auto completion: enabled")
    else
        -- Disable nvim-cmp completely
        cmp.setup({ enabled = false })
        print("Completion: disabled")
    end
end, { desc = "Toggle completion" })


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
vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

-- File navigation
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>")
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

-- Markdown Preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

-- Peek Preview (safe loading)
vim.keymap.set("n", "<leader>pk", function() 
    local ok, peek = pcall(require, "peek")
    if ok then
        peek.open()
    else
        print("Peek.nvim not available - restart Neovim after plugin installation")
    end
end, { desc = "Peek Open" })

vim.keymap.set("n", "<leader>pc", function() 
    local ok, peek = pcall(require, "peek")
    if ok then
        peek.close()
    else
        print("Peek.nvim not available")
    end
end, { desc = "Peek Close" })

-- Reload Vim configuration
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

--------------------------------------------------------------------------------
--  Telescope Keymaps
--------------------------------------------------------------------------------
local telescope = require("telescope.builtin")

-- 1) Basic pickers
vim.keymap.set("n", "<leader>pf", telescope.find_files, { desc = "Telescope: Find Files" })
vim.keymap.set("n", "<C-p>", telescope.git_files, { desc = "Telescope: Git Files" })

vim.keymap.set("n", "<leader>ps", function()
    telescope.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Telescope: Grep String (prompt)" })

vim.keymap.set("n", "<leader>/", telescope.live_grep, { desc = "Telescope: Live Grep" })
vim.keymap.set("n", "<leader>pb", telescope.buffers, { desc = "Telescope: Buffers" })
vim.keymap.set("n", "<leader>po", telescope.oldfiles, { desc = "Telescope: Old Files" })
vim.keymap.set("n", "<leader>ph", telescope.help_tags, { desc = "Telescope: Help Tags" })

-- 2) LSP-related pickers
-- NOTE: These conflict with your <leader>gr, <leader>gd, <leader>gi> if you want them
-- the same you can replace or rename them below:
vim.keymap.set("n", "gr", telescope.lsp_references, { desc = "Telescope: LSP References" })
vim.keymap.set("n", "gd", telescope.lsp_definitions, { desc = "Telescope: LSP Definitions" })
vim.keymap.set("n", "gi", telescope.lsp_implementations, { desc = "Telescope: LSP Implementations" })

--------------------------------------------------------------------------------
-- Example: Additional Telescope keybindings that search project root
--------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>ff', function()
    telescope.find_files({ cwd = vim.fn.getcwd() })
end, { desc = 'Find files from project root' })

vim.keymap.set('n', '<leader>fg', function()
    telescope.live_grep({ cwd = vim.fn.getcwd() })
end, { desc = 'Live grep from project root' })

--------------------------------------------------------------------------------
-- DAP Icons Setup
--------------------------------------------------------------------------------
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
