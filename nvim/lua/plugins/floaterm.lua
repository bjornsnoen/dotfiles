return {
    'voldikss/vim-floaterm',
    lazy = false,
    init = function()
        vim.g.floaterm_keymap_toggle = '<F1>'
        vim.g.floaterm_keymap_next = '<F3>'
        vim.g.floaterm_keymap_prev = '<F2>'
        vim.g.floaterm_keymap_new = '<F4>'
        vim.g.floaterm_height = 0.8
        vim.g.floaterm_width = 0.8

        vim.keymap.set('i', '<F1>', '<ESC>:FloatermToggle<CR>')
    end,
}
