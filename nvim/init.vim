let mapleader = "\<space>"

set expandtab
set shiftwidth=4
set tabstop=4
set number
set splitright
set termguicolors

nmap <leader>ve :vsp ~/.config/nvim/init.vim<cr>
nmap <leader>vc :vsp ~/.config/nvim/coc-settings.json<cr>
nmap <leader>vr :source ~/.config/nvim/init.vim<cr>
nmap <leader>q :bufdo bdelete<cr>
map gf :edit <cfile><cr>


call plug#begin(stdpath('data') . '/plugged')
source ~/.config/nvim/plugins/airline.vim
source ~/.config/nvim/plugins/vim-fugitive.vim
source ~/.config/nvim/plugins/editorconfig.vim
source ~/.config/nvim/plugins/nerdtree.vim
source ~/.config/nvim/plugins/floaterm.vim
source ~/.config/nvim/plugins/solarized.vim
source ~/.config/nvim/plugins/coc.vim
source ~/.config/nvim/plugins/fzf.vim
source ~/.config/nvim/plugins/vimspector.vim
source ~/.config/nvim/plugins/commentary.vim
call plug#end()

doautocmd User PlugLoaded


let g:airline_theme = 'solarized_flood'
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
