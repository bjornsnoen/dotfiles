vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
    callback = function()
        if vim.fn.exists(':EslintFixAll') > 0 and vim.fn.executable('eslint') == 1 then
            vim.cmd('EslintFixAll')
        end
    end,
})
