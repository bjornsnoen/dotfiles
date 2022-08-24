return {
    'vim-scripts/BufOnly.vim',
    config = function()
        vim.keymap.set('n', '<Leader>q', ':bdelete!<CR>')
        vim.keymap.set('n', '<Leader>Q', ':BufOnly!<CR>')
        vim.keymap.set('n', '<F16>', ':BufOnly<CR>')
    end,
}
