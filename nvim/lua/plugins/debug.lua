return {
    'mfussenegger/nvim-dap',
    keys = {
        { '<F5>', function() require('dap').continue() end, desc = 'DAP continue' },
        { '<F17>', function() require('dap').run_last() end, desc = 'DAP run last' },
        { '<F9>', function() require('dap').toggle_breakpoint() end, desc = 'DAP toggle breakpoint' },
        { '<F10>', function() require('dap').step_over() end, desc = 'DAP step over' },
        { '<F11>', function() require('dap').step_into() end, desc = 'DAP step into' },
        { '<F12>', function() require('dap').step_out() end, desc = 'DAP step out' },
    },
    config = function()
        local dap = require('dap')

        dap.adapters.php = {
            type = 'executable',
            command = 'node',
            args = { '/home/bjorn/src/vscode-php-debug/out/phpDebug.js' },
        }

        dap.configurations.php = {
            {
                type = 'php',
                request = 'launch',
                name = 'Listen for Xdebug',
                port = 9003,
                stopOnEntry = false,
            },
        }

        local cpptoolsPath = vim.fn.stdpath('data') .. '/mason/packages/cpptools/extension/'
        dap.adapters.cppdbg = {
            type = 'executable',
            id = 'cppdbg',
            command = cpptoolsPath .. 'debugAdapters/bin/OpenDebugAD7',
        }

        dap.configurations.cpp = {
            {
                name = 'Launch file',
                type = 'cppdbg',
                request = 'launch',
                setupCommands = {
                    {
                        text = '-enable-pretty-printing',
                        description = 'enable pretty printing',
                        ignoreFailures = false,
                    },
                },
                program = function()
                    -- If the main file exists, use that as the defaults
                    if vim.fn.filereadable('main') == 1 then
                        return vim.fn.getcwd() .. '/main'
                    end
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                before = function()
                    vim.fn.jobstart('make', {
                        stdout_buffered = true,
                        stderr_buffered = true,
                        on_stdout = function(_, data)
                            if data then
                                vim.notify(table.concat(data, '\n'), vim.log.levels.INFO)
                            end
                        end,
                        on_stderr = function(_, data)
                            if data then
                                vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR)
                            end
                        end,
                    })
                end,
                cwd = '${workspaceFolder}',
            },
            {
                name = 'Attach to gdbserver :1234',
                type = 'cppdbg',
                request = 'launch',
                MIMode = 'gdb',
                miDebuggerServerAddress = 'localhost:1234',
                miDebuggerPath = '/usr/bin/gdb',
                cwd = '${workspaceFolder}',
                program = function()
                    if vim.fn.filereadable('main') == 1 then
                        return vim.fn.getcwd() .. '/main'
                    end
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
            },
        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp
    end,
}
