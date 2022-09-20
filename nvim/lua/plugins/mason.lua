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
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim',
        },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'tsserver',
                    'pyright',
                    'sumneko_lua',
                    'jsonls',
                    'yamlls',
                    'taplo',
                    'eslint',
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
                    'eslint_d',
                    'prettierd',
                    'black',
                    'isort',
                    'cspell',
                    'stylua',
                },
            })
        end,
    },
}
