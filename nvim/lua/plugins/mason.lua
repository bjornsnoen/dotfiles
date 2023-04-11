return {
    {
        'williamboman/mason.nvim',
        config = true,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
        opts = {
            ensure_installed = {
                'tsserver',
                'pyright',
                'lua_ls',
                'jsonls',
                'yamlls',
                'taplo',
                'eslint',
                'omnisharp',
                'tailwindcss',
            },
        },
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
