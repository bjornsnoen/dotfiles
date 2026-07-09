return {
    {
        'willothy/flatten.nvim',
        opts = {
            window = {
                open = 'alternate',
            },
            hooks = {
                pre_open = function()
                    -- Close the floating terminal
                    -- pcall(vim.api.nvim_command, 'FloatermHide')
                    vim.cmd('silent! FloatermHide!')
                end,
            },
        },
        lazy = false,
        priority = 1001,
    },
}
