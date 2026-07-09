return {
    'chrisbra/csv.vim',
    ft = 'csv',
    config = function()
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'csv',
            callback = function()
                vim.opt_local.wrap = false
            end,
        })
    end,
}
