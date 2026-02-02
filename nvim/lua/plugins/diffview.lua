return {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles', 'Review' },
    keys = {
        {
            '<Leader>gv',
            function()
                local ok, lib = pcall(require, 'diffview.lib')
                if ok and lib.get_current_view() then
                    vim.cmd('DiffviewClose')
                    return
                end
                vim.cmd('DiffviewOpen')
            end,
            mode = 'n',
            silent = true,
            desc = 'Git diffview toggle',
        },
        { '<Leader>gV', ':DiffviewFileHistory<CR>', mode = 'n', silent = true, desc = 'Git diffview history' },
    },
    config = function()
        local actions = require('diffview.actions')

        local function focus_main_view()
            local ok, lib = pcall(require, 'diffview.lib')
            if not ok then
                return
            end

            local view = lib.get_current_view()
            if not view or not view.cur_layout then
                return
            end

            local main = view.cur_layout.get_main_win and view.cur_layout:get_main_win()
            if main and main.focus then
                main:focus()
            end
        end

        require('diffview').setup({
            hooks = {
                view_post_layout = function(view)
                    if view and view.panel and view.panel.is_open and view.panel:is_open() then
                        view.panel:close()
                    end
                end,
            },
            keymaps = {
                file_panel = {
                    { 'n', '<cr>', actions.focus_entry, { desc = 'Open diff and focus' } },
                    { 'n', 'o', actions.focus_entry, { desc = 'Open diff and focus' } },
                    { 'n', 'l', actions.focus_entry, { desc = 'Open diff and focus' } },
                    { 'n', '<2-LeftMouse>', actions.focus_entry, { desc = 'Open diff and focus' } },
                },
            },
        })

        vim.api.nvim_create_user_command('DiffviewClose', function()
            local ok = pcall(function()
                require('diffview').close()
            end)
            if not ok then
                vim.cmd('tabclose!')
            end
        end, { force = true })
        vim.api.nvim_create_user_command('Review', function()
            vim.cmd('DiffviewOpen --cached -uno')
            vim.schedule(focus_main_view)
        end, { force = true })
        local function disable_diff_wrap(win)
            if vim.wo[win].diff then
                vim.wo[win].wrap = false
            end
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            disable_diff_wrap(win)
        end

        vim.api.nvim_create_autocmd({ 'WinEnter', 'OptionSet' }, {
            callback = function()
                disable_diff_wrap(0)
            end,
        })
    end,
}
