vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
    callback = function()
        if vim.fn.exists(':EslintFixAll') > 0 and vim.fn.executable('eslint') == 1 then
            vim.cmd('EslintFixAll')
        end
    end,
})

vim.api.nvim_create_user_command('Pr', function()
    local cmd = 'tmux split-window -h -c #{pane_current_path} gh pr create'
    local cmdtable = vim.fn.split(cmd)
    vim.notify(vim.inspect(cmdtable))
    vim.system(cmdtable)
end, {})

vim.api.nvim_create_user_command('Hotfix', function()
    local cmd = 'tmux split-window -h -c #{pane_current_path} gh pr create --base master'
    local cmdtable = vim.fn.split(cmd)
    vim.notify(vim.inspect(cmdtable))
    vim.system(cmdtable)
end, {})
