return {
    'neoclide/coc.nvim',
    branch = "release",
    config = function() vim.cmd('source ' .. vim.fn.stdpath('config') .. '/lua/plugins/coc.vim') end
}
