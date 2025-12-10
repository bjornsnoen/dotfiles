return {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
        vim.cmd([[
            imap <silent><script><expr> <Right> copilot#Accept("\<C-o>a")
        ]])
        vim.g.copilot_no_tab_map = true
    end,
}
