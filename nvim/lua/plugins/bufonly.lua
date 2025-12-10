return {
    'vim-scripts/BufOnly.vim',
    lazy = false,
    keys = {
        { '<Leader>q', ':bdelete!<CR>', mode = 'n', silent = true, desc = 'Delete current buffer' },
        { '<Leader>Q', ':BufOnly!<CR>', mode = 'n', silent = true, desc = 'Keep only current buffer' },
        { '<F16>', ':BufOnly<CR>', mode = 'n', silent = true, desc = 'Keep only current buffer' },
    },
}
