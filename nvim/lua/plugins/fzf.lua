return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        {
            'nvim-lua/popup.nvim',
        },
        { 'nvim-telescope/telescope-media-files.nvim' },
    },
    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup({
            defaults = {
                path_display = { 'smart' },
                dynamic_preview_title = true,
                mappings = {
                    i = {
                        ['<esc>'] = actions.close,
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                    },
                },
                file_ignore_patterns = { '.git/' },
            },
            pickers = {
                live_grep = {
                    additional_args = function()
                        return { '--hidden' }
                    end,
                },
            },
            extensions = {
                media_files = {
                    filetypes = { 'png', 'webp', 'jpg', 'jpeg', 'gif' },
                    find_cmd = 'rg',
                },
            },
        })

        telescope.load_extension('fzf')
        telescope.load_extension('media_files')

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<Leader>f', function()
            builtin.find_files({ hidden = true })
        end, {})

        vim.keymap.set('n', '<Leader>r', builtin.live_grep, {})
        vim.keymap.set('n', '<Leader>g', builtin.git_branches, {})
        vim.keymap.set('n', '<Leader>G', builtin.git_status, {})
        vim.keymap.set('n', 'gi', function()
            builtin.lsp_references({ include_declaration = false, show_line = false })
        end, {})
        vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
    end,
}
