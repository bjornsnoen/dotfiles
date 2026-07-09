return {
    'voldikss/vim-floaterm',
    init = function()
        vim.g.floaterm_keymap_toggle = '<F1>'
        vim.g.floaterm_keymap_next = '<F3>'
        vim.g.floaterm_keymap_prev = '<F2>'
        vim.g.floaterm_keymap_new = '<F4>'
        vim.g.floaterm_height = 0.8
        vim.g.floaterm_width = 0.8
    end,
    cmd = { 'FloatermToggle', 'FloatermNew', 'FloatermPrev', 'FloatermNext' },
    keys = {
        { '<F1>', '<cmd>FloatermToggle<CR>', mode = { 'n', 'i' }, silent = true, desc = 'Toggle Floaterm' },
        { '<F2>', '<cmd>FloatermPrev<CR>', mode = { 'n', 'i' }, silent = true, desc = 'Prev Floaterm' },
        { '<F3>', '<cmd>FloatermNext<CR>', mode = { 'n', 'i' }, silent = true, desc = 'Next Floaterm' },
        { '<F4>', '<cmd>FloatermNew<CR>', mode = { 'n', 'i' }, silent = true, desc = 'New Floaterm' },
    },
}
