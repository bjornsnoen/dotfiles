return {
    'mfussenegger/nvim-dap',
    config = function()
        local dap = require('dap')
        vim.keymap.set('n', '<F5>', dap.continue)
        vim.keymap.set('n', '<F17>', dap.run_last)
        vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
        vim.keymap.set('n', '<F10>', dap.step_over)
        vim.keymap.set('n', '<F11>', dap.step_into)
        vim.keymap.set('n', '<F12>', dap.step_out)

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
    end,
}
