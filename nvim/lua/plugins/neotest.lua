return {
    'nvim-neotest/neotest',
    requires = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim',
        'haydenmeade/neotest-jest',
    },
    config = function()
        local neotest = require('neotest')
        neotest.setup({
            adapters = {
                require('neotest-jest')({
                    jestCommand = 'npm test --',
                    cwd = function(path)
                        return vim.fn.getcwd()
                    end,
                }),
            },
        })
        vim.keymap.set('n', '<Leader>t', function()
            neotest.run.run()
        end)
        vim.keymap.set('n', '<Leader>T', function()
            ---@diagnostic disable-next-line: missing-parameter
            neotest.run.run(vim.fn.expand('%'))
        end)
        vim.keymap.set('n', '<Leader>dt', function()
            ---@diagnostic disable-next-line: missing-parameter
            neotest.run.run({ strategy = 'dap' })
        end)
        vim.keymap.set('n', '<Leader>at', function()
            neotest.run.run({ suite = true })
            neotest.summary.toggle()
        end)
        vim.keymap.set('n', '<Leader>da', function()
            neotest.run.run({ suite = true, strategy = 'dap' })
        end)
        vim.keymap.set('n', '<C-t>', neotest.summary.toggle)
    end,
}
