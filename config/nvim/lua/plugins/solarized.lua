return {
    'folke/tokyonight.nvim',
    lazy = false,
    opts = {
        style = 'night',
    },
    init = function()
        require('tokyonight').setup({
            style = 'night',
        })
        vim.cmd('colorscheme tokyonight')
    end,
}
