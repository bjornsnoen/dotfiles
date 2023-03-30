return {
    'github/copilot.vim',
    config = function()
        -- Translated :help copilot docs to lua
        -- imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
        -- let g:copilot_no_tab_map = v:true
        --
        -- Set the "Right" key to accept copilot suggestion, moving right if none was present
        vim.keymap.set('i', '<Right>', 'copilot#Accept("<C-o>l")', { expr = true })
        -- Disable tab mapping
        vim.g.copilot_no_tab_map = true
    end,
}
