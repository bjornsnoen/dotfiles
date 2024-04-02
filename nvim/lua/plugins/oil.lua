return {
    'stevearc/oil.nvim',
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local oil = require('oil')
        oil.setup({
            keymaps = {
                ['<C-v>'] = 'actions.select_vsplit',
                ['q'] = 'actions.close',
            },
            float = {
                padding = 10,
            },
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
            },
        })
        vim.keymap.set('n', '<Leader>N', function()
            oil.toggle_float(vim.fn.getcwd())
        end, { noremap = true, silent = true })
        vim.keymap.set('n', '<Leader>n', oil.toggle_float, { silent = true })
    end,
}
