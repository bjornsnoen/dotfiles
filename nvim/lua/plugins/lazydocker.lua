return {
    'mgierada/lazydocker.nvim',
    dependencies = { 'akinsho/toggleterm.nvim' },
    cmd = 'Lazydocker',
    keys = {
        {
            '<leader>ld',
            function()
                require('lazydocker').open()
            end,
            desc = 'Open Lazydocker',
        },
    },
    opts = {
        border = 'curved',
        width = 1,
        height = 1,
    },
}
