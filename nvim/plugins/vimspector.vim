Plug 'puremourning/vimspector'

let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = [ 'debugpy', 'debugger-for-chrome', 'vscode-node-debug2' ]
let g:vimspector_base_dir='/home/bjorn/.local/share/nvim/plugged/vimspector'

nnoremap <Leader><F9> :call vimspector#ClearBreakpoints()<CR>
nnoremap <Leader>dq :VimspectorReset<CR>

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

nmap <Leader><F11> <Plug>VimspectorUpFrame
nmap <Leader><F12> <Plug>VimspectorDownFrame


let g:vimspector_sign_priority = {
  \    'vimspectorBP':         10,
  \    'vimspectorBPCond':     9,
  \    'vimspectorBPLog':      8,
  \    'vimspectorBPDisabled': 7,
  \    'vimspectorPC':         999,
  \ }
