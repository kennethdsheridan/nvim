local M = {}

-- Function to search Rust documentation
function M.search_rust_docs()
    local word = vim.fn.expand('<cword>')
    if word == '' then
        vim.notify("No word under cursor", vim.log.levels.WARN)
        return
    end
    
    local url = 'https://doc.rust-lang.org/std/?search=' .. vim.fn.escape(word, '#')
    vim.fn.system('open ' .. vim.fn.shellescape(url))
    vim.notify("Opening Rust docs for: " .. word)
end

-- Function to search docs.rs
function M.search_docs_rs()
    local word = vim.fn.expand('<cword>')
    if word == '' then
        vim.notify("No word under cursor", vim.log.levels.WARN)
        return
    end
    
    local url = 'https://docs.rs/releases/search?query=' .. vim.fn.escape(word, '#')
    vim.fn.system('open ' .. vim.fn.shellescape(url))
    vim.notify("Searching docs.rs for: " .. word)
end

-- Function to open specific std module documentation
function M.open_module_docs()
    local word = vim.fn.expand('<cword>')
    if word == '' then
        vim.notify("No word under cursor", vim.log.levels.WARN)
        return
    end
    
    -- Try to determine if it's a known std module
    local std_modules = {
        'vec', 'option', 'result', 'string', 'str', 'slice', 'hash', 'fmt',
        'io', 'fs', 'path', 'env', 'process', 'thread', 'sync', 'time',
        'collections', 'ops', 'mem', 'ptr', 'clone', 'cmp', 'iter'
    }
    
    local url
    for _, module in ipairs(std_modules) do
        if word:lower():match('^' .. module) then
            url = 'https://doc.rust-lang.org/std/' .. module .. '/index.html'
            break
        end
    end
    
    if not url then
        -- Default to searching
        url = 'https://doc.rust-lang.org/std/?search=' .. vim.fn.escape(word, '#')
    end
    
    vim.fn.system('open ' .. vim.fn.shellescape(url))
    vim.notify("Opening Rust docs for: " .. word)
end

-- Function to use telescope to search through common Rust std items
function M.telescope_rust_docs()
    local ok, telescope = pcall(require, 'telescope')
    if not ok then
        vim.notify("Telescope not available", vim.log.levels.ERROR)
        return
    end
    
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    
    -- Common Rust std items
    local items = {
        { name = "Vec", url = "https://doc.rust-lang.org/std/vec/struct.Vec.html" },
        { name = "HashMap", url = "https://doc.rust-lang.org/std/collections/struct.HashMap.html" },
        { name = "Option", url = "https://doc.rust-lang.org/std/option/enum.Option.html" },
        { name = "Result", url = "https://doc.rust-lang.org/std/result/enum.Result.html" },
        { name = "String", url = "https://doc.rust-lang.org/std/string/struct.String.html" },
        { name = "str", url = "https://doc.rust-lang.org/std/primitive.str.html" },
        { name = "slice", url = "https://doc.rust-lang.org/std/primitive.slice.html" },
        { name = "Iterator", url = "https://doc.rust-lang.org/std/iter/trait.Iterator.html" },
        { name = "io::Read", url = "https://doc.rust-lang.org/std/io/trait.Read.html" },
        { name = "io::Write", url = "https://doc.rust-lang.org/std/io/trait.Write.html" },
        { name = "fs", url = "https://doc.rust-lang.org/std/fs/index.html" },
        { name = "thread", url = "https://doc.rust-lang.org/std/thread/index.html" },
        { name = "Arc", url = "https://doc.rust-lang.org/std/sync/struct.Arc.html" },
        { name = "Mutex", url = "https://doc.rust-lang.org/std/sync/struct.Mutex.html" },
        { name = "RefCell", url = "https://doc.rust-lang.org/std/cell/struct.RefCell.html" },
        { name = "Box", url = "https://doc.rust-lang.org/std/boxed/struct.Box.html" },
        { name = "Rc", url = "https://doc.rust-lang.org/std/rc/struct.Rc.html" },
        { name = "Path", url = "https://doc.rust-lang.org/std/path/struct.Path.html" },
        { name = "PathBuf", url = "https://doc.rust-lang.org/std/path/struct.PathBuf.html" },
        { name = "env", url = "https://doc.rust-lang.org/std/env/index.html" },
        { name = "process", url = "https://doc.rust-lang.org/std/process/index.html" },
        { name = "fmt::Display", url = "https://doc.rust-lang.org/std/fmt/trait.Display.html" },
        { name = "fmt::Debug", url = "https://doc.rust-lang.org/std/fmt/trait.Debug.html" },
        { name = "Clone", url = "https://doc.rust-lang.org/std/clone/trait.Clone.html" },
        { name = "Copy", url = "https://doc.rust-lang.org/std/marker/trait.Copy.html" },
        { name = "Send", url = "https://doc.rust-lang.org/std/marker/trait.Send.html" },
        { name = "Sync", url = "https://doc.rust-lang.org/std/marker/trait.Sync.html" },
    }
    
    pickers.new({}, {
        prompt_title = 'Rust Standard Library',
        finder = finders.new_table {
            results = items,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name,
                }
            end
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    vim.fn.system('open ' .. vim.fn.shellescape(selection.value.url))
                    vim.notify("Opening docs for: " .. selection.value.name)
                end
            end)
            return true
        end,
    }):find()
end

-- Setup keymaps
function M.setup()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set("n", "<leader>ro", M.search_rust_docs, 
                vim.tbl_extend("force", opts, { desc = "Search Rust std docs" }))
            vim.keymap.set("n", "<leader>rO", M.telescope_rust_docs, 
                vim.tbl_extend("force", opts, { desc = "Browse Rust std library" }))
            vim.keymap.set("n", "<leader>rs", M.search_docs_rs, 
                vim.tbl_extend("force", opts, { desc = "Search docs.rs" }))
        end
    })
end

return M