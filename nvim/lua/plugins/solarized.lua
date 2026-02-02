return {
    'dracula/vim',
    init = function()
        vim.cmd([[
            augroup DraculaOverrides
                autocmd!
                autocmd ColorScheme dracula highlight DraculaBoundary guibg=none
                autocmd ColorScheme dracula highlight DraculaDiffDelete ctermbg=none guibg=none
                autocmd ColorScheme dracula highlight DraculaComment cterm=italic gui=italic
                autocmd ColorScheme dracula highlight DiffAdd guibg=#273b2d guifg=NONE
                autocmd ColorScheme dracula highlight DiffChange guibg=#2a2f3b guifg=NONE
                autocmd ColorScheme dracula highlight DiffText guibg=#3a3f4b guifg=NONE
                autocmd ColorScheme dracula highlight DiffDelete guibg=#3b2b2b guifg=#6272a4
                autocmd ColorScheme dracula highlight GitSignsStagedAdd guifg=#4c9a5a gui=bold
                autocmd ColorScheme dracula highlight GitSignsStagedChange guifg=#caa85a gui=bold
                autocmd ColorScheme dracula highlight GitSignsStagedDelete guifg=#d16d6d gui=bold
            augroup end
        ]])
        vim.cmd([[colorscheme dracula]])
    end,
}
