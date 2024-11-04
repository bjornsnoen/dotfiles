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

-- "    let g:ftplugin_sql_omni_key_right = '<Right>'
vim.g.ftplugin_sql_omni_key_right = '<None>'

vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

vim.opt.updatetime = 250

-- Enables local nvim configs
vim.opt.exrc = true
vim.opt.secure = true

-- Don't display the "yanked x lines of text" error ever
vim.opt.report = 99999999

vim.cmd([[
let g:clipboard = {
     \   'name': 'myClipboard',
     \   'copy': {
     \      '+': ['wl-copy'],
     \      '*': ['wl-copy'],
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
