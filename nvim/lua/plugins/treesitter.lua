return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufEnter' },
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'javascript',
                'typescript',
                'python',
                'lua',
                'bash',
                'css',
                'go',
                'html',
                'markdown',
                'json',
                'php',
                'scss',
                'vim',
                'tsx',
                'svelte',
                'prisma',
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    node_incremental = 'v',
                    scope_incremental = '<C-v>',
                    node_decremental = 'V',
                },
            },
        })
    end,
}
