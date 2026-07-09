return {
    'github/copilot.vim',
    event = 'VimEnter',
    config = function()
        vim.g.copilot_no_tab_map = true
        vim.cmd([[
            imap <silent><script><expr> <Right> copilot#Accept("\<C-o>a")
        ]])
        -- Enable Copilot on startup and ignore errors if the command is unavailable
        vim.schedule(function()
            pcall(vim.cmd, 'Copilot enable')
        end)
    end,
}
