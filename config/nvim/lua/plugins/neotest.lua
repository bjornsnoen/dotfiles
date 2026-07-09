return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'haydenmeade/neotest-jest',
        'codymikol/neotest-kotlin',
        'nvim-neotest/neotest-python',
        'olimorris/neotest-phpunit',
        'nsidorenco/neotest-vstest',
        { 'marilari88/neotest-vitest' },
        { 'thenbe/neotest-playwright', branch = 'master' },
    },
    event = {
        'BufReadPost *.test.*',
        'BufNewFile *.test.*',
        'BufReadPost *.spec.*',
        'BufNewFile *.spec.*',
        'BufReadPost test_*.py',
        'BufReadPost *_test.py',
        'BufReadPost *Test.kt',
        'BufReadPost *Test.php',
        'BufReadPost *Test.cs',
        'BufReadPost *Tests.cs',
    },
    keys = {
        {
            'tt',
            function()
                require('neotest').run.run()
            end,
            desc = 'Test nearest',
        },
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
        {
            '<Leader>t',
            function()
                require('neotest').run.run_last()
            end,
            desc = 'Rerun last test',
        },
        {
            '<C-t>',
            function()
                require('neotest').summary.toggle()
            end,
            desc = 'Toggle test summary',
        },
        {
            'to',
            function()
                require('neotest').output.open({ enter = true })
            end,
            desc = 'Open test output',
        },
    },
    config = function()
        -- Register tsx/typescript language mappings for treesitter.
        -- Neotest's subprocess (started with -u NONE) can't resolve these,
        -- and its error handling is broken (nio future.wait() throws instead
        -- of returning errors, making the fallback dead code). Disabling the
        -- subprocess forces in-process parsing which works correctly.
        --
        -- This is temporary, remove after neotest is updated upstream
        vim.treesitter.language.register('tsx', 'typescriptreact')
        vim.treesitter.language.register('typescript', 'typescript')

        local neotest = require('neotest')
        require('neotest.lib').subprocess.enabled = function()
            return false
        end

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
                require('neotest-vstest'),
            },
        })
    end,
}
