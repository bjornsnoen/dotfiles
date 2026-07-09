return {
    'tpope/vim-commentary',
    event = { 'BufEnter' },
    keys = {
        -- Normal mode: behave like gcc without needing a motion
        { '<Leader>/', '<Plug>CommentaryLine', mode = 'n', remap = true, desc = 'Toggle comment' },
        { '<Leader>/', '<Plug>Commentary', mode = 'v', remap = true, desc = 'Toggle comment' },
    },
}
