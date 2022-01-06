let g:clipboard = {
     \   'name': 'myClipboard',
     \   'copy': {
     \      '+': ['gpaste-client', 'add'],
     \      '*': ['gpaste-client', 'add'],
     \    },
     \   'paste': {
     \      '+': '+',
     \      '*': '*',
     \   },
     \   'cache_enabled': 1,
     \ }

augroup ClipboardEvents
    autocmd!
    autocmd TextYankPost * let @+ = getreg(v:event.regname)
augroup end
