Plug 'puremourning/vimspector'

let g:vimspector_enable_mappings = 'HUMAN'

nnoremap <Leader><F9> :call vimspector#ClearBreakpoints()<CR>
nnoremap <Leader>dq :VimspectorReset<CR>

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

nmap <Leader><F11> <Plug>VimspectorUpFrame
nmap <Leader><F12> <Plug>VimspectorDownFrame
