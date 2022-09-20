return {
    'mfussenegger/nvim-dap',
    config = function()
        local dap = require('dap')
        vim.keymap.set('n', '<F5>', dap.continue)
        vim.keymap.set('n', '<F29>', dap.run_last)
        vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
        vim.keymap.set('n', '<F10>', dap.step_over)
        vim.keymap.set('n', '<F11>', dap.step_into)
        vim.keymap.set('n', '<F12>', dap.step_out)
    end,
}
