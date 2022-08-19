return {
    {
        'junegunn/fzf'
    },
    {
        'junegunn/fzf.vim',
        config = function()
            vim.g.fzf_layout = { up = '~90%', window = { width = 0.8, height = 0.8, yoffset = 0.5, xoffset = 0.5 } }
            vim.cmd [[
                let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
                " Customise the Files command to use rg which respects .gitignore files
                command! -bang -nargs=? -complete=dir Files
                    \ call fzf#run(fzf#wrap(
                        \ 'files',
                        \ fzf#vim#with_preview({
                            \ 'dir': <q-args>,
                            \ 'source': 'rg --files --hidden -g "!.git/" -g "!.venv/"'
                        \ }),
                    \ <bang>0))
                
                " Add an AllFiles variation that ignores .gitignore files
                command! -bang -nargs=? -complete=dir AllFiles
                    \ call fzf#run(fzf#wrap(
                        \ 'allfiles',
                        \ fzf#vim#with_preview({
                            \ 'dir': <q-args>,
                            \ 'source': 'rg --files --hidden -g "!.git/" --no-ignore'
                        \ }),
                    \ <bang>0))
                
                function! RipgrepFzf(query, fullscreen)
                  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
                  let initial_command = printf(command_fmt, shellescape(a:query))
                  let reload_command = printf(command_fmt, '{q}')
                  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
                  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
                endfunction
                
                command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)
            ]]
            vim.keymap.set('n', '<Leader>f', ':Files<CR>')
            vim.keymap.set('n', '<Leader>F', ':AllFiles<CR>')
            vim.keymap.set('n', '<Leader>r', ':Rg<CR>')
        end
    }
}




