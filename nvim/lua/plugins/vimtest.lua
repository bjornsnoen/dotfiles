return {
    'vim-test/vim-test',
    config = function()
        vim.keymap.set('n', '<silent> <Leader>t', ':TestNearest<CR>')
        vim.keymap.set('n', '<silent> <Leader>T', ':TestFile<CR>')
        vim.keymap.set('n', '<silent> <Leader>a', ':TestSuite<CR>')
        vim.keymap.set('n', '<F17>', ':TestSuite --strategy=jest<CR>')

        vim.cmd [[
            function! JestStrategy(cmd)
              let testName = matchlist(a:cmd, '\v -t ''(.*)''')[1]
              call vimspector#LaunchWithSettings( #{ configuration: 'jest', TestName: testName } )
            endfunction
            
            let g:test#custom_strategies = {'jest': function('JestStrategy')}
        ]]
    end
}


