return {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
        local dap, dapui = require('dap'), require('dapui')
        dapui.setup({
            layouts = {
                {
                    elements = {
                        'stacks',
                        { id = 'scopes', size = 0.75 },
                    },
                    size = 40, -- 40 columns
                    position = 'left',
                },
                {
                    elements = {
                        'repl',
                        'console',
                    },
                    size = 0.25, -- 25% of total lines
                    position = 'bottom',
                },
            },
        })
        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        vim.keymap.set('n', '<Leader>dq', function()
            dap.disconnect()
            dap.close()
            dapui.close({})

            for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
                local name = vim.api.nvim_buf_get_name(buffer)
                if name:match('.*%[dap%-repl%]') then
                    vim.api.nvim_buf_delete(buffer, { force = true })
                end
            end
        end)
    end,
}
