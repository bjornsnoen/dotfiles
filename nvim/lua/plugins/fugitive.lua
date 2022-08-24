return {
    'tpope/vim-fugitive',
    config = function()
        vim.keymap.set('n', '<Leader>ga', ':Git add %<CR>')
        vim.keymap.set('n', '<Leader>gA', ":Git add <C-r>=expand('%:p:h')<CR><CR>")
        vim.keymap.set('n', '<Leader>gc', ':Git commit<CR>')
        vim.keymap.set('n', '<Leader>gco', ':Git checkout ')
        vim.keymap.set('n', '<Leader>gcf', ':Git checkout %<CR>')
        vim.keymap.set('n', '<Leader>gP', ':Git -c push.default=current push<CR>')
        vim.keymap.set('n', '<Leader>gp', ':Git pull --ff-only<CR>')
        vim.keymap.set('n', '<Leader>gb', ':G checkout -b ')
        vim.keymap.set('n', '<Leader>gd', ':Git difftool %<CR>')
        vim.keymap.set('n', '<Leader>gD', ':Git difftool --cached %<CR>')
        vim.keymap.set('n', '<Leader>gm', ':Git mergetool<CR>')
        vim.keymap.set('n', '<Leader>gs', ':Gvdiffsplit!<CR>')
    end,
}
