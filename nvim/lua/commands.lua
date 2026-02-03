vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
    callback = function()
        if vim.fn.exists(':LspEslintFixAll') > 0 then
            pcall(vim.cmd, 'LspEslintFixAll')
        elseif vim.fn.exists(':EslintFixAll') > 0 then
            pcall(vim.cmd, 'EslintFixAll')
        end

        pcall(vim.lsp.buf.format, {
            bufnr = 0,
            async = false,
            timeout_ms = 5000,
        })
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

-- For floaterm buffers, make gf open the file in the previous window
-- and hide the floaterm instead of editing in the float.
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'floaterm',
    callback = function(ev)
        vim.keymap.set('n', 'gf', function()
            local file = vim.fn.expand('<cfile>')
            if file == '' then
                return
            end

            -- go to the window you were in before the floaterm
            vim.cmd('wincmd p')

            -- open the file there
            vim.cmd('edit ' .. vim.fn.fnameescape(file))

            -- hide all floaterms
            vim.cmd('silent! FloatermHide!')
        end, { buffer = ev.buf, silent = true })
    end,
})
