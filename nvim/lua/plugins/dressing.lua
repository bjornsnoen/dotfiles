return {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function()
        require('dressing').setup({
            select = {
                backend = { 'builtin' },
                builtin = {
                    relative = 'editor',
                    border = 'rounded',
                },
            },
        })
    end,
}
