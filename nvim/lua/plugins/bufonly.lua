return {
    'vim-scripts/BufOnly.vim',
    config = function()
        vim.keymap.set('n', '<Leader>q', ':bdelete!<CR>', { silent = true })
        vim.keymap.set('n', '<Leader>Q', ':BufOnly!<CR>', { silent = true })
        vim.keymap.set('n', '<F16>', ':BufOnly<CR>', { silent = true })
    end,
}
