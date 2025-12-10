return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim',
        'haydenmeade/neotest-jest',
        'codymikol/neotest-kotlin',
        'nvim-neotest/neotest-python',
        'olimorris/neotest-phpunit',
        { 'marilari88/neotest-vitest' },
        { 'thenbe/neotest-playwright', branch = 'master' },
    },
    keys = {
        { 'tt', function() require('neotest').run.run() end, desc = 'Test nearest' },
        {
            'td',
            function()
                ---@diagnostic disable-next-line: missing-parameter
                require('neotest').run.run({ strategy = 'dap' })
            end,
            desc = 'Debug nearest test',
        },
        {
            'Tt',
            function()
                ---@diagnostic disable-next-line: missing-parameter
                require('neotest').run.run({ vim.fn.expand('%') })
            end,
            desc = 'Test current file',
        },
        {
            'Td',
            function()
                ---@diagnostic disable-next-line: missing-parameter
                require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })
            end,
            desc = 'Debug current file',
        },
        {
            'ta',
            function()
                local neotest = require('neotest')
                neotest.run.run({ suite = true })
                neotest.summary.toggle()
            end,
            desc = 'Test all and open summary',
        },
        {
            'Ta',
            function()
                ---@diagnostic disable-next-line: missing-parameter
                require('neotest').run.run({ suite = true, strategy = 'dap' })
            end,
            desc = 'Debug test suite',
        },
        { '<Leader>t', function() require('neotest').run.run_last() end, desc = 'Rerun last test' },
        { '<C-t>', function() require('neotest').summary.toggle() end, desc = 'Toggle test summary' },
        {
            'to',
            function()
                require('neotest').output.open({ enter = true })
            end,
            desc = 'Open test output',
        },
    },
    config = function()
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
                require('neotest-kotlin'),
                require('neotest-phpunit'),
            },
        })
    end,
}
