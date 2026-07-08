local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return require('lazy').setup('plugins', {
    dev = {
        path = '~/src/personal/nvim',
        -- Clone from GitHub when the local checkout is missing (e.g. fresh machines, CI)
        fallback = true,
    },
    -- No plugins require luarocks; skip hererocks bootstrap (checkhealth error otherwise)
    rocks = {
        enabled = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
    },
})
