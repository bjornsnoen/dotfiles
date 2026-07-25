return {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        user_default_options = {
            rgb_fn = true,
            always_update = true,
            tailwind = true,
        },
    },
}
