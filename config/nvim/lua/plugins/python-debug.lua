return {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
        local pypath = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python'
        require('dap-python').setup(pypath)
    end,
}
