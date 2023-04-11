return {
    'dracula/vim',
    init = function()
        vim.cmd([[
            augroup DraculaOverrides
                autocmd!
                autocmd ColorScheme dracula highlight DraculaBoundary guibg=none
                autocmd ColorScheme dracula highlight DraculaDiffDelete ctermbg=none guibg=none
                autocmd ColorScheme dracula highlight DraculaComment cterm=italic gui=italic
            augroup end
        ]])
        vim.cmd([[colorscheme dracula]])
    end,
}
