return {
    'tpope/vim-fugitive',
    config = function()
        vim.keymap.set('n', '<Leader>ga', ':Git add %<CR>', { silent = true })
        vim.keymap.set('n', '<Leader>gA', ":Git add <C-r>=expand('%:p:h')<CR><CR>", { silent = true })
        vim.keymap.set('n', '<Leader>gc', ':Git commit<CR>', { silent = true })
        vim.keymap.set('n', '<Leader>gco', ':Git checkout ')
        vim.keymap.set('n', '<Leader>gcf', ':Git checkout %<CR>', { silent = true })
        vim.keymap.set('n', '<Leader>gP', ':Git -c push.default=current push<CR>', { silent = true })
        vim.keymap.set('n', '<Leader>gp', ':Git pull --ff-only<CR>', { silent = true })
        vim.keymap.set('n', '<Leader>gd', ':Git difftool %<CR>', { silent = true })
        vim.keymap.set('n', '<Leader>gD', ':Git difftool --cached %<CR>', { silent = true })
        vim.keymap.set('n', '<Leader>gm', ':Git mergetool<CR>', { silent = true })
        vim.keymap.set('n', '<Leader>gs', ':Gvdiffsplit!<CR>', { silent = true })
    end,
}
