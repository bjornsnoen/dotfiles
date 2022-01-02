Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1

let g:NERDTreeDirArrowExpandable = '▹'
let g:NERDTreeDirArrowCollapsible = '▿'
let g:NERDTreeQuitOnOpen = 1

nnoremap <leader>n :NERDTreeToggle<CR>
nmap <leader>N :NERDTreeFind<CR>

" avoid crashes when calling vim-plug functions while the cursor is on the NERDTree window
let g:plug_window = 'noautocmd vertical topleft new'

let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderExtensionPatternMatching = 1
