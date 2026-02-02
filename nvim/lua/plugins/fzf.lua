-- Helper function to ensure telescope opens files in the correct window context
-- This handles cases where telescope is invoked from special buffers like codecompanion or floaterm
local function with_normal_context(telescope_fn)
    return function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buf_name = vim.api.nvim_buf_get_name(current_buf)
        local buf_filetype = vim.bo[current_buf].filetype

        -- Check if we're in a special buffer (codecompanion, floaterm, etc.)
        local is_special_buffer = buf_filetype == 'codecompanion'
            or buf_filetype == 'floaterm'
            or buf_name:match('^/tmp/')
            or vim.bo[current_buf].buftype ~= ''

        if is_special_buffer then
            -- Find the most recent normal window (not special buffer)
            local windows = vim.api.nvim_list_wins()
            for _, win in ipairs(windows) do
                local win_buf = vim.api.nvim_win_get_buf(win)
                local win_buftype = vim.bo[win_buf].buftype
                local win_filetype = vim.bo[win_buf].filetype

                -- Check if this is a normal editable buffer
                if
                    win_buftype == ''
                    and win_filetype ~= 'codecompanion'
                    and win_filetype ~= 'floaterm'
                then
                    vim.api.nvim_set_current_win(win)
                    break
                end
            end
        end

        -- Now invoke telescope from the correct context
        telescope_fn()
    end
end

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
            '<Leader>b',
            function()
                require('telescope.builtin').buffers({ show_all_buffers = true })
            end,
            desc = 'Buffers (all)',
        },
        {
            '<Leader>f',
            with_normal_context(function()
                require('telescope.builtin').find_files({ hidden = true })
            end),
            desc = 'Find files (hidden)',
        },
        {
            '<Leader>F',
            with_normal_context(function()
                require('telescope.builtin').find_files({ hidden = true, no_ignore = true })
            end),
            desc = 'Find files (all)',
        },
        {
            '<Leader>r',
            with_normal_context(function()
                require('telescope.builtin').live_grep()
            end),
            mode = 'n',
            desc = 'Live grep',
        },
        {
            '<Leader>r',
            with_normal_context(function()
                local builtin = require('telescope.builtin')
                vim.cmd('noau normal! "vy"')
                local text = vim.fn.getreg('v'):gsub('\n', '')
                vim.fn.setreg('v', {})
                if #text > 0 then
                    builtin.live_grep({ default_text = text })
                end
            end),
            mode = 'v',
            desc = 'Live grep selection',
        },
        {
            '<Leader>R',
            with_normal_context(function()
                vim.cmd('normal vE')
                local builtin = require('telescope.builtin')
                vim.cmd('noau normal! "vy"')
                local text = vim.fn.getreg('v'):gsub('\n', '')
                vim.fn.setreg('v', {})
                if #text > 0 then
                    builtin.live_grep({ default_text = text })
                end
            end),
            desc = 'Live grep word',
        },
        {
            'gb',
            with_normal_context(function()
                require('telescope.builtin').git_branches()
            end),
            desc = 'Git branches',
        },
        {
            'gu',
            with_normal_context(function()
                require('telescope.builtin').lsp_references({ include_declaration = false, show_line = false })
            end),
            desc = 'LSP references',
        },
        {
            'gi',
            with_normal_context(function()
                local has_omnisharp, omnisharp_extended = pcall(require, 'omnisharp_extended')
                if has_omnisharp then
                    for _, client in ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
                        if client.name == 'omnisharp' then
                            return omnisharp_extended.telescope_lsp_implementations()
                        end
                    end
                end
                return require('telescope.builtin').lsp_implementations()
            end),
            desc = 'LSP implementations',
        },
        {
            'gd',
            with_normal_context(function()
                local has_omnisharp, omnisharp_extended = pcall(require, 'omnisharp_extended')
                if has_omnisharp then
                    for _, client in ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
                        if client.name == 'omnisharp' then
                            return omnisharp_extended.telescope_lsp_definitions()
                        end
                    end
                end
                return require('telescope.builtin').lsp_definitions()
            end),
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
