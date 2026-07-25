return {
    'dhruvasagar/vim-zoom',
    cmd = 'ZoomToggle',
    config = function()
        vim.cmd([[
            augroup PlugZoom
                autocmd!
                function! AirlineInit()
                    let g:airline_section_z = airline#section#create('%#__accent_bold#%{zoom#statusline()}%3l%#__restore__#/%L :%3v')
                endfunction
                autocmd User AirlineAfterInit call AirlineInit()
            augroup end

        ]])
    end,
}
