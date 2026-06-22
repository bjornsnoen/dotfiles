return {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function()
        require('dressing').setup({
            select = {
                enabled = false,
                builtin = {
                    relative = 'editor',
                    border = 'rounded',
                },
            },
        })
    end,
}
