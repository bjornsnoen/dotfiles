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
                ensure_installed = { 'tsserver', 'pyright', 'sumneko_lua', 'eslint_d', 'prettierd', 'black', 'isort' },
            })
        end,
    },
}
