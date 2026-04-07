return {
    'tpope/vim-commentary',
    event = { 'BufEnter' },
    keys = {
        { 'gc', '<Plug>Commentary', mode = { 'n', 'v' }, desc = 'Comment toggle' },
        { 'gcc', '<Plug>CommentaryLine', mode = 'n', desc = 'Comment line' },
        -- Normal mode: behave like gcc without needing a motion
        { '<Leader>/', '<Plug>CommentaryLine', mode = 'n', remap = true, desc = 'Toggle comment' },
        { '<Leader>/', '<Plug>Commentary', mode = 'v', remap = true, desc = 'Toggle comment' },
    },
}
