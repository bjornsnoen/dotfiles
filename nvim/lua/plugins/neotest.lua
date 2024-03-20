return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim',
        'haydenmeade/neotest-jest',
        'nvim-neotest/neotest-python',
        'olimorris/neotest-phpunit',
        { 'marilari88/neotest-vitest', dev = true },
        { 'thenbe/neotest-playwright', branch = 'master' },
    },
    init = function()
        local neotest = require('neotest')
        neotest.setup({
            quickfix = {
                enabled = false,
            },
            adapters = {
                require('neotest-jest')({
                    jestCommand = 'npm test --',
                    cwd = function(_)
                        return vim.fn.getcwd()
                    end,
                }),
                require('neotest-vitest')({
                    vitestCommand = 'npm test --',
                    cwd = function(_)
                        return vim.fn.getcwd()
                    end,
                }),
                require('neotest-python')({
                    dap = { justMyCode = false },
                }),
                require('neotest-playwright').adapter({
                    options = {
                        persist_project_selection = true,
                        enable_dynamic_test_discovery = true,
                        cwd = function(_)
                            return vim.fn.getcwd()
                        end,
                        env = {
                            NEXT_PUBLIC_THEME = 'antonsport',
                            NEXT_PUBLIC_SITE_URL = 'http://antonsport.localhost',
                        },
                    },
                }),
                require('neotest-phpunit'),
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
        vim.keymap.set('n', 'to', function()
            neotest.output.open({ enter = true })
        end)
    end,
}
