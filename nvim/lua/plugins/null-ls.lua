return {
    'nvimtools/none-ls.nvim',
    event = { 'BufEnter' },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'lewis6991/gitsigns.nvim',
        'ThePrimeagen/refactoring.nvim',
    },
    config = function()
        local null_ls = require('null-ls')
        require('gitsigns').setup()
        require('refactoring').setup({})
        local augroup = vim.api.nvim_create_augroup('NoneLsFormatting', {})
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
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
                null_ls.builtins.formatting.djlint.with({
                    filetypes = {
                        'twig',
                    },
                }),
                null_ls.builtins.formatting.phpcbf,
                null_ls.builtins.code_actions.refactoring,
                null_ls.builtins.code_actions.gitsigns,
            },
            on_attach = function(client, bufnr)
                if client.name ~= 'null-ls' then
                    return
                end

                local function format_with_null_ls()
                    local params = vim.lsp.util.make_formatting_params({})
                    local result = client.request_sync('textDocument/formatting', params, 5000, bufnr)
                    if result and result.result then
                        vim.lsp.util.apply_text_edits(result.result, bufnr, client.offset_encoding)
                    end
                end

                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.api.nvim_buf_call(bufnr, format_with_null_ls)
                    end,
                })
            end,
        })
    end,
}
