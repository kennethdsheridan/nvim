-- DAP (Debug Adapter Protocol) Configuration
-- This file configures debug adapters for various languages

local dap = require('dap')

-- DAP UI Icons and Signs
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🟡', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '📝', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '➡️', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '❌', texthl = '', linehl = '', numhl = '' })

-- Python debugging with debugpy
dap.adapters.python = function(cb, config)
    if config.request == 'attach' then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or '127.0.0.1'
        cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
                source_filetype = 'python',
            },
        })
    else
        cb({
            type = 'executable',
            command = 'python',
            args = { '-m', 'debugpy.adapter' },
            options = {
                source_filetype = 'python',
            },
        })
    end
end

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                return cwd .. '/.venv/bin/python'
            else
                return '/usr/bin/python'
            end
        end,
    },
}

-- Rust debugging with lldb-vscode
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb'
}

dap.configurations.rust = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
    },
    {
        name = 'Launch (with args)',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
            local args_string = vim.fn.input('Arguments: ')
            return vim.split(args_string, " ")
        end,
        runInTerminal = false,
    },
    {
        name = 'Attach to process',
        type = 'lldb',
        request = 'attach',
        pid = require('dap.utils').pick_process,
        args = {},
    }
}

-- C/C++ debugging with lldb-vscode
dap.configurations.c = dap.configurations.rust
dap.configurations.cpp = dap.configurations.rust

-- JavaScript/TypeScript debugging with node-debug2
dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = { os.getenv('HOME') .. '/.local/share/nvim/dap/vscode-node-debug2/out/src/nodeDebug.js' },
}

dap.configurations.javascript = {
    {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
    },
    {
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require('dap.utils').pick_process,
    },
}

dap.configurations.typescript = dap.configurations.javascript

-- Go debugging with delve
dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
    }
}

dap.configurations.go = {
    {
        type = 'delve',
        name = 'Debug',
        request = 'launch',
        program = '${file}'
    },
    {
        type = 'delve',
        name = 'Debug test',
        request = 'launch',
        mode = 'test',
        program = '${file}'
    },
    {
        type = 'delve',
        name = 'Debug test (go.mod)',
        request = 'launch',
        mode = 'test',
        program = './${relativeFileDirname}'
    }
}

-- Lua debugging with local-lua-debugger-vscode
dap.adapters['local-lua'] = {
    type = 'executable',
    command = 'node',
    args = {
        os.getenv('HOME') .. '/.local/share/nvim/dap/local-lua-debugger-vscode/extension/debugAdapter.js'
    },
    enrich_config = function(config, on_config)
        if not config['extensionPath'] then
            local c = vim.deepcopy(config)
            c.extensionPath = os.getenv('HOME') .. '/.local/share/nvim/dap/local-lua-debugger-vscode/'
            on_config(c)
        else
            on_config(config)
        end
    end,
}

dap.configurations.lua = {
    {
        name = 'Current file (local-lua-debugger, lua)',
        type = 'local-lua',
        request = 'launch',
        cwd = '${workspaceFolder}',
        program = {
            lua = 'lua',
            file = '${file}',
        },
        args = {},
    },
}

-- DAP Event Listeners for enhanced experience
dap.listeners.after.event_initialized['dap_keymaps'] = function()
    -- Temporary keymaps during debug sessions
    local opts = { buffer = 0, silent = true }
    vim.keymap.set('n', '<F5>', dap.continue, opts)
    vim.keymap.set('n', '<F10>', dap.step_over, opts)
    vim.keymap.set('n', '<F11>', dap.step_into, opts)
    vim.keymap.set('n', '<F12>', dap.step_out, opts)
    print("DAP session started - Debug keymaps activated")
end

dap.listeners.before.event_terminated['dap_keymaps'] = function()
    -- Clean up temporary keymaps
    local opts = { buffer = 0 }
    vim.keymap.del('n', '<F5>', opts)
    vim.keymap.del('n', '<F10>', opts)
    vim.keymap.del('n', '<F11>', opts)
    vim.keymap.del('n', '<F12>', opts)
    print("DAP session ended - Debug keymaps deactivated")
end

dap.listeners.before.event_exited['dap_keymaps'] = function()
    -- Clean up temporary keymaps
    local opts = { buffer = 0 }
    vim.keymap.del('n', '<F5>', opts)
    vim.keymap.del('n', '<F10>', opts)
    vim.keymap.del('n', '<F11>', opts)
    vim.keymap.del('n', '<F12>', opts)
    print("DAP session exited - Debug keymaps deactivated")
end

-- Auto-open REPL when debugging starts
dap.listeners.after.event_initialized['dap_repl'] = function()
    dap.repl.open()
end

-- Helper function to compile Rust project before debugging
local function compile_rust_debug()
    local handle = io.popen('cargo build 2>&1')
    local result = handle:read('*a')
    handle:close()
    
    if vim.v.shell_error == 0 then
        print("Rust project compiled successfully")
        return true
    else
        print("Rust compilation failed:")
        print(result)
        return false
    end
end

-- Custom DAP commands
vim.api.nvim_create_user_command('DapCompileRust', function()
    compile_rust_debug()
end, { desc = 'Compile Rust project for debugging' })

vim.api.nvim_create_user_command('DapRustDebug', function()
    if compile_rust_debug() then
        dap.continue()
    end
end, { desc = 'Compile and start Rust debugging' })

-- Function to set conditional breakpoint with common conditions
local function set_conditional_breakpoint()
    local conditions = {
        'variable == value',
        'variable != nil',
        'variable > 0',
        'variable < 10',
        'variable.is_some()',
        'variable.is_err()',
    }
    
    vim.ui.select(conditions, {
        prompt = 'Select condition template or type custom:',
        format_item = function(item)
            return item
        end,
    }, function(choice)
        if choice then
            local condition = vim.fn.input('Breakpoint condition: ', choice)
            if condition ~= '' then
                dap.set_breakpoint(condition)
            end
        end
    end)
end

-- Custom conditional breakpoint command
vim.api.nvim_create_user_command('DapConditionalBreakpoint', set_conditional_breakpoint, 
    { desc = 'Set conditional breakpoint with templates' })

-- Function to quickly debug the current Rust test
local function debug_rust_test()
    local line = vim.api.nvim_get_current_line()
    local test_name = line:match('#%[test%]%s*fn%s+([%w_]+)')
    
    if not test_name then
        -- Look for test in previous lines
        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        for i = current_line, math.max(1, current_line - 10), -1 do
            local prev_line = vim.api.nvim_buf_get_lines(0, i-1, i, false)[1] or ""
            test_name = prev_line:match('fn%s+([%w_]+)')
            if test_name and vim.api.nvim_buf_get_lines(0, i-2, i-1, false)[1]:match('#%[test%]') then
                break
            end
            test_name = nil
        end
    end
    
    if test_name then
        dap.run({
            type = 'lldb',
            request = 'launch',
            name = 'Debug test: ' .. test_name,
            program = function()
                vim.fn.system('cargo test --no-run ' .. test_name)
                local output = vim.fn.system('find target/debug/deps -name "*' .. vim.fn.expand('%:t:r') .. '*" -type f -executable | head -1')
                return vim.trim(output)
            end,
            args = { test_name, '--exact' },
            cwd = vim.fn.getcwd(),
            stopOnEntry = false,
        })
    else
        print("No test function found near cursor")
    end
end

vim.api.nvim_create_user_command('DapRustTest', debug_rust_test, 
    { desc = 'Debug Rust test under cursor' })