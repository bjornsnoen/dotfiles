Plug 'tpope/vim-fugitive'

nmap <Leader>ga :Git add %<CR>
nmap <Leader>gA :Git add <C-r>=expand('%:p:h')<CR><CR>
nmap <Leader>gc :Git commit<CR>
nmap <Leader>gco :Git checkout 
nmap <Leader>gcf :Git checkout %<CR>
nmap <Leader>gP :Git -c push.default=current push<CR>
nmap <Leader>gp :Git pull --ff-only<CR>
nmap <Leader>gs :Git status<CR>
nmap <Leader>gb :G checkout -b 
nmap <Leader>gd :Git diff %<CR>
nmap <Leader>gD :Git diff --cached %<CR>
