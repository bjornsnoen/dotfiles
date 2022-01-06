Plug 'tpope/vim-fugitive'

nmap <Leader>ga :Git add %<CR>
nmap <Leader>gaa :Git add <C-r>=expand('%:p:h')<CR><CR>
nmap <Leader>gap :Git add -p %<CR>
nmap <Leader>gc :Git commit<CR>
nmap <Leader>gco :Git checkout 
nmap <Leader>gp :Git -c push.default=current push<CR>
nmap <Leader>gl :Git pull --ff-only<CR>
nmap <Leader>gs :Git status<CR>
nmap <Leader>gb :G checkout -b 
