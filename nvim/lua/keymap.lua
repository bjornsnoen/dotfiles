vim.keymap.set('n', '<leader>ve', ':vsp ~/.config/nvim/init.lua<CR>', { silent = true })

vim.keymap.set('n', '<leader>vr', function()
    for name, _ in pairs(package.loaded) do
        if name:match('^plugins') or name:match('^opts') or name:match('^keymap') then
            package.loaded[name] = nil
        end
    end

    dofile(vim.env.MYVIMRC)
    vim.notify('Nvim configuration reloaded!', vim.log.levels.INFO)
end)

vim.keymap.set('n', 'gf', ':edit <cfile><CR>', { silent = true })
vim.keymap.set('n', 'tn', ':bn<CR>', { silent = true })
vim.keymap.set('n', 'tp', ':bp<CR>', { silent = true })
vim.keymap.set('n', '<Leader>wq', ':w<CR>|:bdelete<CR>', { silent = true })
vim.keymap.set('n', '<Leader>o', ':only<CR>', { silent = true })
vim.keymap.set('n', '<leader>l', ':LspRestart<CR>', { silent = true })

vim.keymap.set('n', '//', function()
    local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local folded = vim.fn.foldclosed(r)
    if folded == -1 then
        vim.cmd(':normal za')
    else
        vim.cmd(':normal zA')
    end
end)

vim.keymap.set('n', 'cn', ':cn<CR>', { silent = true })
vim.keymap.set('n', '<Leader>m', ':make<CR>', { silent = true })
vim.keymap.set('n', '<Leader>ee', ':e .env<CR>', { silent = true })
vim.keymap.set('n', '<Leader>er', ':e .envrc<CR>', { silent = true })

vim.keymap.set('n', '<Leader>b', function()
    local branchname = vim.fn.input('Branch name: ')
    vim.cmd('G checkout -b' .. branchname)
end)
