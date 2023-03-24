return {
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        requires = {
            'williamboman/mason.nvim',
        },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'tsserver',
                    'pyright',
                    'lua_ls',
                    'jsonls',
                    'yamlls',
                    'taplo',
                    'eslint',
                    'omnisharp',
                },
            })
        end,
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        requires = {
            'williamboman/mason.nvim',
        },
        config = function()
            require('mason-tool-installer').setup({
                ensure_installed = {
                    'prettierd',
                    'black',
                    'isort',
                    'cspell',
                    'stylua',
                    'debugpy',
                },
            })
        end,
    },
}
