return {
    'tpope/vim-commentary',
    event = { 'BufEnter' },
    keys = {
        { 'gc', '<Plug>Commentary', mode = { 'n', 'v' }, desc = 'Comment toggle' },
        { 'gcc', '<Plug>CommentaryLine', mode = 'n', desc = 'Comment line' },
        -- Normal mode: behave like gcc without needing a motion
        { '<Leader>/', 'gcc', mode = 'n', remap = true, desc = 'Toggle comment' },
        -- Visual mode: toggle comment and keep the selection active
        {
            '<Leader>/',
            function()
                local keys = vim.api.nvim_replace_termcodes('gcgv', true, false, true)
                vim.api.nvim_feedkeys(keys, 'x', false)
            end,
            mode = 'v',
            desc = 'Toggle comment',
        },
    },
}
