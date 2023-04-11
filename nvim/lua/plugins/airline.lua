return {
    {
        'vim-airline/vim-airline',
        init = function()
            vim.g.airline_powerline_fonts = 1
            vim.g.airline_skip_empty_sections = 1
            vim.g['airline#extensions#tabline#enabled'] = 1
            vim.g['airline#extensions#tabline#formatter'] = 'unique_tail_improved'
        end,
    },
    {
        'vim-airline/vim-airline-themes',
        init = function()
            vim.g.airline_theme = 'solarized_flood'
        end,
    },
}
