return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        { 'nvim-lua/popup.nvim' },
        { 'nvim-telescope/telescope-media-files.nvim' },
        { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    cmd = 'Telescope',
    keys = {
        {
            '<Leader>f',
            function()
                require('telescope.builtin').find_files({ hidden = true })
            end,
            desc = 'Find files (hidden)',
        },
        {
            '<Leader>F',
            function()
                require('telescope.builtin').find_files({ hidden = true, no_ignore = true })
            end,
            desc = 'Find files (all)',
        },
        {
            '<Leader>r',
            function()
                require('telescope.builtin').live_grep()
            end,
            mode = 'n',
            desc = 'Live grep',
        },
        {
            '<Leader>r',
            function()
                local builtin = require('telescope.builtin')
                vim.cmd('noau normal! "vy"')
                local text = vim.fn.getreg('v'):gsub('\n', '')
                vim.fn.setreg('v', {})
                if #text > 0 then
                    builtin.live_grep({ default_text = text })
                end
            end,
            mode = 'v',
            desc = 'Live grep selection',
        },
        {
            '<Leader>R',
            function()
                vim.cmd('normal vE')
                local builtin = require('telescope.builtin')
                vim.cmd('noau normal! "vy"')
                local text = vim.fn.getreg('v'):gsub('\n', '')
                vim.fn.setreg('v', {})
                if #text > 0 then
                    builtin.live_grep({ default_text = text })
                end
            end,
            desc = 'Live grep word',
        },
        {
            'gb',
            function()
                require('telescope.builtin').git_branches()
            end,
            desc = 'Git branches',
        },
        {
            'gu',
            function()
                require('telescope.builtin').lsp_references({ include_declaration = false, show_line = false })
            end,
            desc = 'LSP references',
        },
        {
            'gi',
            function()
                local has_omnisharp, omnisharp_extended = pcall(require, 'omnisharp_extended')
                if has_omnisharp then
                    for _, client in ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
                        if client.name == 'omnisharp' then
                            return omnisharp_extended.telescope_lsp_implementations()
                        end
                    end
                end
                return require('telescope.builtin').lsp_implementations()
            end,
            desc = 'LSP implementations',
        },
        {
            'gd',
            function()
                local has_omnisharp, omnisharp_extended = pcall(require, 'omnisharp_extended')
                if has_omnisharp then
                    for _, client in ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
                        if client.name == 'omnisharp' then
                            return omnisharp_extended.telescope_lsp_definitions()
                        end
                    end
                end
                return require('telescope.builtin').lsp_definitions()
            end,
            desc = 'LSP definitions',
        },
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
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown({
                        winblend = 10,
                        border = true,
                        previewer = false,
                        layout_config = {
                            width = 0.5,
                            height = 0.5,
                        },
                    }),
                },
                media_files = {
                    filetypes = { 'png', 'webp', 'jpg', 'jpeg', 'gif' },
                    find_cmd = 'rg',
                },
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = 'smart_case',
                },
            },
        })

        telescope.load_extension('fzf')
        telescope.load_extension('media_files')
        telescope.load_extension('ui-select')
    end,
}
