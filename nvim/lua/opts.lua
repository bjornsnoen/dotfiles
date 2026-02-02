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

local function has_cmd(cmd)
    return vim.fn.executable(cmd) == 1
end

local function set_clipboard(copy_cmd, paste_cmd, name)
    vim.g.clipboard = {
        name = name,
        copy = {
            ['+'] = copy_cmd,
            ['*'] = copy_cmd,
        },
        paste = {
            ['+'] = paste_cmd,
            ['*'] = paste_cmd,
        },
        cache_enabled = 0,
    }
    vim.opt.clipboard = 'unnamedplus'
end

-- Pick an OS-appropriate clipboard provider so configs stay committed across machines.
local function configure_clipboard()
    if vim.fn.has('wsl') == 1 and has_cmd('clip.exe') then
        set_clipboard('clip.exe', 'clip.exe -o', 'wsl-clip')
        return
    end

    if vim.fn.has('macunix') == 1 and has_cmd('pbcopy') then
        set_clipboard('pbcopy', 'pbpaste', 'mac')
        return
    end

    if has_cmd('wl-copy') and has_cmd('wl-paste') then
        set_clipboard('wl-copy', 'wl-paste --no-newline', 'wayland')
        return
    end

    if has_cmd('xclip') then
        set_clipboard('xclip -selection clipboard', 'xclip -selection clipboard -o', 'xclip')
    end
end

configure_clipboard()
