return {
    'rhysd/conflict-marker.vim',
    event = { 'BufEnter' },
    config = function()
        vim.g.conflict_marker_enable_mappings = 0
        vim.keymap.set('n', '[x', '<Plug>(conflict-marker-prev-hunk)zz')
        vim.keymap.set('n', ']x', '<Plug>(conflict-marker-next-hunk)zz')
        vim.keymap.set('n', ']]', '<Plug>(conflict-marker-themselves)')
        vim.keymap.set('n', '[[', '<Plug>(conflict-marker-ourselves)')
        vim.keymap.set('n', '[]', '<Plug>(conflict-marker-both)')
    end,
}
