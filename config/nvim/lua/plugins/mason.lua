return {
    {
        'williamboman/mason.nvim',
        event = 'VeryLazy',
        config = true,
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
        event = 'VeryLazy',
        opts = {
            ensure_installed = {
                'prettierd',
                'black',
                'djlint',
                'isort',
                'cspell',
                'stylua',
                'debugpy',
                'yamlls',
                'phpcbf',
                'pylsp',
                'sonarlint-language-server',
                'kotlin-lsp',
            },
        },
    },
}
