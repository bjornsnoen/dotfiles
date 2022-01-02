let mapleader = "\<space>"

set expandtab
set shiftwidth=4
set tabstop=4
set number
set splitright

vnoremap <leader>p "_dP

nmap <leader>ve :edit ~/.config/nvim/init.vim<cr>
nmap <leader>vc :edit ~/.config/nvim/coc-settings.json<cr>
nmap <leader>vr :source ~/.config/nvim/init.vim<cr>


call plug#begin(stdpath('data') . '/plugged')
source ~/.config/nvim/plugins/airline.vim
source ~/.config/nvim/plugins/vim-fugitive.vim
source ~/.config/nvim/plugins/editorconfig.vim
source ~/.config/nvim/plugins/nerdtree.vim
source ~/.config/nvim/plugins/floaterm.vim
call plug#end()


let g:airline_theme = 'solarized_flood'
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
