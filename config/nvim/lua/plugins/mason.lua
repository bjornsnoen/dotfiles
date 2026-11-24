return {
    {
        'williamboman/mason.nvim',
        event = 'VeryLazy',
        config = true,
        opts = {
            registries = {
                'github:mason-org/mason-registry',
                -- Match roslyn.nvim's server requirements using its recommended registry.
                'github:Crashdummyy/mason-registry',
            },
        },
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
                'roslyn',
            },
        },
    },
}
