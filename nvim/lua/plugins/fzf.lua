return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')
        telescope.setup({
            defaults = {
                path_display = { 'smart' },
                mappings = {
                    i = {
                        ['<esc>'] = actions.close,
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                    },
                },
            },
        })
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<Leader>f', builtin.find_files, {})
        vim.keymap.set('n', '<Leader>r', builtin.live_grep, {})
        vim.keymap.set('n', '<Leader>g', builtin.git_branches, {})
        vim.keymap.set('n', '<Leader>G', builtin.git_status, {})
        vim.keymap.set('n', 'gi', function()
            builtin.lsp_references({ include_declaration = false })
        end, {})
        vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
    end,
}
