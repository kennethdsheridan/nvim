-- Disable blinking cursor
vim.opt.guicursor = ""

-- Line number display
vim.opt.nu = true -- Enable line numbers
vim.opt.relativenumber = true -- Enable relative line numbers

-- Indentation settings
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 4 -- Number of spaces that a <Tab> counts for while editing
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.expandtab = true -- Convert tabs to spaces

-- Smart indenting for new lines
vim.opt.smartindent = true

-- Text display options
vim.opt.wrap = false -- Disable line wrapping

-- File backup options
vim.opt.swapfile = false -- Disable swap file creation
vim.opt.backup = false -- Disable backup file creation
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Set undo directory
vim.opt.undofile = true -- Enable persistent undo

-- Search options
vim.opt.hlsearch = false -- Disable search highlight
vim.opt.incsearch = true -- Enable incremental search

-- Color scheme options
vim.opt.termguicolors = true -- Enable true color support

-- Scrolling options
vim.opt.scrolloff = 8 -- Minimum number of lines to keep above and below the cursor
vim.opt.signcolumn = "yes" -- Always show the sign column to avoid text shifting

-- Special characters in filenames
vim.opt.isfname:append("@-@") -- Allow '@' in filenames

-- Performance options
vim.opt.updatetime = 50 -- Faster completion (4000ms default)

-- Code style options
vim.opt.colorcolumn = "100" -- Highlight the 80th column
