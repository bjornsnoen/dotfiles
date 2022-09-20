return {
    'mxsdev/nvim-dap-vscode-js',
    requires = {
        {
            'mfussenegger/nvim-dap',
        },
        {
            'microsoft/vscode-js-debug',
            opt = true,
            run = 'npm install --legacy-peer-deps && npm run compile',
        },
    },
    run = 'npm install --legacy-peer-deps && npm run compile',
    config = function()
        ---@diagnostic disable-next-line: param-type-mismatch
        require('dap-vscode-js').setup({
            adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
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
            }
        end
        require('dap.ext.vscode').load_launchjs(nil, {
            ['pwa-chrome'] = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        })
    end,
}
