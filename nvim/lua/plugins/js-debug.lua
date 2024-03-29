return {
    'mxsdev/nvim-dap-vscode-js',
    dependencies = {
        {
            'mfussenegger/nvim-dap',
        },
        {
            'microsoft/vscode-js-debug',
            build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
            tag = 'v1.74.1',
        },
    },
    config = function()
        local vscodeJsDebugPath = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug'

        require('dap-vscode-js').setup({
            adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
            debugger_path = vscodeJsDebugPath,
        })
        for _, language in ipairs({ 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }) do
            require('dap').configurations[language] = {
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Launch file',
                    program = '${file}',
                    cwd = '${workspaceFolder}',
                },
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Debug Jest Tests',
                    -- trace = true, -- include debugger info
                    runtimeExecutable = 'node',
                    runtimeArgs = {
                        './node_modules/jest/bin/jest.js',
                        '--runInBand',
                    },
                    rootPath = '${workspaceFolder}',
                    cwd = '${workspaceFolder}',
                    console = 'integratedTerminal',
                    internalConsoleOptions = 'neverOpen',
                },
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Debug Vite Tests',
                    -- trace = true, -- include debugger info
                    runtimeExecutable = 'node',
                    runtimeArgs = {
                        './node_modules/.bin/vitest',
                    },
                    rootPath = '${workspaceFolder}',
                    cwd = '${workspaceFolder}',
                    console = 'integratedTerminal',
                    internalConsoleOptions = 'neverOpen',
                },
            }
        end
        require('dap.ext.vscode').load_launchjs(nil, {
            ['pwa-chrome'] = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        })
    end,
}
