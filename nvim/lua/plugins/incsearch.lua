return {
    'haya14busa/incsearch.vim',
    config = function()
        vim.opt.hlsearch = true
        vim.cmd([[noh]]) -- remove highlights that might be hanging about
        vim.g['incsearch#auto_nohlsearch'] = 1
        vim.keymap.set('', '/', '<Plug>(incsearch-forward)')
        vim.keymap.set('', '?', '<Plug>(incsearch-backward)')
        vim.keymap.set('', 'n', '<Plug>(incsearch-nohl-n)')
        vim.keymap.set('', 'N', '<Plug>(incsearch-nohl-N)')
    end,
}
