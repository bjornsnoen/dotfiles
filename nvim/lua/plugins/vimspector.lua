return {
    'puremourning/vimspector',
    config = function()
        vim.g.vimspector_enable_mappings = 'HUMAN'
        vim.g.vimspector_install_gadgets = { 'debugpy', 'debugger-for-chrome', 'vscode-node-debug2' }
        vim.g.vimspector_base_dir = '/home/bjorn/.local/share/nvim/plugged/vimspector'

        vim.keymap.set('n', '<Leader><F9>', ":call vimspector#ClearBreakpoints()<CR>", { noremap = true })
        vim.keymap.set('n', '<Leader>dq', ':VimspectorReset<CR>')
        -- for normal mode - the word under the cursor
        vim.keymap.set('n', '<Leader>di', '<Plug>VimspectorBalloonEval')
        -- for visual mode, the visually selected text
        vim.keymap.set('x', '<Leader>di', '<Plug>VimspectorBalloonEval')
        vim.keymap.set('n', '<Leader><F11>', '<Plug>VimspectorUpFrame')
        vim.keymap.set('n', '<Leader><F12>', '<Plug>VimspectorDownFrame')
        vim.g.vimspector_sign_priority = {
            vimspectorBP = 10,
            vimspectorBPCond = 9,
            vimspectorBPLog = 8,
            vimspectorBPDisabled = 7,
            vimspectorPC = 999,
        }
    end
}




