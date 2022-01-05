Plug 'tpope/vim-fugitive'

nmap <Leader>ga :Git add %<CR>
nmap <Leader>gap :Git add -p %<CR>
nmap <Leader>gc :Git commit<CR>
nmap <Leader>gp :Git -c push.default=current push<CR>
nmap <Leader>gl :Git pull --ff-only<CR>
nmap <Leader>gs :Git status<CR>
nmap <Leader>gb :G checkout -b 
