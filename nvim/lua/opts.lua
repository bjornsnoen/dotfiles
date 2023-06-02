vim.g.mapleader = ' '

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.number = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.mouse = 'va'
vim.opt.scrolloff = 999
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false

vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'
vim.opt.updatetime = 250

-- Enables local nvim configs
vim.opt.exrc = true
vim.opt.secure = true

vim.cmd([[
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
]])

vim.cmd([[
" guard for distributions lacking the 'persistent_undo' feature.
if has('persistent_undo')
    " define a path to store persistent undo files.
    let target_path = expand('~/.config/vim-persisted-undo/')
    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif
    " point Vim to the defined undo directory.
    let &undodir = target_path
    " finally, enable undo persistence.
    set undofile
endif
]])
