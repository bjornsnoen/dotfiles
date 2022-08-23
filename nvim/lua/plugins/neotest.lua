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
                    cwd = function(_)
                        return vim.fn.getcwd()
                    end,
                }),
            },
        })
        vim.keymap.set('n', 'tt', neotest.run.run)
        vim.keymap.set('n', 'td', function()
            ---@diagnostic disable-next-line: missing-parameter
            neotest.run.run({ strategy = 'dap' })
        end)
        vim.keymap.set('n', 'Tt', function()
            ---@diagnostic disable-next-line: missing-parameter
            neotest.run.run({ vim.fn.expand('%') })
        end)
        vim.keymap.set('n', 'Td', function()
            ---@diagnostic disable-next-line: missing-parameter
            neotest.run.run({ vim.fn.expand('%'), strategy = 'dap' })
        end)
        vim.keymap.set('n', 'ta', function()
            neotest.run.run({ suite = true })
            neotest.summary.toggle()
        end)
        vim.keymap.set('n', 'Ta', function()
            neotest.run.run({ suite = true, strategy = 'dap' })
        end)

        vim.keymap.set('n', '<Leader>t', neotest.run.run_last)
        vim.keymap.set('n', '<C-t>', neotest.summary.toggle)
    end,
}
