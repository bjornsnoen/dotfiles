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
        { 'nvim-telescope/telescope-ui-select.nvim' },
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
            -- pickers = {
            --     live_grep = {
            --         additional_args = function()
            --             return { '--hidden' }
            --         end,
            --     },
            -- },
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

        local builtin = require('telescope.builtin')
        local has_omnisharp, omnisharp_extended = pcall(require, 'omnisharp_extended')

        local function has_omnisharp_client()
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
                if client.name == 'omnisharp' then
                    return true
                end
            end
            return false
        end

        local function lsp_definitions()
            if has_omnisharp and has_omnisharp_client() then
                return omnisharp_extended.telescope_lsp_definitions()
            end
            return builtin.lsp_definitions()
        end

        local function lsp_implementations()
            if has_omnisharp and has_omnisharp_client() then
                return omnisharp_extended.telescope_lsp_implementations()
            end
            return builtin.lsp_implementations()
        end
        vim.keymap.set('n', '<Leader>f', function()
            builtin.find_files({ hidden = true })
        end, {})
        vim.keymap.set('n', '<Leader>F', function()
            builtin.find_files({ hidden = true, no_ignore = true })
        end, {})

        vim.keymap.set('n', '<Leader>r', builtin.live_grep, {})
        vim.keymap.set('n', 'gb', builtin.git_branches, {})
        vim.keymap.set('n', 'gu', function()
            builtin.lsp_references({ include_declaration = false, show_line = false })
        end, {})
        vim.keymap.set('n', 'gi', lsp_implementations, {})
        vim.keymap.set('n', 'gd', lsp_definitions, {})

        local function getVisualSelection()
            vim.cmd('noau normal! "vy"')
            local text = vim.fn.getreg('v')
            vim.fn.setreg('v', {})

            text = string.gsub(text, '\n', '')
            if #text > 0 then
                return text
            else
                return ''
            end
        end

        local function grepVisualSelection()
            local search_for = getVisualSelection()
            if search_for ~= '' then
                builtin.live_grep({ default_text = search_for })
            end
        end

        vim.keymap.set('v', '<Leader>r', grepVisualSelection, { noremap = true, silent = true })
        vim.keymap.set('n', '<Leader>R', function()
            vim.cmd('normal vE')
            grepVisualSelection()
        end)
        vim.keymap.set('n', '<Leader>R', function()
            vim.cmd('normal vE')
            grepVisualSelection()
        end)
    end,
}
