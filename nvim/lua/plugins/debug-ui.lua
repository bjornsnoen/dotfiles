return {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap' },
    config = function()
        local dap, dapui = require('dap'), require('dapui')
        dapui.setup()
        dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
        end
        dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
        end
        vim.keymap.set('n', '<Leader>dq', function()
            dap.disconnect()
            dapui.close()

            for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
                local name = vim.api.nvim_buf_get_name(buffer)
                if name:match('.*%[dap%-repl%]') then
                    vim.api.nvim_buf_delete(buffer, { force = true })
                end
            end
        end)
    end,
}
