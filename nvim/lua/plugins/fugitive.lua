return {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gwrite', 'Gread', 'Gvdiffsplit', 'Gdiffsplit', 'Gcommit', 'Gpull', 'Gpush', 'Gcheckout', 'Gstatus' },
    keys = {
        { '<Leader>ga', ':Git add %<CR>', mode = 'n', silent = true, desc = 'Git add buffer' },
        { '<Leader>gA', ":Git add <C-r>=expand('%:p:h')<CR><CR>", mode = 'n', silent = true, desc = 'Git add dir' },
        { '<Leader>gc', ':Git commit<CR>', mode = 'n', silent = true, desc = 'Git commit' },
        { '<Leader>gco', ':Git checkout ', mode = 'n', desc = 'Git checkout' },
        { '<Leader>gcf', ':Git checkout %<CR>', mode = 'n', silent = true, desc = 'Git checkout file' },
        { '<Leader>gP', ':Git -c push.default=current push<CR>', mode = 'n', silent = true, desc = 'Git push' },
        { '<Leader>gp', ':Git pull --ff-only<CR>', mode = 'n', silent = true, desc = 'Git pull' },
        { '<Leader>gd', ':Git difftool %<CR>', mode = 'n', silent = true, desc = 'Git difftool' },
        { '<Leader>gD', ':Git difftool --cached %<CR>', mode = 'n', silent = true, desc = 'Git difftool cached' },
        { '<Leader>gm', ':Git mergetool<CR>', mode = 'n', silent = true, desc = 'Git mergetool' },
        { '<Leader>gs', ':Gvdiffsplit!<CR>', mode = 'n', silent = true, desc = 'Git split diff' },
    },
}
