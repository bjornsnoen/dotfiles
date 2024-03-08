return {
    {
        'williamboman/mason.nvim',
        config = true,
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
        opts = {
            ensure_installed = {
                'prettierd',
                'black',
                'isort',
                'cspell',
                'stylua',
                'debugpy',
            },
        },
    },
}
