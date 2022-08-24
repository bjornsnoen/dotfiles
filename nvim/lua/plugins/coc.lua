return {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
        vim.cmd('source ' .. vim.fn.stdpath('config') .. '/lua/plugins/coc.vim')
        vim.keymap.set('n', '<leader>vc', ':e ~/.config/nvim/coc-settings.json<CR>')
    end,
}
