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
vim.keymap.set('n', 'ga', '<Leader>ga', { remap = true, silent = true, desc = 'Git add buffer' })
vim.keymap.set('n', 'tn', ':bn<CR>', { silent = true })
vim.keymap.set('n', 'tp', ':bp<CR>', { silent = true })
vim.keymap.set('n', 'gt', ':tabnext<CR>', { silent = true, desc = 'Next tab' })
vim.keymap.set('n', 'gT', ':tabprevious<CR>', { silent = true, desc = 'Prev tab' })
vim.keymap.set('n', '<Leader>wq', ':w<CR>|:bdelete<CR>', { silent = true })
vim.keymap.set('n', '<Leader>o', ':only<CR>', { silent = true })
vim.keymap.set('n', '<leader>l', ':LspRestart<CR>', { silent = true })

vim.keymap.set('n', '//', '<Cmd>silent! normal! za<CR>', { silent = true, desc = 'Toggle fold under cursor' })

vim.keymap.set('n', 'cn', ':cn<CR>', { silent = true })
vim.keymap.set('n', '<Leader>m', ':make<CR>', { silent = true })
vim.keymap.set('n', '<Leader>ee', ':e .env<CR>', { silent = true })
vim.keymap.set('n', '<Leader>er', ':e .envrc<CR>', { silent = true })

-- Make <C-w> in insert mode behave like normal mode for window navigation
vim.keymap.set('i', '<C-w>', '<Esc><C-w>', { silent = true, desc = 'Window command prefix, exit insert mode' })
