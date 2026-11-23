vim.g.mapleader = ' '

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.number = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.fillchars:append({ diff = '╱' })
vim.opt.mouse = 'va'
vim.opt.scrolloff = 999
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

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

-- Read locally so p never waits for an OSC 52 reply; use terminal paste for external text.
-- :help clipboard-osc52 (the built-in writer also handles base64 encoding).
local function local_paste()
    return { vim.fn.getreg('"', 1, true), vim.fn.getregtype('"') }
end

vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = local_paste,
        ['*'] = local_paste,
    },
}
vim.opt.clipboard = 'unnamedplus'
