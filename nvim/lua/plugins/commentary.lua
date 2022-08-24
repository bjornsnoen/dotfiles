return {
    'tpope/vim-commentary',
    config = function()
        -- Toggle comment for line under cursor
        -- vim.keymap.set('n', '<Leader>/', "gcc")
        -- Toggle comment for visual selection, with reselect
        -- vim.keymap.set('x', '<Leader>/', "gcgv")

        vim.cmd([[
        " Toggle comment for line under cursor
        nmap <Leader>/ gcc
        " Toggle comment for visual selection, with reselect
        xmap <Leader>/ gcgv
        ]])
    end,
}
