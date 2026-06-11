return {
    'romus204/tree-sitter-manager.nvim',
    config = function()
        require('tree-sitter-manager').setup({
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
            auto_install = true,
        })
    end,
}
