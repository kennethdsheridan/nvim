-- Set leader key
vim.g.mapleader = " "

-- Project navigation
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- GOTO declaration and documentation navigation (using standard LSP keys)
-- These will be handled by the LSP on_attach function instead
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
-- vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation hover" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Open Rust documentation for symbol under cursor
vim.keymap.set("n", "<leader>ro", function()
    local word = vim.fn.expand("<cword>")
    if not word or word == "" then
        print("No symbol under cursor")
        return
    end
    
    -- Rust keywords and std library items that should go to std docs
    local std_items = {
        -- Keywords
        "fn", "let", "mut", "const", "static", "if", "else", "match", "loop", "while", "for", "break", "continue",
        "return", "struct", "enum", "impl", "trait", "mod", "pub", "use", "extern", "crate", "self", "Self",
        "super", "async", "await", "move", "ref", "where", "type", "unsafe", "dyn", "macro_rules",
        
        -- Primitive types
        "i8", "i16", "i32", "i64", "i128", "isize", "u8", "u16", "u32", "u64", "u128", "usize",
        "f32", "f64", "bool", "char", "str", "slice", "array",
        
        -- Core std types
        "Vec", "HashMap", "HashSet", "BTreeMap", "BTreeSet", "VecDeque", "LinkedList", "BinaryHeap",
        "String", "Option", "Result", "Box", "Rc", "Arc", "Weak", "RefCell", "Cell", "UnsafeCell",
        "Cow", "Mutex", "RwLock", "Condvar", "Barrier", "Once", "OnceCell", "LazyLock",
        
        -- Std modules from your code
        "std", "borrow", "io", "os", "fd", "sync", "fs", "process", "thread", "time", "env", "path",
        "collections", "ffi", "mem", "ptr", "slice", "str", "fmt", "error", "result", "option",
        "convert", "ops", "cmp", "hash", "iter", "marker", "clone", "default", "any",
        
        -- IO types
        "File", "Read", "Write", "Seek", "BufRead", "BufReader", "BufWriter", "Cursor", "Stdin", "Stdout", "Stderr",
        "SeekFrom", "ErrorKind", "UnixStream", "TcpStream", "UdpSocket", "UnixListener", "TcpListener",
        
        -- Time types  
        "Duration", "Instant", "SystemTime", "UNIX_EPOCH",
        
        -- Threading types
        "JoinHandle", "ThreadId", "Builder", "LocalKey", "AccessError",
        
        -- Path types
        "Path", "PathBuf", "Component", "Components", "Ancestors", "StripPrefixError",
        
        -- OS types
        "AsFd", "AsRawFd", "BorrowedFd", "OwnedFd", "RawFd",
        
        -- Traits
        "Debug", "Display", "Clone", "Copy", "PartialEq", "Eq", "PartialOrd", "Ord", "Hash",
        "Iterator", "IntoIterator", "Extend", "FromIterator", "Collect", "ExactSizeIterator", "DoubleEndedIterator",
        "Default", "Drop", "Deref", "DerefMut", "Index", "IndexMut", "Add", "Sub", "Mul", "Div", "Rem",
        "AsRef", "AsMut", "From", "Into", "TryFrom", "TryInto", "ToString", "FromStr", "Send", "Sync",
        "Sized", "Unpin", "Future", "IntoFuture", "Stream", "Fn", "FnMut", "FnOnce",
        
        -- Error types
        "Error", "ErrorKind", "ParseIntError", "ParseFloatError", "ParseBoolError", "Utf8Error",
        
        -- Process types
        "Command", "Child", "ChildStdin", "ChildStdout", "ChildStderr", "ExitStatus", "ExitCode", "Stdio",
        
        -- Async types (std)
        "Waker", "Context", "Poll", "Pin", "Ready", "Pending",
        
        -- Commonly used macros
        "println", "print", "eprintln", "eprint", "dbg", "panic", "assert", "assert_eq", "assert_ne",
        "debug_assert", "debug_assert_eq", "debug_assert_ne", "todo", "unimplemented", "unreachable",
        "vec", "format", "include", "include_str", "include_bytes", "env", "option_env", "concat",
        "stringify", "file", "line", "column", "module_path"
    }
    
    local url
    local is_std_item = false
    
    -- Check if it's a std library item or keyword
    for _, item in ipairs(std_items) do
        if word == item then
            is_std_item = true
            break
        end
    end
    
    if is_std_item then
        -- For std items, go to the Rust standard library docs
        url = "https://doc.rust-lang.org/std/?search=" .. word
        print("Opening Rust std docs for: " .. word)
    else
        -- For other items, assume it's a crate and go to docs.rs
        url = "https://docs.rs/" .. word
        print("Opening docs.rs for: " .. word)
    end
    
    -- Try multiple methods to open browser on macOS
    local success = false
    
    -- Method 1: Try vim.ui.open (newer Neovim versions)
    if vim.ui.open then
        success = pcall(vim.ui.open, url)
    end
    
    -- Method 2: Try open command with full path
    if not success then
        local result = vim.fn.system("/usr/bin/open " .. vim.fn.shellescape(url))
        success = vim.v.shell_error == 0
    end
    
    -- Method 3: Try with explicit background execution
    if not success then
        vim.fn.jobstart({"/usr/bin/open", url}, {detach = true})
        success = true
    end
    
    if not success then
        print("Failed to open browser. URL copied to clipboard:")
        vim.fn.setreg("+", url)
        print(url)
    end
end, { desc = "Open Rust documentation for symbol under cursor" })

-- Octo.nvim GitHub PR Review
vim.keymap.set("n", "<leader>opl", "<cmd>Octo pr list<CR>", { desc = "List PRs" })
vim.keymap.set("n", "<leader>opv", "<cmd>Octo pr view<CR>", { desc = "View current PR" })
vim.keymap.set("n", "<leader>opc", "<cmd>Octo pr checkout<CR>", { desc = "Checkout PR" })
vim.keymap.set("n", "<leader>opr", "<cmd>Octo review start<CR>", { desc = "Start PR review" })
vim.keymap.set("n", "<leader>ops", "<cmd>Octo review submit<CR>", { desc = "Submit PR review" })
vim.keymap.set("n", "<leader>opa", "<cmd>Octo review comments<CR>", { desc = "View review comments" })
vim.keymap.set("n", "<leader>opd", "<cmd>Octo pr diff<CR>", { desc = "View PR diff" })
vim.keymap.set("n", "<leader>opm", "<cmd>Octo pr merge<CR>", { desc = "Merge PR" })

-- DAP (Debug Adapter Protocol) keybindings
local dap_ok, dap = pcall(require, "dap")
if dap_ok then
    -- Function keys for stepping
    vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
    vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
    vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
    vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
    vim.keymap.set("n", "<F9>", dap.step_back, { desc = "DAP: Step Back" })
    vim.keymap.set("n", "<F8>", dap.restart, { desc = "DAP: Restart" })
    
    -- Leader key mappings (using <Leader> as per DAP documentation)
    vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
    vim.keymap.set("n", "<Leader>B", function() 
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) 
    end, { desc = "DAP: Set Conditional Breakpoint" })
    vim.keymap.set("n", "<Leader>lp", function() 
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) 
    end, { desc = "DAP: Set Log Point" })
    vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
    vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "DAP: Run Last" })
    vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "DAP: Terminate" })
    vim.keymap.set("n", "<Leader>dc", dap.clear_breakpoints, { desc = "DAP: Clear All Breakpoints" })
    vim.keymap.set("n", "<Leader>dp", dap.pause, { desc = "DAP: Pause" })
    
    -- Hover and evaluation
    vim.keymap.set({"n", "v"}, "<Leader>dh", require("dap.ui.widgets").hover, { desc = "DAP: Hover" })
    vim.keymap.set({"n", "v"}, "<Leader>dv", require("dap.ui.widgets").preview, { desc = "DAP: Preview" })
    vim.keymap.set("n", "<Leader>df", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
    end, { desc = "DAP: Frames" })
    vim.keymap.set("n", "<Leader>ds", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
    end, { desc = "DAP: Scopes" })
    
    -- Alternative arrow key mappings (as suggested in docs)
    vim.keymap.set("n", "<Down>", dap.step_over, { desc = "DAP: Step Over" })
    vim.keymap.set("n", "<Right>", dap.step_into, { desc = "DAP: Step Into" })
    vim.keymap.set("n", "<Left>", dap.step_out, { desc = "DAP: Step Out" })
    vim.keymap.set("n", "<Up>", dap.restart_frame, { desc = "DAP: Restart Frame" })
end

-- Split horizontally with a terminal session on top
vim.keymap.set("n", "<leader>tm", function()
    -- "10sp" means "horizontal split 10 lines tall"
    -- "aboveleft" ensures it appears above the current window
    -- Then open the built-in terminal
    vim.cmd("aboveleft 10split | terminal")
end, { desc = "Open terminal (top horizontal split)" })

-- Trouble.nvim keymaps
vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble: Toggle diagnostics" })
vim.keymap.set("n", "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble: Buffer diagnostics" })
vim.keymap.set("n", "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Trouble: Symbols" })
vim.keymap.set("n", "<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "Trouble: LSP Definitions / references / ..." })
vim.keymap.set("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble: Location List" })
vim.keymap.set("n", "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Trouble: Quickfix List" })

-- Git worktree commands (manual since telescope extension has issues)
vim.keymap.set("n", "<leader>gw", function()
    -- Create a new buffer to show worktree list
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    
    -- Get worktree list
    local handle = io.popen('git worktree list')
    local result = handle:read('*a')
    handle:close()
    
    -- Split result into lines and set buffer content
    local lines = {}
    for line in result:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_name(buf, "Git Worktrees")
    
    -- Open in a split
    vim.cmd("split")
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_win_set_height(0, math.min(#lines + 2, 10))
    
    -- Make it read-only
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
end, { desc = "List git worktrees" })

vim.keymap.set("n", "<leader>gW", function()
    -- Prompt for branch name and path for new worktree
    local branch = vim.fn.input("Branch name: ")
    if branch ~= "" then
        local path = vim.fn.input("Worktree path: ", "../sfcompute-" .. branch)
        if path ~= "" then
            vim.cmd("!git worktree add " .. path .. " " .. branch)
        end
    end
end, { desc = "Create new git worktree" })

vim.keymap.set("n", "<leader>gc", function()
    -- Change to different worktree directory
    local path = vim.fn.input("Worktree path: ", "../")
    if path ~= "" and vim.fn.isdirectory(path) == 1 then
        vim.cmd("cd " .. path)
        print("Changed to: " .. path)
    else
        print("Invalid directory: " .. path)
    end
end, { desc = "Change to worktree directory" })

-- Projects keymap (Telescope Projects extension)
vim.keymap.set('n', '<leader>pp', function()
    require('telescope').extensions.projects.projects {}
end, {})

-- Rust test mapping
vim.keymap.set("n", "<Leader>dt", function()
    vim.cmd('!cargo test')
end, { desc = "Run Rust tests" })

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

-- Code Actions (handled in LSP on_attach)

-- Miscellaneous
-- Cancel action in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")
-- Disable the Q command
vim.keymap.set("n", "Q", "<nop>")
-- Open tmux sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- Format buffer using LSP (handled in LSP on_attach)

-- Navigation between diagnostics and locations
-- Next and previous compiler errors
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- Next and previous language server issues (using different keys to avoid LSP conflicts)
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz")

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
    vim.cmd("source ~/.config/nvim/init.lua")
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

-- 2) LSP-related pickers (using <leader> prefix to avoid conflicts)
vim.keymap.set("n", "<leader>lr", telescope.lsp_references, { desc = "Telescope: LSP References" })
vim.keymap.set("n", "<leader>ld", telescope.lsp_definitions, { desc = "Telescope: LSP Definitions" })
vim.keymap.set("n", "<leader>li", telescope.lsp_implementations, { desc = "Telescope: LSP Implementations" })

-- Toggle inlay hints (type hints)
vim.keymap.set("n", "<leader>ih", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
    print("Inlay hints " .. (enabled and "disabled" or "enabled"))
end, { desc = "Toggle inlay hints" })

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
-- OTTER LSP INTEGRATION
--------------------------------------------------------------------------------
-- Activate Otter for current buffer
vim.keymap.set('n', '<leader>oa', function()
    require('otter').activate()
    print("Otter activated for current buffer")
end, { desc = "Activate Otter LSP for embedded languages" })

-- Deactivate Otter for current buffer
vim.keymap.set('n', '<leader>od', function()
    require('otter').deactivate()
    print("Otter deactivated for current buffer")
end, { desc = "Deactivate Otter LSP" })

-- Show Otter status
vim.keymap.set('n', '<leader>os', function()
    local otter = require('otter')
    if otter then
        print("Otter is active")
    else
        print("Otter is not available")
    end
end, { desc = "Show Otter status" })

--------------------------------------------------------------------------------
-- DAP Icons Setup
--------------------------------------------------------------------------------
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
