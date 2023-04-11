return {
    'github/copilot.vim',
    config = function()
        -- Set the "Right" key to accept copilot suggestion, moving right if none was present
        -- There's fuckery afoot, prolly gonna need a fix from github themselves
        -- https://www.reddit.com/r/neovim/comments/12hlgfj/copilot_but_use_right_arrow_key_to_accept/

        vim.cmd([[
            imap <silent><script><expr> <Right> copilot#Accept("\<C-o>a")
        ]])

        -- Disable tab mapping
        vim.g.copilot_no_tab_map = true
    end,
}
