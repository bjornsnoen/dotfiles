return {
    'mg979/vim-visual-multi',
    event = 'VeryLazy',
    init = function()
        vim.g.VM_maps = {
            ['Select Cursor Down'] = '<C-j>',
        }
    end,
}
