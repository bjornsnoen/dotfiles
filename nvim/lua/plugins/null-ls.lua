return {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'lewis6991/gitsigns.nvim',
        'ThePrimeagen/refactoring.nvim',
    },
    config = function()
        local null_ls = require('null-ls')
        require('gitsigns').setup()
        require('refactoring').setup({})
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort.with({
                    extra_args = {
                        '--profile',
                        'black',
                    },
                }),
                null_ls.builtins.formatting.prettierd.with({
                    -- Remove markdown
                    filetypes = {
                        'javascript',
                        'javascriptreact',
                        'typescript',
                        'typescriptreact',
                        'vue',
                        'css',
                        'scss',
                        'less',
                        'html',
                        'json',
                        'jsonc',
                        'yaml',
                        'markdown.mdx',
                        'graphql',
                        'handlebars',
                        'svelte',
                    },
                }),
                null_ls.builtins.code_actions.refactoring,
                null_ls.builtins.code_actions.gitsigns,
            },
        })
    end,
}
