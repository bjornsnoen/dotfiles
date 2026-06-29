return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
        local web_filetypes = {
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
        }

        local formatters_by_ft = {
            lua = { 'stylua' },
            twig = { 'djlint' },
            php = { 'phpcbf' },
        }

        for _, ft in ipairs(web_filetypes) do
            formatters_by_ft[ft] = { 'oxfmt', 'prettierd', stop_after_first = true }
        end

        require('conform').setup({
            formatters_by_ft = formatters_by_ft,
            format_on_save = {
                timeout_ms = 5000,
            },
            formatters = {
                oxfmt = {
                    require_cwd = true,
                },
            },
        })
    end,
}
