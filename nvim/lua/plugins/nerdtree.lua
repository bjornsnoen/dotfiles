return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('nvim-tree').setup({
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
            renderer = {
                add_trailing = true,
            },
        })
        vim.keymap.set('n', '<Leader>n', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<Leader>N', ':NvimTreeFindFileToggle<CR>', { silent = true })
    end,
}
