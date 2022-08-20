return {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap' },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
        vim.keymap.set('n', '<Leader>dq', function()
            dap.disconnect()
            dapui.close()
        end)
    end
}
