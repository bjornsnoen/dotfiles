return {
    'https://gitlab.com/schrieveslaach/sonarlint.nvim.git',
    event = { 'BufEnter', 'BufNewFile' },
    dependencies = {
        'neovim/nvim-lspconfig',
        'lewis6991/gitsigns.nvim',
    },
    config = function()
        require('sonarlint').setup({
            server = {
                cmd = {
                    'sonarlint-language-server',
                    '-stdio',
                    '-analyzers',
                    vim.fn.expand('$MASON/share/sonarlint-analyzers/sonarpython.jar'),
                    vim.fn.expand('$MASON/share/sonarlint-analyzers/sonarcfamily.jar'),
                    vim.fn.expand('$MASON/share/sonarlint-analyzers/sonarjava.jar'),
                    vim.fn.expand('$MASON/share/sonarlint-analyzers/sonarjs.jar'),
                    vim.fn.expand('$MASON/share/sonarlint-analyzers/sonarphp.jar'),
                    vim.fn.expand('$MASON/share/sonarlint-analyzers/sonargo.jar'),
                    vim.fn.expand('$MASON/share/sonarlint-analyzers/sonarhtml.jar'),
                    vim.fn.expand('$MASON/share/sonarlint-analyzers/sonarxml.jar'),
                    vim.fn.expand('$MASON/share/sonarlint-analyzers/sonariac.jar'),
                    vim.fn.expand('$MASON/share/sonarlint-analyzers/sonarcsharp.jar'),
                },
            },
            filetypes = {
                'c',
                'cpp',
                'cs',
                'dockerfile',
                'go',
                'html',
                'java',
                'javascript',
                'javascriptreact',
                'php',
                'python',
                'typescript',
                'typescriptreact',
                'xml',
            },
        })
    end,
}
