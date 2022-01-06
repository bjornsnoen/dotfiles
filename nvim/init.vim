let mapleader = "\<space>"

set expandtab
set shiftwidth=4
set tabstop=4
set number
set splitright
set termguicolors
set mouse=va

nmap <leader>ve :vsp ~/.config/nvim/init.vim<cr>
nmap <leader>vc :vsp ~/.config/nvim/coc-settings.json<cr>
nmap <leader>vr :source ~/.config/nvim/init.vim<cr>
nmap <leader>q :bufdo bdelete<cr>
map gf :edit <cfile><cr>


call plug#begin(stdpath('data') . '/plugged')

source ~/.config/nvim/plugins/airline.vim
source ~/.config/nvim/plugins/clipboard.vim
source ~/.config/nvim/plugins/coc.vim
source ~/.config/nvim/plugins/commentary.vim
source ~/.config/nvim/plugins/editorconfig.vim
source ~/.config/nvim/plugins/floaterm.vim
source ~/.config/nvim/plugins/fzf.vim
source ~/.config/nvim/plugins/incsearch.vim
source ~/.config/nvim/plugins/lastpage.vim
source ~/.config/nvim/plugins/nerdtree.vim
source ~/.config/nvim/plugins/polyglot.vim
source ~/.config/nvim/plugins/solarized.vim
source ~/.config/nvim/plugins/vim-fugitive.vim
source ~/.config/nvim/plugins/vimspector.vim
source ~/.config/nvim/plugins/zoom.vim

call plug#end()

doautocmd User PlugLoaded
